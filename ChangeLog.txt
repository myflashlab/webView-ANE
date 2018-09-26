Rich WebView Adobe Air Native Extension

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
* Find usage in sample [Demo.as](https://github.com/myflashlab/webView-ANE/blob/master/FD/src/Demo.as)

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
* Removed AirBridge.js altogether! you won't see it anymore but it's there and will be injected into any html page that will be loaded. This will be a huge help to you to keep things as clean as possible.
* Corrected misspelling of the ```RECEIVED_MESSAGE_FROM_JS``` listener
* Introduced ```RichWebViewSettings``` class where you can set different options for your WebView on how it performs. As a result, you don't have to set the settings when initializing the extension in the constructor. instead you can set settings from the RichWebViewSettings class. old settings like gps and screenshots are there plus some new settings.
* Added a cool feature to RichWebViewSettings is ```BG_COLOR_HEX``` which supports alpha channel too. for example this means a complete white bg ```RichWebViewSettings.BG_COLOR_HEX = "#FFFFFFFF";``` while the following means a transparent bg ```RichWebViewSettings.BG_COLOR_HEX = "#00FFFFFF";```
* Set keyboardDisplayRequiresUserAction on iOS to NO by default.
* Added ```hide()``` method and ```visible``` property to make the webview in/visible easily and fast


*Jan 20, 2016 - V5.1*
* Bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem. This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater. https://forums.adobe.com/thread/2055508 https://forums.adobe.com/message/8294948


*Jan 03, 2015 - V5.0*
* Added support for loading local html files from File.applicationStorageDirectory too
* The bridge javascript code will now be injected into html pages automatically from the extension so you don't have to add the js file to your html content anymore
* When using RichWebview ANE, there is a "AirBridge.js" file on the root next to the main Air .swf file and you should NOT move or rename this file because native side is using this file to inject js functions into loaded html pages
* You may use this js file to add your own js functions to inject along with our current code which is necesary for the ANE to function correctly
* From this version, you must call AirBridge.evoke() method to call functions on the Air side. so make sure you have studied and tested the extension fully before adding it into your projects which is using older versions of this extension


*Dec 20, 2015 - V4.9.1*
* Minor bug fixes


*Nov 03, 2015 - V4.9*
* Doitflash devs merged into MyFLashLab Team


*Oct 11, 2015 - V4.0*
* Added support for user zoom pinch
* Updated load methods to be able to load new pages without the need to dispose the webview at first. This improves user expirience a lot
* Depricated 'setPosition' in favor of the new method 'setViewPort'
* Added x, y, width and height properties to the extension so it can be a lot easier to manage its dimension on the stage


*Aug 17, 2015 - V3.0*
* Added inputfile picker support
* Added Gps support
* Fixed minor bugs


*Jul 21, 2015 - V2.0*
* Added bitmap screenshot
* support inline HTML5 video tag


*Jun 16, 2015 - V1.0*
* beginning of the journey!