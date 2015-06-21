package com.doitflash.remote.youtube
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 11/6/2014 6:14 PM
	 */
	public class YouTubeLinkParserEvent extends Event
	{
		public static const COMPLETE:String = "onComplete";
		public static const ERROR:String = "onError";
		
		public static const VIDEO_HEADER_RECEIVED:String = "onVideoHeaderReceived";
		public static const VIDEO_HEADER_ERROR:String = "onVideoHeaderError";
		
		
		
		private var _param:*;
		
		public function YouTubeLinkParserEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			_param = data;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @private
		 */
		public function get param():*
		{
			return _param;
		}
	}
	
}