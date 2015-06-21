package com.doitflash.tools
{
	//import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * extends flash.net.URLLoader to add it an obj property
	 * @author Hadi Tavakoli - 7/4/2010 12:07 PM
	 */
	public class URLLoader extends flash.net.URLLoader 
	{
		private var _obj:Object = {};
		private var _base:*;
		
		public function URLLoader(request:URLRequest=null):void
		{
			super(request);
		}
		
		public function get base():*
		{
			return _base;
		}
		
		public function set base(a:*):void
		{
			_base = a;
		}
		
		public function get obj():Object
		{
			return _obj;
		}
		
		public function set obj(o:Object):void
		{
			_obj = o;
		}
	}
	
}