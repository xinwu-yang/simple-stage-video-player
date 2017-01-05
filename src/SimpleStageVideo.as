package
{
	import com.cxria.video.api.Api;
	import com.cxria.video.base.BaseUI;
	import com.cxria.video.components.ConsoleComponent;
	import com.cxria.video.components.ControlBarComponent;
	import com.cxria.video.components.MonitorComponent;
	import com.cxria.video.components.UrlComponent;
	import com.cxria.video.util.str.StringUtils;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class SimpleStageVideo extends Sprite
	{
		private var ns:NetStream;
		private var video:Video;
		private var sv:StageVideo;
		private var on:Boolean;
		private var nc:NetConnection = new NetConnection();
		private var server:String = "rtmp://192.168.1.29/server";
		//播放器暴露的接口
		private var api:Api = new Api(nc);
		
		public function SimpleStageVideo()
		{
			loadComponents();
			externalInterface();
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		/**
		 * 暴露接口提供给js调用
		 */
		public function externalInterface():void
		{
			var on:Boolean = ExternalInterface.available;
			ConsoleComponent.log("ExternalInterface.available : " + on);
			if(on){
				ExternalInterface.addCallback("pause",api.pause);
				ExternalInterface.addCallback("stop",api.stop);
				ExternalInterface.addCallback("changeSound",api.changeSound);
				ExternalInterface.addCallback("play",api.play);
				ExternalInterface.addCallback("createStream",api.createStream);
				ExternalInterface.addCallback("closeStream",api.closeStream);
				ExternalInterface.addCallback("loopOff",api.loopOff);
			}
		}

		/**
		 * 加载播放器相关组件
		 */
		private function loadComponents():void
		{	
			BaseUI.setStyle();
			UrlComponent.load(stage);
			ConsoleComponent.load(stage);
			MonitorComponent.load(stage);
			ControlBarComponent.load(stage);
		}
		
		/**
		 * 添加到舞台事件监听
		 */
		private function onAddedToStage(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);
		}
		
		/**
		 * 监听是否能启用硬件加速
		 */
		private function onStageVideoState(e:StageVideoAvailabilityEvent):void
		{
			on = e.availability == StageVideoAvailability.AVAILABLE;
			ConsoleComponent.log("StageVideoAvailability : " + on);
			nc.client = {};
			if(on){
				nc.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);
			}else{
				nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
			UrlComponent.setNetConnection(nc);
			nc.connect(server);
		}
		
		/**
		 * 处理NetStatusEvent事件
		 */
		private function onNetStatus(event:NetStatusEvent):void  
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			var code:String = event.info.code.split(".")[2];
			if(code == "Success"){
				var streamName:String = UrlComponent.streamText.text;
				if(StringUtils.isEmpty(streamName)){
					ConsoleComponent.log("StreamName is empty");
					return;
				}
				playVideo(nc,streamName);
			}
		}
		
		/**
		 * 播放视频
		 */
		private function playVideo(nc:NetConnection,streamName:String):void {
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
		 * 处理NetStatusEvent事件
		 */
		private function onStageVideoNetStatus(event:NetStatusEvent):void  
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			var code:String = event.info.code.split(".")[2];
			if(code == "Success"){
				ConsoleComponent.log("NetConnection : " + code);
				var streamName:String = UrlComponent.streamText.text;
				if(StringUtils.isEmpty(streamName)){
					ConsoleComponent.log("StreamName is empty");
					return;
				}
				playStageVideo(nc,streamName);
			}
		}
		
		/**
		 * 播放视频
		 */
		private function playStageVideo(nc:NetConnection,streamName:String):void {
			ns = new NetStream(nc);
			var customClient:Object = new Object();
			customClient.onMetaData = onMetaData;
			ns.client = customClient;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);
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
	}
}