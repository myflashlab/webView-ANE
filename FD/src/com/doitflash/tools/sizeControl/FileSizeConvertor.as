package com.doitflash.tools.sizeControl
{
	
	/**
	 * @private
	 * @author Hadi Tavakoli
	 */
	public class FileSizeConvertor 
	{
		
		public function FileSizeConvertor():void
		{
			
		}
		
		public static function size($bytes:Number):String
		{
			var results:String;
			
			var s:Array = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
			var e:Number = Math.floor(Math.log($bytes) / Math.log(1024));
			results = ($bytes / Math.pow(1024, Math.floor(e))).toFixed(2) + " " + s[e];
			
			return results;
		}
	}
	
}