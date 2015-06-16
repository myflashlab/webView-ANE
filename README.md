# Rich WebView ANE V1.0 (Android+iOS)
This extension is a perfect replacement to the classic StageWebView and it allows you to easily call Javascript functions from flash and send String messages from JS to flash.

checkout here for the commercial version: http://myappsnippet.com/webview-ane/

you may like to see the ANE in action? check this out: https://github.com/myflashlab/webView-ANE/tree/master/FD/dist

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

![WebView ANE](http://myappsnippet.com/wp-content/uploads/2015/06/web-view-adobe-air-extension_preview.jpg)

# AS3 API:
```actionscript
import com.doitflash.air.extensions.webView.MyWebView;
import com.doitflash.air.extensions.webView.MyWebViewEvent;

var _ex:MyWebView = new MyWebView(stage);

// add listeners
_ex.addEventListener(MyWebViewEvent.BACK_CLICKED, onBackClicked);
_ex.addEventListener(MyWebViewEvent.PAGE_STARTED, onPageStarted);
_ex.addEventListener(MyWebViewEvent.PAGE_PROGRESS, onPageProgress);
_ex.addEventListener(MyWebViewEvent.PAGE_FINISHED, onPageFinished);
_ex.addEventListener(MyWebViewEvent.RECEIVED_SSL_ERROR, onReceivedError);
_ex.addEventListener(MyWebViewEvent.RECEIVED_MASSAGE_FROM_JS, onReceivedMassage);

// you may load an html file on sdcard like this
var file:File = File.documentsDirectory.resolvePath("webview/index.html");
_ex.openWebViewLocal(0, 0, stage.stageWidth, stage.stageHeight, file);

// or you may load an online url as follow
_ex.openWebViewURL(0, 0, stage.stageWidth, stage.stageHeight, "http://www.google.com/");

function onBackClicked(e:MyWebViewEvent):void
{
	if (_ex.canGoBack) _ex.goBack();
	else _ex.closeWebView();
}

function onPageStarted(e:MyWebViewEvent):void
{
	trace("page started to be loaded");
}

function onPageProgress(e:MyWebViewEvent):void
{
	trace("page loading: " + e.param + "%");
}

function onPageFinished(e:MyWebViewEvent):void
{
	trace("page load completed");
}

function onReceivedError(e:MyWebViewEvent):void
{
	trace("error = " + e.param);
}

function onReceivedMassage(e:MyWebViewEvent):void
{
	trace("onReceivedMassage: ", e.param);
}
```

# Setup Javascript:
to be able to interact with your flash app from JS, you need to import our little .js file named "Bridge.js" which you can find in **bin/webview** folder and in your html files, all you have to do is to import this little js into the head tag like this
```html
<script type="text/javascript" src="Bridge.js"></script>
```
Now, you are able to easily call JS functions from flash like this:
```actionscript
_ex.callJS("diplayAlert('This is a message from Flash!')");
```

and on JS side, you can send String messages to flash like this:
```javascript
Bridge.call("toVibrate");
```

This extension works on Android SDK 9 or higher and iOS 6.1 or higher

This extension does not require any special setup in the air manifest .xml file