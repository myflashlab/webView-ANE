/**
 * ...
 * @author MyFlashLab Team - 6/16/2015 10:21 AM
 */

function Bridge()
{
	this.OS = "android"; // set default value.
}

var bridge = new Bridge();

// WebView extension will call this func as soon as the page is loaded and will set the current running OS
function setFlashNativeOS($os)
{
	bridge.OS = $os;
}

// static method for users to send string messages from JS to Flash
Bridge.call = function($msg)
{
    if(bridge.OS == "ios")
	{
		window.location = "callFlash:" + $msg;
	}
	else if(bridge.OS == "android")
	{
		NativeBridge.callFlash($msg);
	}
}