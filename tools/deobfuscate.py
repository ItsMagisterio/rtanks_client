#!/usr/bin/env python3
"""Batch deobfuscation helper for ActionScript sources.

Usage examples:
  python tools/deobfuscate.py --scan
  python tools/deobfuscate.py --map tools/deobf_map.csv --dry-run
  python tools/deobfuscate.py --map tools/deobf_map.csv --apply
"""

from __future__ import annotations

import argparse
import csv
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

OBFUSCATED_RE = re.compile(r"\b(?:name|var|method|const)_[0-9]+\b")


@dataclass(frozen=True)
class RenameRule:
    old: str
    new: str
    regex: re.Pattern[str]


def iter_as_files(root: Path) -> Iterable[Path]:
    yield from sorted(root.rglob("*.as"))


def scan_obfuscated_names(src_root: Path) -> dict[str, int]:
    counts: dict[str, int] = {}
    for file_path in iter_as_files(src_root):
        text = file_path.read_text(encoding="utf-8")
        for token in OBFUSCATED_RE.findall(text):
            counts[token] = counts.get(token, 0) + 1
    return counts


def load_rules(path: Path) -> list[RenameRule]:
    if not path.exists():
        raise FileNotFoundError(f"Mapping file was not found: {path}")

    rules: list[RenameRule] = []
    seen_old: set[str] = set()
    seen_new: set[str] = set()

    with path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.reader(f)
        for idx, row in enumerate(reader, start=1):
            if not row or (row[0].strip().startswith("#")):
                continue
            if len(row) < 2:
                raise ValueError(f"Invalid mapping row #{idx}: expected 2 columns, got {row}")

            old = row[0].strip()
            new = row[1].strip()

            if not old or not new:
                raise ValueError(f"Invalid mapping row #{idx}: empty old/new value")
            if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", old):
                raise ValueError(f"Invalid old identifier at row #{idx}: {old}")
            if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", new):
                raise ValueError(f"Invalid new identifier at row #{idx}: {new}")
            if old == new:
                continue
            if old in seen_old:
                raise ValueError(f"Duplicate old identifier in mapping: {old}")
            if new in seen_new:
                raise ValueError(
                    f"Duplicate target identifier in mapping: {new}. "
                    "Use unique names to reduce accidental collisions."
                )

            seen_old.add(old)
            seen_new.add(new)
            rules.append(RenameRule(old=old, new=new, regex=re.compile(rf"\b{re.escape(old)}\b")))

    return rules


def apply_rules_to_file(path: Path, rules: list[RenameRule]) -> tuple[int, str]:
    text = path.read_text(encoding="utf-8")
    changed = 0

    for rule in rules:
        text, replacements = rule.regex.subn(rule.new, text)
        changed += replacements

    return changed, text


def write_report(report_path: Path, rows: list[tuple[str, int]]) -> None:
    lines = ["# Deobfuscation report", "", f"Changed files: {len(rows)}", ""]
    for file_path, replacements in rows:
        lines.append(f"- `{file_path}`: {replacements} replacements")
    lines.append("")
    report_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="ActionScript deobfuscation helper")
    parser.add_argument("--src", default="src", help="Source root with .as files (default: src)")
    parser.add_argument("--map", dest="map_path", default="tools/deobf_map.csv", help="CSV mapping file")
    parser.add_argument("--scan", action="store_true", help="Only scan obfuscated identifiers")
    parser.add_argument("--dry-run", action="store_true", help="Show what would change, do not write files")
    parser.add_argument("--apply", action="store_true", help="Apply replacements to files")
    parser.add_argument(
        "--report",
        default="tools/deobf_report.md",
        help="Markdown report output path (default: tools/deobf_report.md)",
    )

    args = parser.parse_args()
    src_root = Path(args.src)

    if not src_root.exists():
        print(f"Source path does not exist: {src_root}", file=sys.stderr)
        return 2

    if args.scan:
        counts = scan_obfuscated_names(src_root)
        print(f"Found {len(counts)} unique obfuscated identifiers")
        for name, count in sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[:100]:
            print(f"{name},{count}")
        return 0

    if not args.apply and not args.dry_run:
        print("Choose one mode: --scan OR --dry-run OR --apply", file=sys.stderr)
        return 2

    rules = load_rules(Path(args.map_path))
    if not rules:
        print("No rename rules loaded (mapping is empty or no-op).")
        return 0

    file_rows: list[tuple[str, int]] = []
    for path in iter_as_files(src_root):
        replacements, new_text = apply_rules_to_file(path, rules)
        if replacements <= 0:
            continue

        file_rows.append((str(path), replacements))
        if args.apply:
            path.write_text(new_text, encoding="utf-8")

    action = "Would change" if args.dry_run else "Changed"
    print(f"{action} {len(file_rows)} files")
    for file_path, replacements in file_rows:
        print(f"- {file_path}: {replacements}")

    write_report(Path(args.report), file_rows)
    print(f"Report written to {args.report}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
