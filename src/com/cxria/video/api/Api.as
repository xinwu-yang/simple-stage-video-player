package com.cxria.video.api
{
	import com.cxria.video.components.ControlBarComponent;
	import com.cxria.video.components.UrlComponent;
	
	import flash.net.NetConnection;
	import flash.net.Responder;

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
			if(nc != null){
				nc.connect(url);
			}
		}
		
		/**
		 * call AMS Server
		 */
		private function call(url:String,success:Function,fail:Function,...params):void
		{
			if(nc != null && nc.connected){
				nc.call(url,new Responder(success,fail),params);
			}
		}
		
		/**
		 * 循环播放
		 * startTime default = -2; len default = -1
		 */
		public function loop(streamName:String,src:String,format:String,startTime:Number,len:Number):void
		{
			var stream:Object = {"name" : streamName};
			var res:Object = {"src" : src , "format" : format};
			var args:Object = {"startTime" : startTime ? startTime : -2 , "len" : len ? len : -1};
			call("app/createStream",function(result:Object):void
			{
				trace(JSON.stringify(result));
			},null,stream,res,args);
		}
		
		/**
		 * 关闭循环播放
		 */
		public function closeLoop(index:Number):String
		{
			if(index < 0){
				return "error index";
			}
			call("app/closeStream",function(result:Object):void
			{
				trace(JSON.stringify(result));
			},null,index);
			return "success";
		}
		
		public function Api(nc:NetConnection)
		{
			this.nc = nc;
		}
	}
}