package alternativa.osgi.service.console
{
   import alternativa.osgi.OSGi;
   import alternativa.osgi.service.command.class_16;
   import alternativa.osgi.service.command.name_43;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import package_242.name_821;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;

   public class Console implements name_27
   {
      private static const DEFAULT_BG_COLOR:uint = 0;
      private static const DEFAULT_FONT_COLOR:uint = 65280;
      private static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("Courier New",12,DEFAULT_FONT_COLOR);
      private static const TOKENIZER:RegExp = /(?:[^"\s]+)|(?:"[^"]*")/g;

      private var stage:Stage;
      private var container:Sprite;
      private var output:TextField;
      private var input:TextField;
      private var commandHandlers:Object = {};
      private var variables:Object = {};
      private var commandHistory:Array = [];
      private var commandHistoryIndex:int = 0;
      private var _height:int;
      private var _width:int;
      private var _alpha:Number = 0.9;
      private var _bgColor:uint = 0;
      private var align:int;
      private var visible:Boolean;
      private var preventInput:Boolean;
      private var commandService:name_43;
      private var lastError:Error;

      public function Console(commandService:name_43, stage:Stage, width:int, height:int, hAlign:int, vAlign:int)
      {
         super();
         this.commandService = commandService;
         this.stage = stage;
         this.container = new Sprite();
         this.container.mouseEnabled = false;
         this.container.tabEnabled = false;
         this.container.tabChildren = false;
         this.initInput();
         this.initOutput();
         this.setSize(width,height);
         this.horizontalAlignment = hAlign;
         this.vericalAlignment = vAlign;
         this.initDefaultCommands();
         this.printGreeting();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.addEventListener(Event.RESIZE,this.onResize);

         commandService.name_822("console","hide","Спрятать консоль",[],this.cmdHide);
         commandService.name_822("console","copy","Скопировать содержимое консоли в буфер обмена",[],this.cmdCopy);
         commandService.name_822("cmd","clear","Очистить консоль",[],this.cmdClear);
         commandService.name_822("cmd","e","Показать последний exception",[],this.cmdLastException);
         commandService.name_822("console","height","Установить высоту консоли",[int],this.cmdHeight);
         commandService.name_822("console","width","Установить ширину консоли",[int],this.cmdWidth);
         commandService.name_822("console","halign","Выравнивание по горизонтали",[int],this.cmdHAlign);
         commandService.name_822("console","valign","Выравнивание по вертикали",[int],this.cmdVAlign);
         commandService.name_822("console","alpha","Установить прозрачность консоли",[Number],this.cmdAlpha);
         commandService.name_822("console","bg","Установить цвет фона",[uint],this.cmdBg);
         commandService.name_822("console","fg","Установить цвет шрифта",[uint],this.cmdFg);
         commandService.name_822("vars","list","Посмотреть список переменных",[],this.cmdVarsList);
         commandService.name_822("vars","show","Посмотреть переменную",[String],this.cmdVarsShow);
         commandService.name_822("vars","set","Установить значение переменной",[String,String],this.cmdVarsSet);
         commandService.name_822("hacks","send_command","Send command to server",[String],this.sendCommandToServer);
      }

      public function method_209(value:String) : void
      {
         this.addLine(value);
      }

      public function method_207(prefix:String, value:String) : void
      {
         this.method_209(prefix + " " + value);
      }

      public function method_208(values:Vector.<String>) : void
      {
         for each(var value:String in values)
         {
            this.method_209(value);
         }
      }

      public function method_210(prefix:String, values:Vector.<String>) : void
      {
         for each(var value:String in values)
         {
            this.method_207(prefix,value);
         }
      }

      public function method_212(variable:name_821) : void
      {
         this.variables[variable.name_829()] = variable;
      }

      public function method_215(variableName:String) : void
      {
         delete this.variables[variableName];
      }

      public function method_213() : Boolean
      {
         return this.visible;
      }

      public function show() : void
      {
         if(this.visible)
         {
            return;
         }
         this.visible = true;
         this.stage.addChild(this.container);
         this.stage.focus = this.input;
         this.resize();
      }

      public function hide() : void
      {
         if(!this.visible)
         {
            return;
         }
         this.visible = false;
         if(this.stage.contains(this.container))
         {
            this.stage.removeChild(this.container);
         }
         this.stage.focus = this.stage;
      }

      public function setSize(width:int, height:int) : void
      {
         this._width = width;
         this._height = height;
         this.resize();
      }

      public function set width(value:int) : void
      {
         this.setSize(value,this._height);
      }

      public function get width() : int
      {
         return this._width;
      }

      public function set height(value:int) : void
      {
         this.setSize(this._width,value);
      }

      public function get height() : int
      {
         return this._height;
      }

      public function set horizontalAlignment(value:int) : void
      {
         value = this.clampAlign(value);
         this.align = this.align & ~3 | value;
         this.resize();
      }

      public function get horizontalAlignment() : int
      {
         return this.align & 3;
      }

      public function set vericalAlignment(value:int) : void
      {
         value = this.clampAlign(value);
         this.align = this.align & ~12 | value << 2;
         this.resize();
      }

      public function get vericalAlignment() : int
      {
         return this.align >> 2 & 3;
      }

      public function set alpha(value:Number) : void
      {
         this._alpha = value;
         this.resize();
      }

      public function get alpha() : Number
      {
         return this._alpha;
      }

      public function method_211(command:String, handler:Function) : void
      {
         this.commandHandlers[command] = handler;
      }

      public function method_214(command:String) : void
      {
         delete this.commandHandlers[command];
      }

      public function name_51(command:String) : void
      {
         this.runCommand(command);
      }

      public function write(message:String, color:uint = 0) : void
      {
         this.addLine(message);
      }

      public function clear() : void
      {
         this.output.text = "";
      }

      private function onResize(e:Event) : void
      {
         this.resize();
      }

      private function resize() : void
      {
         if(!this.visible)
         {
            return;
         }
         var cw:int = Math.min(this._width,this.stage.stageWidth);
         var ch:int = Math.min(this._height,this.stage.stageHeight);
         this.container.x = this.alignPosition(this.horizontalAlignment,this.stage.stageWidth,cw);
         this.container.y = this.alignPosition(this.vericalAlignment,this.stage.stageHeight,ch);
         this.output.width = cw - 1;
         this.input.width = cw - 1;
         this.output.height = ch - this.input.height;
         this.input.y = this.output.height;
         var gfx:Graphics = this.container.graphics;
         gfx.clear();
         gfx.beginFill(this._bgColor,this._alpha);
         gfx.drawRect(0,0,cw,ch);
         gfx.endFill();
      }

      private function initInput() : void
      {
         this.input = new TextField();
         this.input.defaultTextFormat = DEFAULT_TEXT_FORMAT;
         this.input.height = 20;
         this.input.type = TextFieldType.INPUT;
         this.input.border = true;
         this.input.borderColor = DEFAULT_FONT_COLOR;
         this.input.textColor = DEFAULT_FONT_COLOR;
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
         this.input.addEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp);
         this.input.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         this.container.addChild(this.input);
      }

      private function initOutput() : void
      {
         this.output = new TextField();
         this.output.defaultTextFormat = DEFAULT_TEXT_FORMAT;
         this.output.type = TextFieldType.DYNAMIC;
         this.output.border = true;
         this.output.borderColor = DEFAULT_FONT_COLOR;
         this.output.textColor = DEFAULT_FONT_COLOR;
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.container.addChild(this.output);
      }

      private function onInputKeyDown(e:KeyboardEvent) : void
      {
         if(this.isToggleKey(e))
         {
            this.preventInput = true;
         }
         switch(e.keyCode)
         {
            case Keyboard.ENTER:
               this.runCommand(this.input.text);
               this.input.text = "";
               break;
            case Keyboard.ESCAPE:
               if(this.input.text != "")
               {
                  this.input.text = "";
               }
               else
               {
                  setTimeout(this.hide,50);
               }
               break;
            case Keyboard.UP:
               this.historyUp();
               break;
            case Keyboard.DOWN:
               this.historyDown();
               break;
            case Keyboard.PAGE_UP:
               this.output.scrollV -= 10;
               break;
            case Keyboard.PAGE_DOWN:
               this.output.scrollV += 10;
         }
         e.stopPropagation();
      }

      private function onInputKeyUp(e:KeyboardEvent) : void
      {
         if(!this.isToggleKey(e))
         {
            e.stopPropagation();
         }
      }

      private function onTextInput(e:TextEvent) : void
      {
         if(this.preventInput)
         {
            e.preventDefault();
            this.preventInput = false;
         }
      }

      private function onKeyUp(e:KeyboardEvent) : void
      {
         if(this.isToggleKey(e))
         {
            if(this.visible)
            {
               this.hide();
            }
            else
            {
               this.show();
            }
         }
      }

      private function isToggleKey(e:KeyboardEvent) : Boolean
      {
         return e.keyCode == Keyboard.K && e.ctrlKey && e.shiftKey;
      }

      private function runCommand(text:String) : void
      {
         if(text == null || text.match(/^\s*$/))
         {
            return;
         }
         if(this.commandHistory.length == 0 || this.commandHistory[this.commandHistory.length - 1] != text)
         {
            this.commandHistory.push(text);
         }
         this.commandHistoryIndex = this.commandHistory.length;
         this.addLine("> " + text);

         var tokens:Array = text.match(TOKENIZER);
         if(tokens == null || tokens.length == 0)
         {
            return;
         }
         var commandName:String = tokens.shift();
         var variable:name_821 = this.variables[commandName];
         if(variable != null)
         {
            if(tokens.length == 0)
            {
               this.method_209(variable.toString());
            }
            else
            {
               var errorMessage:String = variable.name_828(String(tokens[0]));
               if(errorMessage == null)
               {
                  this.method_209("New value " + variable.toString());
               }
               else
               {
                  this.method_209(errorMessage);
               }
            }
            return;
         }

         var handler:Function = this.commandHandlers[commandName];
         if(handler != null)
         {
            handler.call(null,this,tokens);
            return;
         }

         try
         {
            this.commandService.execute(text,this);
         }
         catch(e:Error)
         {
            this.lastError = e;
            this.method_209(e.message);
         }
      }

      private function addLine(text:String) : void
      {
         this.output.appendText(text + "\n");
         this.output.scrollV = this.output.maxScrollV;
      }

      private function historyUp() : void
      {
         if(this.commandHistoryIndex == 0)
         {
            return;
         }
         --this.commandHistoryIndex;
         this.input.text = this.commandHistory[this.commandHistoryIndex];
      }

      private function historyDown() : void
      {
         if(this.commandHistoryIndex >= this.commandHistory.length - 1)
         {
            return;
         }
         ++this.commandHistoryIndex;
         this.input.text = this.commandHistory[this.commandHistoryIndex];
      }

      private function printGreeting() : void
      {
         this.addLine("Alternativa console");
         this.addLine("Type cmdlist to get list of commands");
      }

      private function initDefaultCommands() : void
      {
         this.method_211("clear",this.localClear);
         this.method_211("close",this.localClose);
         this.method_211("copy",this.localCopy);
         this.method_211("fontsize",this.localFontSize);
         this.method_211("cmdlist",this.localCmdList);
         this.method_211("varlist",this.localVarList);
         this.method_211("varlistv",this.localVarListV);
      }

      private function localClear(console:name_27, args:Array) : void { this.clear(); }
      private function localClose(console:name_27, args:Array) : void { setTimeout(this.hide,100); }
      private function localCopy(console:name_27, args:Array) : void { System.setClipboard(this.output.text); }

      private function localFontSize(console:name_27, args:Array) : void
      {
         if(args.length == 0)
         {
            return;
         }
         var size:int = int(args[0]);
         if(size <= 0)
         {
            return;
         }
         var format:TextFormat = this.output.defaultTextFormat;
         format.size = size;
         this.output.defaultTextFormat = format;
         this.input.defaultTextFormat = format;
      }

      private function localCmdList(console:name_27, args:Array) : void
      {
         for(var key:String in this.commandHandlers)
         {
            this.method_209(key);
         }
      }

      private function localVarList(console:name_27, args:Array) : void { this.printVariables(args.length > 0 ? args[0] : null,false); }
      private function localVarListV(console:name_27, args:Array) : void { this.printVariables(args.length > 0 ? args[0] : null,true); }

      private function printVariables(start:String, showValues:Boolean) : void
      {
         var result:Array = [];
         for(var key:String in this.variables)
         {
            if(start == null || start == "" || key.indexOf(start) == 0)
            {
               result.push(showValues ? key + " = " + name_821(this.variables[key]).toString() : key);
            }
         }
         result.sort();
         for each(var line:String in result)
         {
            this.method_209(line);
         }
      }

      private function clampAlign(value:int) : int
      {
         if(value < 1)
         {
            return 1;
         }
         if(value > 3)
         {
            return 3;
         }
         return value;
      }

      private function alignPosition(mode:int, parent:int, child:int) : int
      {
         if(mode == 2)
         {
            return (parent - child) * 0.5;
         }
         if(mode == 3)
         {
            return parent - child;
         }
         return 0;
      }

      private function cmdHide(out:class_16) : void { setTimeout(this.hide,100); }
      private function cmdCopy(out:class_16) : void { System.setClipboard(this.output.text); out.method_209("Content has been copied to clipboard"); }
      private function cmdClear(out:class_16) : void { this.clear(); }
      private function cmdLastException(out:class_16) : void { if(this.lastError != null) { out.method_209(this.lastError.getStackTrace()); } }
      private function cmdHeight(out:class_16, value:int) : void { this.height = value; }
      private function cmdWidth(out:class_16, value:int) : void { this.width = value; }
      private function cmdHAlign(out:class_16, value:int) : void { this.horizontalAlignment = value; }
      private function cmdVAlign(out:class_16, value:int) : void { this.vericalAlignment = value; }
      private function cmdAlpha(out:class_16, value:Number) : void { this.alpha = value; }
      private function cmdBg(out:class_16, value:uint) : void { this._bgColor = value; this.resize(); out.method_209("Background color set to " + value); }

      private function cmdFg(out:class_16, value:uint) : void
      {
         var format:TextFormat = this.output.defaultTextFormat;
         format.color = value;
         this.output.defaultTextFormat = format;
         this.output.textColor = value;
         this.input.defaultTextFormat = format;
         this.input.textColor = value;
         out.method_209("Foreground color set to " + value);
      }

      private function cmdVarsList(out:class_16) : void
      {
         for(var key:String in this.variables)
         {
            out.method_209(key);
         }
      }

      private function cmdVarsShow(out:class_16, key:String) : void
      {
         var variable:name_821 = this.variables[key];
         if(variable == null)
         {
            throw new name_823(key);
         }
         out.method_209(variable.toString());
      }

      private function cmdVarsSet(out:class_16, key:String, value:String) : void
      {
         var variable:name_821 = this.variables[key];
         if(variable == null)
         {
            throw new name_823(key);
         }
         var oldValue:String = variable.toString();
         var error:String = variable.name_828(value);
         if(error != null)
         {
            throw new name_826(key,value,error);
         }
         out.method_209("New value " + variable.toString() + ", old value=" + oldValue);
      }

      private function sendCommandToServer(out:class_16, command:String) : void
      {
         Network(OSGi.getInstance().getService(INetworker)).send(command);
      }
   }
}
