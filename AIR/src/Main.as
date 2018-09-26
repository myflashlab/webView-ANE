package
{
import com.myflashlab.air.extensions.dependency.OverrideAir;
import com.myflashlab.air.extensions.webView.RichWebView;
import com.myflashlab.air.extensions.webView.RichWebViewEvent;
import com.myflashlab.air.extensions.webView.RichWebViewSettings;
import com.myflashlab.air.extensions.webView.HtmlDataSettings;
import com.myflashlab.air.extensions.nativePermissions.PermissionCheck;
import com.doitflash.consts.Direction;
import com.doitflash.consts.Orientation;
import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
import com.doitflash.starling.utils.list.List;
import com.doitflash.text.modules.MySprite;
import com.luaye.console.C;
import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.StatusEvent;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import com.greensock.TweenMax;
import com.greensock.easing.*;
import flash.utils.setTimeout;
import air.net.URLMonitor;
import com.doitflash.tools.DynamicFunc;

/**
 *
 * @author Hadi Tavakoli - 10/11/2015 4:14 PM
 */
public class Main extends Sprite
{
	private var _ex:RichWebView;

	private const BTN_WIDTH:Number = 150;
	private const BTN_HEIGHT:Number = 60;
	private const BTN_SPACE:Number = 2;
	private var _txt:TextField;
	private var _body:Sprite;
	private var _list:List;
	private var _numRows:int = 1;

	[Embed(source = "sound01.mp3")]
	private var MySound:Class;

	public function Main():void
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
		_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Rich WebView V" + RichWebView.VERSION + " for adobe air</b></font>";
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

		C.log("iOS is crazy with understanding stageWidth and stageHeight, you already now that :)");
		C.log("So, we should wait a couple of seconds before initializing RichWebview to make sure the stage dimention is stable before passing it through the ANE.");
		setTimeout(checkPermissions, 2500);
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

	private function checkPermissions():void
	{
		// first you need to make sure you have access to the Location if you are on Android?
		PermissionCheck.init();

		var permissionState:int = PermissionCheck.check(PermissionCheck.SOURCE_LOCATION);

		if (permissionState == PermissionCheck.PERMISSION_UNKNOWN || permissionState == PermissionCheck.PERMISSION_DENIED)
		{
			PermissionCheck.request(PermissionCheck.SOURCE_LOCATION, onRequestResult);
		}
		else
		{
			init();
		}

		function onRequestResult($obj:Object):void
		{
			C.log("permission for " + $obj.source + ": " + prettify($obj.state));
			if ($obj.state != PermissionCheck.PERMISSION_GRANTED)
			{
				C.log("You did not allow the app the required permissions!");
			}
			else
			{
				init();
			}
		}
	}
	
	private function myDebuggerDelegate($ane:String, $class:String, $msg:String):void
	{
		trace("["+$ane+"-"+$class+"]"+$msg);
	}
	
	private function init():void
	{
		// remove this line when building for production
		OverrideAir.enableDebugger(myDebuggerDelegate);
		
		var src:File = File.applicationDirectory.resolvePath("demoHtml");

		// if you are using the documentsDirectory on Android, then you need to ask for the PermissionCheck.SOURCE_STORAGE permission
		//var dis:File = File.documentsDirectory.resolvePath("demoHtml");

		var dis:File = File.applicationStorageDirectory.resolvePath("demoHtml");
		if (dis.exists) dis.deleteDirectory(true);
		if (!dis.exists) src.copyTo(dis, true);

		// make sure stage is not null when you're initializing RichWebView
		_ex = new RichWebView(this.stage);
		_ex.addEventListener(RichWebViewEvent.BACK_CLICKED, onBackClicked);
		_ex.addEventListener(RichWebViewEvent.PAGE_STARTING, onPageStarting);
		_ex.addEventListener(RichWebViewEvent.PAGE_STARTED, onPageStarted);
		_ex.addEventListener(RichWebViewEvent.PAGE_PROGRESS, onPageProgress);
		_ex.addEventListener(RichWebViewEvent.PAGE_FINISHED, onPageFinished);
		_ex.addEventListener(RichWebViewEvent.RECEIVED_MESSAGE_FROM_JS, onReceivedMessage);
		_ex.addEventListener(RichWebViewEvent.RECEIVED_SSL_ERROR, onReceivedError);
		_ex.addEventListener(RichWebViewEvent.SCREENSHOT, onScreenshot);
		_ex.addEventListener(RichWebViewEvent.TOUCH, onTouch);

		// set optional RichWebview settings (apply these settings AFTER initializing the ANE and BEFORE opening a webpage)
		RichWebViewSettings.ENABLE_BITMAP_CAPTURE = true;
		RichWebViewSettings.ENABLE_COOKIES = true;
		RichWebViewSettings.ENABLE_THIRD_PARTY_COOKIES = true;
		RichWebViewSettings.ENABLE_GPS = true;
		RichWebViewSettings.ENABLE_ZOOM = true;
		RichWebViewSettings.ENABLE_SCROLL_BOUNCE = false;
		RichWebViewSettings.BG_COLOR_HEX = "#FFFFFFFF"; // AARRGGBB
		//RichWebViewSettings.USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.36 (KHTML, like Gecko) Chrome/13.0.766.0 Safari/534.36"; // useful when you are trying to load embedded YouTube or Vimeo videos
		RichWebViewSettings.ENABLE_AIR_PREFIX = true; // This property works on Android ONLY and is set to true by default.
		RichWebViewSettings.MEDIA_PLAYBACK_REQUIRES_USER_GESTURE = true;

		// initialize the embedded Browser feature
		if (!_ex.isEmbeddedBrowserInitialized)
		{
			_ex.addEventListener(RichWebViewEvent.EMBEDDED_BROWSER_NAVIGATION_EVENT, onEmbeddedBrowserNavigationEvent);
			_ex.addEventListener(RichWebViewEvent.EMBEDDED_BROWSER_ACTION, onEmbeddedBrowserAction);
			_ex.initEmbeddedBrowser();
		}

		// set optional settings for the embedded browser - Android side
		RichWebViewSettings.EMBEDDED_BROWSER.android.toolbarColor = "#3F51B5";
		RichWebViewSettings.EMBEDDED_BROWSER.android.secondaryToolbarColor = "#303F9F";
		RichWebViewSettings.EMBEDDED_BROWSER.android.addMenuItem("item 1", true);
		RichWebViewSettings.EMBEDDED_BROWSER.android.addMenuItem("item 2");
		RichWebViewSettings.EMBEDDED_BROWSER.android.addMenuItem("item 3");
		RichWebViewSettings.EMBEDDED_BROWSER.android.addMenuItem("item 4");
		RichWebViewSettings.EMBEDDED_BROWSER.android.actionButton("ic_default_action_btn_for_custom_tab", "action btn description"); // use the Resource Manager Tool to add the icon into "richWebView.ane"
		RichWebViewSettings.EMBEDDED_BROWSER.android.enableUrlBarHiding = true;
		RichWebViewSettings.EMBEDDED_BROWSER.android.closeBtnIcon = "ic_default_close_btn_for_custom_tab"; // use the Resource Manager Tool to add the icon into "richWebView.ane"
		RichWebViewSettings.EMBEDDED_BROWSER.android.showTitle = true;
		RichWebViewSettings.EMBEDDED_BROWSER.android.defaultShareMenuItem = true;
		RichWebViewSettings.EMBEDDED_BROWSER.android.isWeakActivity = false;
		RichWebViewSettings.EMBEDDED_BROWSER.android.mayLaunchUrl = "https://www.google.com/";

		// set optional settings for the embedded browser - iOS side
		RichWebViewSettings.EMBEDDED_BROWSER.ios.barColor = "#CCCCCC"; // if iOS < 10, nothing happens
		RichWebViewSettings.EMBEDDED_BROWSER.ios.controlColor = "#AAAAAA"; // if iOS < 10, nothing happens

		// ---------------------------------------------------------------------------------------------------------------------

		if (_ex.isEmbeddedBrowserSupported())
		{
			var btn0:MySprite = createBtn("open Embedded Browser");
			btn0.addEventListener(MouseEvent.CLICK, openEmbeddedBrowser);
			_list.add(btn0);
		}

		// ---------------------------------------------------------------------------------------------------------------------

		function openEmbeddedBrowser(e:MouseEvent):void
		{
			var result:Boolean = _ex.openEmbeddedBrowser("https://www.google.com/");

			if (!result)
			{
				C.log("could not open! Possible reasons are:");
				C.log("1) Have you called \"_ex.initEmbeddedBrowser();\"? ");
				C.log("2) Make sure all the \"RichWebViewSettings.EMBEDDED_BROWSER\" parameters are valid.");
			}
		}

		function onEmbeddedBrowserNavigationEvent(e:RichWebViewEvent):void
		{
			switch (e.param)
			{
				case RichWebViewEvent.EMBEDDED_BROWSER_NAVIGATION_STARTED:

					trace("EMBEDDED_BROWSER NAVIGATION_STARTED");

					break;
				case RichWebViewEvent.EMBEDDED_BROWSER_NAVIGATION_FINISHED:

					trace("EMBEDDED_BROWSER NAVIGATION_FINISHED");

					break;
				case RichWebViewEvent.EMBEDDED_BROWSER_NAVIGATION_FAILED:

					trace("EMBEDDED_BROWSER NAVIGATION_FAILED");

					break;
				case RichWebViewEvent.EMBEDDED_BROWSER_NAVIGATION_ABORTED:

					trace("EMBEDDED_BROWSER NAVIGATION_ABORTED");

					break;
				case RichWebViewEvent.EMBEDDED_BROWSER_CLOSED:

					trace("EMBEDDED_BROWSER CLOSED");
					C.log("EMBEDDED_BROWSER CLOSED");

					break;
				default:
			}
		}

		function onEmbeddedBrowserAction(e:RichWebViewEvent):void
		{
			trace("--------- onEmbeddedBrowserAction ------------");
			trace("item = " + e.param.item);
			trace("url = " + e.param.url);
			trace("----------------------------------------------");

			C.log("--------- onEmbeddedBrowserAction ------------");
			C.log("item = " + e.param.item);
			C.log("url = " + e.param.url);
			C.log("----------------------------------------------");
		}

		// ---------------------------------------------------------------------------------------------------------------------

		var btn1:MySprite = createBtn("open HTML Data");
		btn1.addEventListener(MouseEvent.CLICK, openHtmlData);
		_list.add(btn1);

		function openHtmlData(e:MouseEvent):void
		{
			// this listener must be removed for the HTML String to be successfully load on the iOS side.
			_ex.removeEventListener(RichWebViewEvent.PAGE_STARTING, onPageStarting);

			var dataSettings:HtmlDataSettings = new HtmlDataSettings();

			dataSettings.baseUrl = null;
			dataSettings.encoding = "UTF-8";
			dataSettings.mimeType = "text/html";
			dataSettings.historyUrl = null; // this property has no effect on the iOS side
			dataSettings.data = "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\"><title>RichWebView ANE</title></head><body><p>This is a String which is shown on the RichWebView ANE as an HTML content.<br><br>Enjoy Building AIR apps<br><a href=\"http://www.myflashlabs.com/\">myflashlabs Team</a></p></body></html>";

			_ex.openData(0, 0, stage.stageWidth, stage.stageHeight, dataSettings);
		}

		// ---------------------------------------------------------------------------------------------------------------------

		var btn2:MySprite = createBtn("openWebView");
		btn2.addEventListener(MouseEvent.CLICK, openWebViewLocal);
		_list.add(btn2);

		function openWebViewLocal(e:MouseEvent):void
		{
			if (!_ex.hasEventListener(RichWebViewEvent.PAGE_STARTING)) _ex.addEventListener(RichWebViewEvent.PAGE_STARTING, onPageStarting);

			//_ex.openWebViewLocal(0, 0, stage.stageWidth, stage.stageHeight, File.documentsDirectory.resolvePath("demoHtml/index.html"));
			_ex.openWebViewLocal(0, 0, stage.stageWidth, stage.stageHeight, File.applicationStorageDirectory.resolvePath("demoHtml/index.html"));
			//_ex.openWebViewURL(0, 0, stage.stageWidth, stage.stageHeight, "https://google.com/");

			// opening a pdf in iOS is very straight forward like this:
			//_ex.openWebViewURL(0, 0, stage.stageWidth, stage.stageHeight, "http://www.myflashlabs.com/showcase/test.pdf");

			// but Android cannot open pdf files but yet, you can use google proxy to open it like this:
			//_ex.openWebViewURL(0, 0, stage.stageWidth, stage.stageHeight, "http://docs.google.com/gview?embedded=true&url=http://www.myflashlabs.com/showcase/test.pdf");

			// to open local PDF files, check here: http://www.myflashlabs.com/product/pdf-reader-ane-adobe-air-native-extension/

			/*var monitor:URLMonitor;
			 var url:URLRequest = new URLRequest("https://www.google.com");
			 url.method = "HEAD";
			 monitor = new URLMonitor(url);
			 monitor.pollInterval = 3000;
			 monitor.addEventListener(StatusEvent.STATUS, onConnection);

			 monitor.start();*/
		}


		onResize();
	}

	private function onBackClicked(e:RichWebViewEvent):void
	{
		C.log("onBackClicked");
		if (_ex.canGoBack) _ex.goBack();
		else _ex.closeWebView();
	}

	private function onPageStarting(e:RichWebViewEvent):void
	{
		C.log("onPageStarting url = " + e.param);
		trace("onPageStarting url = " + e.param);

		if (String(e.param).indexOf("mailto:") == 0)
		{
			_ex.callJS("diplayAlert('You have decided to let Air handle this type of links! > mailto:*****')");
		}
		else if (String(e.param).indexOf("tel:") == 0)
		{
			_ex.callJS("diplayAlert('You have decided to let Air handle this type of links! > tel:*****')");
		}
		else
		{
			// for any other link types, you have to call this method.
			_ex.shouldContinueLoadingTheURL();
		}
	}

	private function onPageStarted(e:RichWebViewEvent):void
	{
		C.log("onPageStarted = " + e.param);
		trace("onPageStarted = " + e.param);
	}

	private function onPageFinished(e:RichWebViewEvent):void
	{
		C.log("onPageFinished");
		trace("onPageFinished");
	}

	private function onPageProgress(e:RichWebViewEvent):void
	{
		C.log("onPageProgress progress: ", e.param);
		trace("onPageProgress progress: ", e.param);
	}

	private function onReceivedMessage(e:RichWebViewEvent):void
	{
		C.log("onReceivedMessage: ", e.param);
		trace("onReceivedMessage: ", e.param);

		DynamicFunc.run(this, e.param);
	}

	private function onReceivedError(e:RichWebViewEvent):void
	{
		C.log("onReceivedError: " + e.param);
	}

	private function onScreenshot(e:RichWebViewEvent):void
	{
		_ex.closeWebView();

		C.log("onScreenshot: " + e.param);

		var bm:Bitmap = new Bitmap(e.param, "auto", true);
		this.addChild(bm);

		TweenMax.from(bm, 5, {width:100, height:100, onComplete:onZoomDone} );

		function onZoomDone():void
		{
			TweenMax.to(bm, 1, {alpha:0, onComplete:onFadeoutDone} );
		}

		function onFadeoutDone():void
		{
			removeChild(bm);
			bm.bitmapData.dispose();
			bm = null;
		}
	}

	private function onTouch(e:RichWebViewEvent):void
	{
		trace("onTouch > " + "x = " + e.param.x + " y = " + e.param.y);
	}

	// --------------------------------------------------------------------------------- funcs to be called from JS

	public function closeWebView():void
	{
		_ex.closeWebView();
	}

	public function toOpenJSAlert():void
	{
		_ex.callJS("diplayAlert('This is a message from Flash!')");
	}

	public function toPlaySound():void
	{
		var voice:Sound = (new MySound) as Sound;
		voice.play();
	}

	public function changePosition($marginLeft:Number, $marginTop:Number, $marginRight:Number, $marginBottom:Number):void
	{
		_ex.setViewPort(new Rectangle($marginLeft, $marginTop, (stage.stageWidth - $marginRight), (stage.stageHeight - $marginBottom)));
	}

	public function pageUp($value:Boolean):void
	{
		_ex.pageUp($value);
	}

	public function pageDown($value:Boolean):void
	{
		_ex.pageDown($value);
	}

	public function zoomIn():void
	{
		if (_ex.os == RichWebView.IOS)
		{
			_ex.maximumZoomScale = 5;
			_ex.minimumZoomScale = 0.5;
		}

		_ex.zoomIn();
	}

	public function zoomOut():void
	{
		if (_ex.os == RichWebView.IOS)
		{
			_ex.maximumZoomScale = 5;
			_ex.minimumZoomScale = 0.5;
		}
		_ex.zoomOut();
	}

	public function toTakeScreenshot():void
	{
		_ex.requestBitmap();
	}

	public function parseJson($str:String):void
	{
		trace(decodeURIComponent($str));
	}

	// ------------------------------------------------------------------------------------------------------------



































	private function prettify($state:int):String
	{
		var str:String;

		switch($state)
		{
			case PermissionCheck.PERMISSION_UNKNOWN:

				str = "UNKNOWN";

				break;
			case PermissionCheck.PERMISSION_DENIED:

				str = "DENIED";

				break;
			case PermissionCheck.PERMISSION_GRANTED:

				str = "GRANTED";

				break;
			case PermissionCheck.PERMISSION_OS_ERR:

				str = "Not available on this OS!";

				break;
		}

		return str;
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