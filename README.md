# Rich WebView ANE V4.0 (Android+iOS)
This extension is a perfect replacement to the classic StageWebView and it allows you to easily call Javascript functions from flash and send String messages from JS to flash. it also gives you many new features that the classic StageWebView couldn't provide. Features like File pick or GPS access.

checkout here for the commercial version: http://myappsnippet.com/product/webview-ane/

you may like to see the ANE in action? check this out: https://github.com/myflashlab/webView-ANE/tree/master/FD/dist

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

![WebView ANE](http://myappsnippet.com/wp-content/uploads/2015/06/web-view-adobe-air-extension_preview.jpg)

# Main Features:
* Call JS funcs from flash and vice versa
* Control the Scroll position
* Change the view port size and position at runtime
* Play video files inside the webview
* Take full screenshots from your webview object
* Get GPS location information in to your JS
* Enable file picker dialog on your HTML input fields
* change viewport and position of webview at runtime

Tutorials:
* [How to enable GPS in Rich Webview ANE?](http://myappsnippet.com/adobe-air-stagewebview-gps/)
* [How to Open file picker on the input html fields?](http://myappsnippet.com/adobe-air-html-file-pick-webview/)

# AS3 API:
```actionscript
import com.doitflash.air.extensions.webView.MyWebView;
import com.doitflash.air.extensions.webView.MyWebViewEvent;

var _ex = new MyWebView(this.stage, true, true, true, true); // stage, enableBitmapCapture, enableCookies, enableGps, enableZoom

// add listeners
if(_ex.os == MyWebView.ANDROID) C.log("Android SDK version: ", _ex.sdkVersion);
_ex.addEventListener(MyWebViewEvent.BACK_CLICKED, onBackClicked);
_ex.addEventListener(MyWebViewEvent.PAGE_STARTED, onPageStarted);
_ex.addEventListener(MyWebViewEvent.PAGE_PROGRESS, onPageProgress);
_ex.addEventListener(MyWebViewEvent.PAGE_FINISHED, onPageFinished);
_ex.addEventListener(MyWebViewEvent.RECEIVED_MASSAGE_FROM_JS, onReceivedMassage);
_ex.addEventListener(MyWebViewEvent.RECEIVED_SSL_ERROR, onReceivedError);
_ex.addEventListener(MyWebViewEvent.SCREENSHOT, onScreenshot);

_ex.openWebViewLocal(0, 0, stage.stageWidth, stage.stageHeight, File.documentsDirectory.resolvePath("webview/index.html"));
//_ex.openWebViewURL(0, 0, stage.stageWidth, stage.stageHeight, "http://www.google.com");

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

function onScreenshot(e:MyWebViewEvent):void
{
	var bm:Bitmap = new Bitmap(e.param, "auto", true);
	this.addChild(bm);
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

This extension works on Android SDK 10 or higher and iOS 6.1 or higher (lower Android SDKs like Android 2.3.6 will not support HTML5 completly, so you must consider this fact in your HTML/JS logic)

# Manifest .xml:
```xml
<!--required for enabling gps for webview-->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- required for html file select buttons -->
<activity android:name="com.doitflash.webView.Pick" android:theme="@style/Theme.Transparent" />

<!--required for webview GPS access-->
<key>NSLocationUsageDescription</key>
<string>I need location, reason 1</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>I need location, reason 2</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>I need location, reason 3</string>
```

# Changelog
- Jun 16, 2015	>> V1.0: 	
  - beginning of the journey!
- Jul 21, 2015	>> V2.0: 	
  - Added bitmap screenshot
  - support inline HTML5 video tag
- Aug 17, 2015	>> V3.0:
  - Added inputfile picker support
  - Added Gps support
  - fixed minor bugs
- Oct 11, 2015	>> V4.0:
  - Added support for user zoom pinch
  - updated load methods to be able to load new pages without the need to dispose the webview at first. This improves user expirience a lot.
  - depricated 'setPosition' for the favor of the new method 'setViewPort'
  - added x, y, width and height properties to the extension so it can be a lot easier to manage its dimension on the stage