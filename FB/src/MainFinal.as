package 
{
	import com.doitflash.air.extensions.webView.MyWebView;
	import com.doitflash.air.extensions.webView.MyWebViewEvent;
	import flash.utils.setTimeout;
	
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	import com.doitflash.starling.utils.list.List;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.tools.sizeControl.FileSizeConvertor;
	
	import com.luaye.console.C;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.filesystem.File;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 4/27/2015 2:43 PM
	 */
	public class MainFinal extends Sprite 
	{
		private var _ex:MyWebView;
		
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		[Embed(source = "sound01.mp3")]
		private var MySound:Class;
		
		public function MainFinal():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 100;
			C.width = 500;
			C.height = 250;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Rich WebView V" + MyWebView.VERSION + " for adobe air</b></font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
			onResize();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void 
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleDeactivate(e:Event):void 
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
			{
				e.preventDefault();
				
				NativeApplication.nativeApplication.exit();
			}
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
			var src:File = File.applicationDirectory.resolvePath("webview");
			var dis:File = File.documentsDirectory.resolvePath("webview");
			if (dis.exists) dis.deleteDirectory(true);
			src.copyTo(dis, true);
			
			_ex = new MyWebView(this.stage);
			trace("stageSize: ", stage.stageWidth, stage.stageHeight);
			_ex.addEventListener(MyWebViewEvent.BACK_CLICKED, onBackClicked);
			_ex.addEventListener(MyWebViewEvent.PAGE_STARTED, onPageStarted);
			_ex.addEventListener(MyWebViewEvent.PAGE_PROGRESS, onPageProgress);
			_ex.addEventListener(MyWebViewEvent.PAGE_FINISHED, onPageFinished);
			_ex.addEventListener(MyWebViewEvent.RECEIVED_MASSAGE_FROM_JS, onReceivedMassage);
			_ex.addEventListener(MyWebViewEvent.RECEIVED_SSL_ERROR, onReceivedError);
			
			var btn1:MySprite = createBtn("openWebView");
			btn1.addEventListener(MouseEvent.CLICK, openWebViewLocal);
			_list.add(btn1);
			
			function openWebViewLocal(e:MouseEvent):void
			{
				var file:File = File.documentsDirectory.resolvePath("webview/index.html");
				_ex.openWebViewLocal(0, 0, stage.stageWidth, stage.stageHeight, file);
			}
		}
		
		private function onBackClicked(e:MyWebViewEvent):void
		{
			if (_ex.canGoBack) _ex.goBack();
			else _ex.closeWebView();
		}
		
		private function onPageStarted(e:MyWebViewEvent):void
		{
			trace("onPageStarted");
		}
		
		private function onPageFinished(e:MyWebViewEvent):void
		{
			trace("onPageFinished");
		}
		
		private function onPageProgress(e:MyWebViewEvent):void
		{
			trace("onPageProgress progress: ", e.param);
		}
		
		private function onReceivedMassage(e:MyWebViewEvent):void
		{
			trace("onReceivedMassage: ", e.param);
			C.log("onReceivedMassage: ", e.param);
			
			var msg:Array;
			if (_ex.os == MyWebView.ANDROID) msg = String(e.param).split("|");
			else if(_ex.os == MyWebView.IOS) msg = String(e.param).split("%7C");
			var command:String = msg[0];
			
			switch (command) 
			{
				case "toPlaySound":
					
					var voice:Sound = (new MySound) as Sound;
					voice.play();
					
					break;
				case "toOpenJSAlert":
					
					_ex.callJS("diplayAlert('This is a message from Flash!')");
					
					break;
				case "changePosition":
					
					_ex.setPosition(msg[1], msg[2], (stage.stageWidth - msg[3]), (stage.stageHeight - msg[4]));
					
					break;
				case "pageDown":
					
					_ex.pageDown(false);
					
					break;
				case "endPage":
					
					_ex.pageDown(true);
					
					break;
				case "pageUp":
					
					_ex.pageUp(false);
					
					break;
				case "firstPage":
					
					_ex.pageUp(true);
					
					break;
				case "zoomIn":
					
					if (_ex.os == MyWebView.IOS)
					{
						_ex.maximumZoomScale = 5;
						_ex.minimumZoomScale = 0.5;
					}
					_ex.zoomIn();
					
					break;
				case "zoomOut":
					
					if (_ex.os == MyWebView.IOS)
					{
						_ex.maximumZoomScale = 5;
						_ex.minimumZoomScale = 0.5;
					}
					_ex.zoomOut();
					
					break;
				case "reload":
					
					_ex.reload();
					
					break;
				case "flingScroll":
					
					_ex.filingScroll(msg[1], msg[2]);
					
					break;
				case "scrollBy":
					
					_ex.scrollBy(msg[1], msg[2]);
					
					break;
				case "scrollTo":
					
					_ex.scrollTo(_ex.scrollX, (_ex.scrollY + int(msg[1])));
					
					break;
				case "closeWebView":
					
					_ex.closeWebView();
					
					break;
				default:
			}
		}
		
		private function onReceivedError(e:MyWebViewEvent):void
		{
			C.log("onReceivedError: " + e.param);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}