#!/usr/bin/env python3
import re
from pathlib import Path

AUTH = Path('docs/server/Auth.java').read_text(encoding='utf-8')

m = re.search(r'private static final String AES_DATA = "([^"]+)";', AUTH)
if not m:
    raise SystemExit('AES_DATA constant not found')
aes_data = m.group(1)

raw = f"system;set_aes_data;{aes_data}"

# Mirrors ProtocolTransfer.encodeOutbound with initial outKeyCursor=1
keys = [1,2,3,4,5,6,7,8,9]
out_key_cursor = 1
key = (out_key_cursor + 1) % len(keys)
if key <= 0:
    key = 1
encoded = str(key) + ''.join(chr(ord(c) + (key + 1)) for c in raw)
packet = encoded + 'end~'

assert len(packet) == 3976, f"Expected packet length 3976, got {len(packet)}"
assert packet.startswith('2v|vwhp>vhwbdhvbgdwd>'), 'Unexpected encoded prefix for first server packet'

print('OK: encoded set_aes_data packet length=', len(packet))
print('OK: prefix=', packet[:32])
