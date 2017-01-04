package com.cxria.video.api
{
	import com.cxria.video.components.ControlBarComponent;
	import com.cxria.video.components.UrlComponent;
	
	import flash.net.NetConnection;

	/**
	 * 播放器提供的外部功能
	 */
	public class Api
	{
		private var nc:NetConnection;
		
		/**
		 * 暂停
		 */
		public function pause():void
		{
			ControlBarComponent.pauseClick(null);
		}
		
		/**
		 * 设置音量
		 */
		public function changeSound(vol:Number):void
		{
			ControlBarComponent.changeSound(vol);	
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			ControlBarComponent.stopClick(null);
		}
		
		/**
		 * 播放
		 */
		public function play(url:String,stream:String):void
		{
			UrlComponent.streamText.text = stream;
			nc.connect(url);
		}
		
		public function Api(nc:NetConnection)
		{
			this.nc = nc;
		}
	}
}