# Rich WebView ANE V7.1.5 (Android+iOS)
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

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/webView/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/webView-ANE/tree/master/AIR/lib)

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

# Changelog
*Dec 4, 2018 - V7.1.5*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

*Sep 25, 2018 - V7.1.4*
* Removed androidSupport dependency. The ANE now depends on the following:
	* ```<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>```
	* ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.core</extensionID>```
	* ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.v4</extensionID>```
	* ```<extensionID>com.myflashlab.air.extensions.dependency.androidSupport.customtabs</extensionID>```

*Dec 15, 2017 - V7.1.3*
* optimized for [ANE-LAB sofwate](https://github.com/myflashlab/ANE-LAB).

*Aug 20, 2017 - V7.1.1*
* Fixed customtabs on Android devices with Android version 7.1.1 and higher. The equal version numbers are just a coincidence :D 
* Added sample intelliJ app

*May 08, 2017 - V7.1.0*
* Added support for loading HTML Strings directly. [openData](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/webView/RichWebView.html#openData())
* Find usage in sample [Demo.as](https://github.com/myflashlab/webView-ANE/blob/master/AIR/src/Demo.as)

*Apr 05, 2017 - V7.0.0*
* Added support for Android customtabs - Sample codes updated
* Added support for iOS safariViewController - Sample codes updated
* Updated the ANE with the latest version of overrideAir. if you are building for iOS only, you still need to include this dependency in your project

*Nov 08, 2016 - V6.6.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* From now on, this ANE will depend on androidSupport.ane and overrideAir.ane on the Android side

*Sep 14, 2016 - V6.5.0*
* ```ENABLE_AIR_PREFIX``` added to ```RichWebViewSettings```. The default value is ```true```. This property is useful on the Android side only and has no effect on the iOS side. AIR apps have *air.* prefix at the beginning of their Android package name but there are methods to remove this prefix. Therefore, those devs who are removing the *air.* prefix manually, should also set this property to ```false``` for the RichWebview to be able to load local content properly.


*Aug 07, 2016 - V6.4.0*
* The constructor function ```new RichWebView(this.stage);``` accepts only one parameter from now on. However, to config the RichWebview settings, you should change static values in ```RichWebViewSettings```.
* ```ENABLE_THIRD_PARTY_COOKIES``` added to ```RichWebViewSettings``` which enables third-party cookies on Android. Changing this value makes no difference on the iOS side. The reason is [explained here](https://discussions.apple.com/thread/4156939?tstart=0) and a possible workaround is [described here](http://stackoverflow.com/questions/9930671/safari-3rd-party-cookie-iframe-trick-no-longer-working).


*Jun 15, 2016 - V6.3.0*
* Added support for ```setAllowUniversalAccessFromFileURLs``` on Android side. [asked here](https://github.com/myflashlab/webView-ANE/issues/93)
* Fixed touch positions which was wrong on some iOS devices based on their DPI value. Now the returned x,y are corrected based on different devices DPI values. [asked here](https://github.com/myflashlab/webView-ANE/issues/96)
* Introduced a new listener ```RichWebViewEvent.PAGE_STARTING``` which will notify you on the next URL which is about to load in webview. When you receive this event, you must decide if you wish the webview load the URL or you wish to handle it yourself. If you don't add the listener, the ANE will work like before BUT if you do add the listener, you MUST call ```_ex.shouldContinueLoadingTheURL();``` to allow the webview load links normally. This is shown in the sample code below.
```actionscript
_ex.addEventListener(RichWebViewEvent.PAGE_STARTING, onPageStarting);

function onPageStarting(e:RichWebViewEvent):void
{
	if (String(e.param).indexOf("mailto:") == 0)
	{
		trace("do something with the mailto: links!");
	}
	else
	{
		// allow other link types to load normally
		_ex.shouldContinueLoadingTheURL();
	}
}
```


*Apr 30, 2016 - V6.2.0*
* Fixed the problem of loading local pages on some Android devices like Nexus
* Found a solution for the StageText listeners. check out https://github.com/myflashlab/webView-ANE/issues/61#issuecomment-215052184
* Fixed the Bitmap screenshot problem on some Android devices
* You can now set the browser UserAgent manually or leave it empty for the webview to use the default setting. (On Android devices, you need to set the useragent to *Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.36 (KHTML, like Gecko) Chrome/13.0.766.0 Safari/534.36* for YouTube or Vimeo players to work.)

*Feb 21, 2016 - V6.1.0*
* New property added to move the Android Task to background ```moveAndroidTaskToBack()```
* New listener to know when RichWebView is touched ```RichWebViewEvent.TOUCH```
* Fixed the setViewPort bug in iOS which used to scroll the content to the top of the page. that won't happen anymore just like the Android side
* Fixed other minor bugs

*Feb 13, 2016 - V6.0.0*
* Supporting iFrame embeded videos
* removed AirBridge.js altogether! you won't see it anymore but it's there and will be injected into any html page that will be loaded. This will be a huge help to you to keep things as clean as possible.
* corrected misspelling of the ```RECEIVED_MESSAGE_FROM_JS``` listener
* introduced ```RichWebViewSettings``` class where you can set different options for your WebView on how it performs. As a result, you don't have to set the settings when initializing the extension in the constructor. instead you can set settings from the RichWebViewSettings class. old settings like gps and screenshots are there plus some new settings.
* Added a cool feature to RichWebViewSettings is ```BG_COLOR_HEX``` which supports alpha channel too. for example this means a complete white bg ```RichWebViewSettings.BG_COLOR_HEX = "#FFFFFFFF";``` while the following means a transparent bg ```RichWebViewSettings.BG_COLOR_HEX = "#00FFFFFF";```
* set keyboardDisplayRequiresUserAction on iOS to NO by default.
* added ```hide()``` method and ```visible``` property to make the webview in/visible easily and fast


*Jan 20, 2016 - V5.1*
* bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem. This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater. https://forums.adobe.com/thread/2055508 https://forums.adobe.com/message/8294948


*Jan 03, 2015 - V5.0*
* added support for loading local html files from File.applicationStorageDirectory too
* the bridge javascript code will now be injected into html pages automatically from the extension so you don't have to add the js file to your html content anymore
* When using RichWebview ANE, there is a "AirBridge.js" file on the root next to the main Air .swf file and you should NOT move or rename this file because native side is using this file to inject js functions into loaded html pages
* You may use this js file to add your own js functions to inject along with our current code which is necesary for the ANE to function correctly
* From this version, you must call AirBridge.evoke() method to call functions on the Air side. so make sure you have studied and tested the extension fully before adding it into your projects which is using older versions of this extension


*Dec 20, 2015 - V4.9.1*
* minor bug fixes


*Nov 03, 2015 - V4.9*
* doitflash devs merged into MyFLashLab Team


*Oct 11, 2015 - V4.0*
* Added support for user zoom pinch
* updated load methods to be able to load new pages without the need to dispose the webview at first. This improves user expirience a lot
* depricated 'setPosition' in favor of the new method 'setViewPort'
* added x, y, width and height properties to the extension so it can be a lot easier to manage its dimension on the stage


*Aug 17, 2015 - V3.0*
* Added inputfile picker support
* Added Gps support
* fixed minor bugs


*Jul 21, 2015 - V2.0*
* Added bitmap screenshot
* support inline HTML5 video tag


*Jun 16, 2015 - V1.0*
* beginning of the journey!