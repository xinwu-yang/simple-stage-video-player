package com.cxria.video.api
{
	import com.cxria.video.base.AppConfig;
	import com.cxria.video.components.ConsoleComponent;
	import com.cxria.video.components.ControlBarComponent;
	import com.cxria.video.components.MonitorComponent;
	import com.cxria.video.components.UrlComponent;
	
	import flash.display.Stage;
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;

	/**
	 * 播放器提供的外部功能
	 */
	public class Api
	{
		private var nc:NetConnection;
		private var ns:NetStream;
		private var on:Boolean = false;
		private var video:Video;
		private var sv:StageVideo;
		private var stage:Stage;
		
		/**
		 * 暂停
		 */
		public function pause():void
		{
			ControlBarComponent.pauseClick(null);
		}
		
		/**
		 * seek
		 */
		public function seek(sec:Number):void
		{
			if(ns != null){
				ns.seek(sec);
			}
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
			if(nc.connected){
				if(on){
					playStageVideo(nc,stream);
				}else{
					playVideo(nc,stream);
				}
			}else{
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
			ConsoleComponent.log("createStream : startTime : " + startTime + ",len : " +len);
			var stream:Object = {"name" : streamName};
			var res:Object = {"src" : src , "format" : format};
			var args:Object = {"startTime" : startTime ? startTime : -2 , "len" : len ? len : -1};
			nc.call("app/createStream",
				new Responder(
					function(result:Object):void
					{
						ConsoleComponent.log(JSON.stringify(result));
						if(result.b == 1){
							//回传给JS下标
							ExternalInterface.call("getStreamIndex",result.o.index);
						}
					},
					function(result:Object):void
					{
						ConsoleComponent.log(JSON.stringify(result));
					}
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
		
		public function setWH(x:Number,y:Number,w:Number,h:Number):void
		{
			if(on){
				if(sv != null){
					sv.viewPort = new Rectangle(x,y,w,h);
				}
			}else{
				if(video != null){
					video.x = x;
					video.y = y;
					video.width = w;
					video.height = h;
				}
			}
		}
		
		public function Api(nc:NetConnection,ns:NetStream,video:Video,sv:StageVideo,stage:Stage)
		{
			this.nc = nc;
			this.ns = ns;
			this.video = video;
			this.sv = sv;
			this.stage = stage;
		}
		
		public function setStageVideoON(on:Boolean):void
		{
			this.on = on;
		}
		
		/**
		 * 播放视频
		 */
		public function playVideo(nc:NetConnection,streamName:String):void {
			ns = new NetStream(nc);
			var customClient:Object = new Object();
			customClient.onMetaData = onMetaData;
			ns.client = customClient;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			video = new Video();
			video.width = AppConfig.WIDTH;
			video.height = AppConfig.HEIGHT;
			video.attachNetStream(ns);
			ns.play(streamName);
			stage.addChildAt(video,0);
			//监控
			MonitorComponent.setNetStream(ns);
			if(MonitorComponent.timer != null){
				MonitorComponent.timer.start();
			}
			//控制面板
			ControlBarComponent.setNetStream(ns);
		}
		
		/**
		 * 播放视频
		 */
		public function playStageVideo(nc:NetConnection,streamName:String):void {
			ns = new NetStream(nc);
			var customClient:Object = new Object();
			customClient.onMetaData = onMetaData;
			ns.client = customClient;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			sv = stage.stageVideos[0];
			sv.attachNetStream(ns);
			sv.viewPort = new Rectangle(0,0,AppConfig.WIDTH,AppConfig.HEIGHT);
			ns.play(streamName);
			//监控
			MonitorComponent.setNetStream(ns);
			if(MonitorComponent.timer != null){
				MonitorComponent.timer.start();
			}
			//控制面板
			ControlBarComponent.setNetStream(ns);
		}
		
		/**
		 * 获取流的宽高,调整播放比例
		 */
		private function onMetaData(infoObject:Object):void
		{			
			var sw:int = 1280;
			var sh:int = 720;
			var w:int = infoObject.width;
			var h:int = infoObject.height;	
			var z:Number = w / h;
			ConsoleComponent.log("Stream width :" + w);
			ConsoleComponent.log("Stream height :" + h);
			var x:int = 0,y:int = 0;
			if(w < sw){
				x = (sw - w) / 2;
			}else{
				w = 1280;				
			}
			if(h < sw){
				y = (sh -h) / 2;
			}else if(h > sw && w < sw){
				h = 720;
				w = h * z;
				x = (sw - w) / 2;
			}else if(h > sw && w >= sw){
				h = w / z;
			}
			if(on){
				sv.viewPort = new Rectangle(x,y,w,h);                                   
			}else{
				video.x = x;
				video.y = y;
				video.width = w;
				video.height = h;
			}
		}
		
		/**
		 * 处理NetStatusEvent事件
		 */
		private function onNetStatus(event:NetStatusEvent):void  
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			ConsoleComponent.log(event.info.code);
		}
	}
}