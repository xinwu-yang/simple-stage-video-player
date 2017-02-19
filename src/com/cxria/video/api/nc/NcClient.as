package com.cxria.video.api.nc
{
	import flash.external.ExternalInterface;

	/**
	 * 用于接受服务器的回调
	 */
	public class NcClient
	{
		/**
		 * 服务器回调方法
		 */
		public function callBack(info:String):void
		{
			trace(info);
			ExternalInterface.call("onCallbackCurrentEnd",info);
		}
		
		public function NcClient()
		{
		}
	}
}