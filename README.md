**NOTICE: This ANE is deprecated. We have developed a new [RichWebView II ANE](https://github.com/myflashlab/RichWebView-ANE) from scratch which uses native APIs in a more robust way. Consider using the new ANE instead of this one.**

 **We will keep on maintaining this ANE till mid-2019 but you are recommended to switch to the new ANE as soon as you can.**

# Rich WebView ANE (Android+iOS)
This extension is a perfect replacement to the classic StageWebView and it allows you to easily call Javascript functions from flash and send String messages from JS to flash. it also gives you many new features that the classic StageWebView couldn't provide. Features like File pick or GPS access.

**Main Features:**
* Call JS funcs from Air and vice versa
* Control the Scroll position
* Change the view port size and position at runtime
* Play video files inside the webview including embedded iFrame videos
* Take full screenshots from your webview object
* Get GPS location information in to your JS
* Enable file picker dialog on your HTML input fields
* Choose on the background color of your webview or make it transparent
* TouchEvent to know when the WebView is touched
* Optionally prevent URL loads and let Air handle them
* change viewport and position of webview at runtime
* Optimized for Android Manual Permissions.
* Load HTML Strings directly into the WebView instance
* Support Android custom-tabs
* Supports iOS SafariViewController

[find the latest **asdoc** for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/webView/package-detail.html)

# Air Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/webView-ANE/blob/master/AIR/src/Main.as).

```actionscript
import com.myflashlab.air.extensions.webView.*;

var _ex = new RichWebView(this.stage);

// add listeners
if(_ex.os == RichWebView.ANDROID) C.log("Android SDK version: ", _ex.sdkVersion);
_ex.addEventListener(RichWebViewEvent.BACK_CLICKED, onBackClicked);
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

function onReceivedMessage(e:RichWebViewEvent):void
{
	trace("onReceivedMessage: ", e.param);
}

function onScreenshot(e:RichWebViewEvent):void
{
	var bm:Bitmap = new Bitmap(e.param, "auto", true);
	this.addChild(bm);
}

function onTouch(e:RichWebViewEvent):void
{
	trace("onTouch > " + "x = " + e.param.x + " y = " + e.param.y);
}
```

# Air Usage - Embedded Browser

```actionscript
import com.myflashlab.air.extensions.webView.*;

var _ex = new RichWebView(this.stage);

// initialize the embedded Browser feature (Custom Tabs on Android and SafariViewController on iOS)
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

if (_ex.isEmbeddedBrowserSupported())
{
	// SafariViewController works on iOS9+
	// custom-tabs works on Android devices whith the chrome browser being updated
	
	_ex.openEmbeddedBrowser("https://www.google.com/");
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
}
```

# AIR .xml manifest
```xml
<!--
FOR ANDROID:
-->

<!-- under <manifest tag -->
	<uses-sdk android:targetSdkVersion="26"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

	<!--required for enabling gps for webview-->
	<uses-permission android:name="android.permission.INTERNET" />
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />


	<!-- under <manifest><application tag -->
		<!-- required for html file select buttons -->
		<activity android:name="com.doitflash.webView.Pick" android:theme="@style/Theme.Transparent" />
				
		<!-- required for customtabs support on Android -->
		<receiver android:name="com.doitflash.webView.ChromeTabActionBroadcastReceiver" />




<!--
FOR iOS:
-->

<!--required for webview GPS access-->
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>I need location when in use</string>




<!--
Embedding the ANE:
-->
<extensions>
        <extensionID>com.myflashlab.air.extensions.webView</extensionID>
        <extensionID>com.myflashlab.air.extensions.permissionCheck</extensionID>

        <extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>
        <extensionID>com.myflashlab.air.extensions.dependency.androidSupport.customtabs</extensionID>
        
</extensions>
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

# Requirements
* Android SDK 15+
* iOS 8.0+
* AIR 30+

# Permissions
Below are the list of Permissions this ANE might require. Check out the demo project available at this repository to see how we have used the [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask for the permissions.

Necessary | Optional
--------------------------- | ---------------------------
. | [SOURCE_LOCATION (Android)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_LOCATION)  
. | [SOURCE_STORAGE (Android)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_STORAGE)  
. | [SOURCE_LOCATION_WHEN_IN_USE (iOS)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_LOCATION_WHEN_IN_USE)  
. | [SOURCE_LOCATION_ALWAYS (iOS)](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_LOCATION_ALWAYS) 

# Commercial Version
https://www.myflashlabs.com/product/rich-webview-ane-adobe-air-native-extension/

[![WebView ANE](https://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-rich-webview-2018-595x738.jpg)](https://www.myflashlabs.com/product/rich-webview-ane-adobe-air-native-extension/)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[How to enable GPS in Rich Webview ANE?](http://www.myflashlabs.com/adobe-air-stagewebview-gps/)  
[How to Open file picker on the input html fields?](http://www.myflashlabs.com/adobe-air-html-file-pick-webview/)  
[How to open/parse pdf using RichWebview ANE?](http://www.myflashlabs.com/how-to-open-parse-pdf-using-richwebview-ane/)  

# Premium Support #
[![Premium Support package](https://www.myflashlabs.com/wp-content/uploads/2016/06/professional-support.jpg)](https://www.myflashlabs.com/product/myflashlabs-support/)
If you are an [active MyFlashLabs club member](https://www.myflashlabs.com/product/myflashlabs-club-membership/), you will have access to our private and secure support ticket system for all our ANEs. Even if you are not a member, you can still receive premium help if you purchase the [premium support package](https://www.myflashlabs.com/product/myflashlabs-support/).