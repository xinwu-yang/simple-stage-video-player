package com.cxria.video.api
{
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
							ExternalInterface.call("VrPlayer.getStreamIndex",result.o.index);
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
			sv.viewPort = new Rectangle(-130,0,stage.width,stage.height);
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
			var baseX:Number = 260;
			var rw:Number = 0;
			var rh:Number = 0;
			
			var sw:int = 500;
			var sh:int = 282;
			
			var w:int = infoObject.width;
			var h:int = infoObject.height;
			
			ConsoleComponent.log("Stream width :" + w);
			ConsoleComponent.log("Stream height :" + h);
			
			if(w > h && w > sw){
				rw = sw;
				rh = sw / w * h;
			}else if(h > w && h > sh){
				rh = sh;
				rw = sh / h * w;
			}else{
				rw = w;
				rh = h;
			}
			if(on){
				sv.viewPort = new Rectangle(baseX - rw / 2,0,rw,rh);                                   
			}else{
				video.x = baseX - rw / 2;
				video.y = 0;
				video.width = rw;
				video.height = rh;
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