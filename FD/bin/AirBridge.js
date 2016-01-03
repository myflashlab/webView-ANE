/**
 * DO NOT RENAME OR MOVE THIS FILE. IT MUST STAY ON THE ROOT NEXT TO YOUR MAIN APP .SWF FILE.
 * 
 * this script will be injected into any HTML page that you would load so you don't have to 
 * do it manually anymore like you used to in older versions.
 * 
 * @author MyFlashLabs.com - 01/03/2016 10:21 AM
 */

function AirBridge()
{
	this.OS = "android"; // set default value.
}

var airBridge = new AirBridge();

// WebView extension will call this func as soon as the page is loaded and will set the current running OS.
// the name of this function is hardcoded in native Obj-C and Android. Please do NOT change it.
function setFlashNativeOS($os)
{
	airBridge.OS = $os;
}

// static method for users to send string messages from JS to Flash
AirBridge.evoke = function($msg)
{
    if(airBridge.OS == "ios")
	{
		window.location = "callFlash:" + $msg;
	}
	else if(airBridge.OS == "android")
	{
		NativeBridge.callFlash($msg);
	}
}