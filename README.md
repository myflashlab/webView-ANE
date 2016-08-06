# Rich WebView ANE V6.4.0 (Android+iOS)
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

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/webView/package-detail.html)

# Demo .apk
you may like to see the ANE in action? [Download demo .apk](https://github.com/myflashlab/webView-ANE/tree/master/FD/dist)

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/webView-ANE/tree/master/FD/lib)

# Air Usage
```actionscript
import com.myflashlab.air.extensions.webView.RichWebView;
import com.myflashlab.air.extensions.webView.RichWebViewEvent;
import com.myflashlab.air.extensions.webView.RichWebViewSettings;

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

# Air .xml manifest
```xml
<!--
FOR ANDROID:
-->
<manifest android:installLocation="auto">
		<uses-sdk android:minSdkVersion="10" android:targetSdkVersion="19" />
		<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
		
		<!--required for enabling gps for webview-->
		<uses-permission android:name="android.permission.INTERNET" />
		<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
		
		<application android:hardwareAccelerated="true" android:allowBackup="true">
			<activity android:hardwareAccelerated="true">
				<intent-filter>
					<action android:name="android.intent.action.MAIN" />
					<category android:name="android.intent.category.LAUNCHER" />
				</intent-filter>
				<intent-filter>
					<action android:name="android.intent.action.VIEW" />
					<category android:name="android.intent.category.BROWSABLE" />
					<category android:name="android.intent.category.DEFAULT" />
				</intent-filter>
			</activity>
			
			<!-- required for html file select buttons -->
			<activity android:name="com.doitflash.webView.Pick" android:theme="@style/Theme.Transparent" />
			
		</application>
		
</manifest>




<!--
FOR iOS:
-->
<InfoAdditions>

	<key>MinimumOSVersion</key>
	<string>8.0</string>
	
	<key>UIStatusBarStyle</key>
	<string>UIStatusBarStyleBlackOpaque</string>
	
	<key>UIRequiresPersistentWiFi</key>
	<string>NO</string>
	
	<key>UIPrerenderedIcon</key>
	<true />
	
	<!--required for webview GPS access-->
	<key>NSLocationUsageDescription</key>
	<string>I need location 1</string>
	
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>I need location 2</string>
	
	<key>NSLocationAlwaysUsageDescription</key>
	<string>I need location 3</string>
	
	<key>UIDeviceFamily</key>
	<array>
		<string>1</string>
		<string>2</string>
	</array>
	
</InfoAdditions>




<!--
Embedding the ANE:
-->
  <extensions>
    <extensionID>com.myflashlab.air.extensions.webView</extensionID>
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
* Android SDK 10 or higher (lower Android SDKs like Android 2.3.6 will not support HTML5 completly, so you must consider this fact in your HTML/JS logic)
* iOS 8.0 or higher

# Commercial Version
http://www.myflashlabs.com/product/rich-webview-ane-adobe-air-native-extension/

![WebView ANE](http://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-rich-webview-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  
[How to enable GPS in Rich Webview ANE?](http://www.myflashlabs.com/adobe-air-stagewebview-gps/)  
[How to Open file picker on the input html fields?](http://www.myflashlabs.com/adobe-air-html-file-pick-webview/)  
[How to open/parse pdf using RichWebview ANE?](http://www.myflashlabs.com/how-to-open-parse-pdf-using-richwebview-ane/)  

# Changelog
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