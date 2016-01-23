# Rich WebView ANE V5.1 (Android+iOS)
This extension is a perfect replacement to the classic StageWebView and it allows you to easily call Javascript functions from flash and send String messages from JS to flash. it also gives you many new features that the classic StageWebView couldn't provide. Features like File pick or GPS access.

checkout here for the commercial version: http://www.myflashlabs.com/product/rich-webview-ane-adobe-air-native-extension/

you may like to see the ANE in action? check this out: https://github.com/myflashlab/webView-ANE/tree/master/FD/dist

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

![WebView ANE](http://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-rich-webview-595x738.jpg)

# Main Features:
* Call JS funcs from Air and vice versa
* Control the Scroll position
* Change the view port size and position at runtime
* Play video files inside the webview
* Take full screenshots from your webview object
* Get GPS location information in to your JS
* Enable file picker dialog on your HTML input fields
* change viewport and position of webview at runtime

Tutorials:
* [How to enable GPS in Rich Webview ANE?](http://www.myflashlabs.com/adobe-air-stagewebview-gps/)
* [How to Open file picker on the input html fields?](http://www.myflashlabs.com/adobe-air-html-file-pick-webview/)
* [How to open/parse pdf using RichWebview ANE?](http://www.myflashlabs.com/how-to-open-parse-pdf-using-richwebview-ane/)

# AS3 API:
```actionscript
import com.myflashlab.air.extensions.webView.RichWebView;
import com.myflashlab.air.extensions.webView.RichWebViewEvent;

var _ex = new RichWebView(this.stage, true, true, true, true); // stage, enableBitmapCapture, enableCookies, enableGps, enableZoom

// add listeners
if(_ex.os == RichWebView.ANDROID) C.log("Android SDK version: ", _ex.sdkVersion);
_ex.addEventListener(RichWebViewEvent.BACK_CLICKED, onBackClicked);
_ex.addEventListener(RichWebViewEvent.PAGE_STARTED, onPageStarted);
_ex.addEventListener(RichWebViewEvent.PAGE_PROGRESS, onPageProgress);
_ex.addEventListener(RichWebViewEvent.PAGE_FINISHED, onPageFinished);
_ex.addEventListener(RichWebViewEvent.RECEIVED_MASSAGE_FROM_JS, onReceivedMassage);
_ex.addEventListener(RichWebViewEvent.RECEIVED_SSL_ERROR, onReceivedError);
_ex.addEventListener(RichWebViewEvent.SCREENSHOT, onScreenshot);

_ex.openWebViewLocal(0, 0, stage.stageWidth, stage.stageHeight, File.documentsDirectory.resolvePath("webview/index.html")); // OR from File.applicationStorageDirectory
//_ex.openWebViewURL(0, 0, stage.stageWidth, stage.stageHeight, "http://www.google.com");

function onBackClicked(e:RichWebViewEvent):void
{
	if (_ex.canGoBack) _ex.goBack();
	else _ex.closeWebView();
}

function onPageStarted(e:RichWebViewEvent):void
{
	trace("page started to be loaded");
}

function onPageProgress(e:RichWebViewEvent):void
{
	trace("page loading: " + e.param + "%");
}

function onPageFinished(e:RichWebViewEvent):void
{
	trace("page load completed");
}

function onReceivedError(e:RichWebViewEvent):void
{
	trace("error = " + e.param);
}

function onReceivedMassage(e:RichWebViewEvent):void
{
	trace("onReceivedMassage: ", e.param);
}

function onScreenshot(e:RichWebViewEvent):void
{
	var bm:Bitmap = new Bitmap(e.param, "auto", true);
	this.addChild(bm);
}
```

# Setup Javascript:
You are able to easily call JS functions from Air like this:
```actionscript
_ex.callJS("diplayAlert('This is a message from AdobeAir!')");
```

and on JS side, you can send String messages to Air like this:
```javascript
AirBridge.evoke("toVibrate");
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
- Nov 03, 2015	>> V4.9:
  - doitflash devs merged into MyFLashLabs Team.
- Jan 03, 2016	>> V5.0:
  - added support for loading local html files from File.applicationStorageDirectory too.
  - the bridge javascript code will now be injected into html pages automatically from the extension so you don't have to add the js file to your html content anymore.
  - When using RichWebview ANE, there is a "AirBridge.js" file on the root next to the main Air .swf file and you should NOT move or rename this file because native side is using this file to inject js functions into loaded html pages.
  - You may use this js file to add your own js functions to inject along with our current code which is necesary for the ANE to function correctly.
  - From this version, you must call AirBridge.evoke() method to call functions on the Air side. so make sure you have studied and tested the extension fully before adding it into your projects which is using older versions of this extension.
- Jan 20, 2016 	>> V5.1: 	bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem.
  - This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater.
  - https://forums.adobe.com/thread/2055508
  - https://forums.adobe.com/message/8294948
  - updated com.doitflash.tools.DynamicFunc