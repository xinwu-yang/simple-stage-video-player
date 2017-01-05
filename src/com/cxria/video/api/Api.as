package com.cxria.video.api
{
	import com.cxria.video.components.ConsoleComponent;
	import com.cxria.video.components.ControlBarComponent;
	import com.cxria.video.components.UrlComponent;
	
	import flash.external.ExternalInterface;
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
		 * vol 音量大小 0-1之间
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
		 * url 流媒体服务器地址
		 * stream 流名
		 */
		public function play(url:String,stream:String):void
		{
			UrlComponent.streamText.text = stream;
			if(nc != null && !nc.connected){
				nc.connect(url);
			}
		}
		
		/**
		 * 创建直播流
		 * streamName 直播的流名 | src 资源名称 | format 资源后缀
		 * 
		 * *非循环播放流默认传参
		 * startTime default = -2; len default = -1
		 * 
		 * return 流下标 index(异步)
		 */
		public function createStream(streamName:String,src:String,format:String,startTime:Number,len:Number):void
		{
			var stream:Object = {"name" : streamName};
			var res:Object = {"src" : src , "format" : format};
			var args:Object = {"startTime" : startTime ? startTime : -2 , "len" : len ? len : -1};
			ConsoleComponent.log(JSON.stringify(stream));
			ConsoleComponent.log(JSON.stringify(res));
			ConsoleComponent.log(JSON.stringify(args));
			nc.call("app/createStream",
				new Responder(
					function(result:Object):void
					{
						ConsoleComponent.log(JSON.stringify(result));
						if(result.b == 1){
							//回传给JS下标
							ExternalInterface.call("VrPlayer.getStreamIndex",result.o.index);
						}
					},null
				),
				stream,
				res,
				args
			);
		}
		
		/**
		 * 关闭循环
		 * index 流下标
		 */
		public function loopOff(index:Number):String
		{
			if(index < 0){
				return "error index";
			}
			nc.call("app/loopOff",
				new Responder(
					function(result:Object):void
					{
						ConsoleComponent.log(JSON.stringify(result));
					},null
				),
				index
			);
			return "success";
		}
		
		/**
		 * 关闭直播流
		 * index 流下标
		 */
		public function closeStream(index:Number):String
		{
			if(index < 0){
				return "error index";
			}
			nc.call("app/closeStream",
				new Responder(
					function(result:Object):void
					{
						ConsoleComponent.log(JSON.stringify(result));
					},null
				),
				index
			);
			return "success";
		}
		
		public function Api(nc:NetConnection)
		{
			this.nc = nc;
		}
	}
}