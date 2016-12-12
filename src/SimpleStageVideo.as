package
{
	import com.cxria.video.components.ConsoleComponent;
	import com.cxria.video.components.MonitorComponent;
	import com.cxria.video.components.UrlComponent;
	import com.cxria.video.util.str.StringUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	//[SWF(backgroundColor="#000000")]
	public class SimpleStageVideo extends Sprite
	{
		private var nc:NetConnection;
		private var ns:NetStream;
		
		private var video:Video;
		private var sv:StageVideo;
		
		private var url:String = "rtmp://p.cxria.com/live";
		private var streamName:String = "123456";
		
		public function SimpleStageVideo()
		{
			loadComponents();
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		/**
		 * 加载播放器相关组件
		 */
		public function loadComponents():void
		{
			UrlComponent.load(stage);
			ConsoleComponent.load(stage);
			MonitorComponent.load();
		}
		
		/**
		 * 添加到舞台事件监听
		 */
		private function onAddedToStage(e:Event):void
		{
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);
		}
		
		private function onStageVideoState(e:StageVideoAvailabilityEvent):void
		{
			var on:Boolean = e.availability == StageVideoAvailability.AVAILABLE;
			ConsoleComponent.log("StageVideoAvailability : " + on);
			nc = new NetConnection();
			nc.client = {};
			if(on){
				nc.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);
			}else{
				nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
			UrlComponent.setNetConnection(nc);
		}
		
		/**
		 * 处理NetStatusEvent事件
		 */
		private function onNetStatus(event:NetStatusEvent):void  
		{  
			ConsoleComponent.log(event.info.code);
			ConsoleComponent.log(JSON.stringify(event.info));
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
			//定义空的方法
			ns.client = {};
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			video = new Video();
			video.attachNetStream(ns);
			ns.play(streamName);
			stage.addChild(video);
		}
		
		/**
		 * 处理NetStatusEvent事件
		 */
		private function onStageVideoNetStatus(event:NetStatusEvent):void  
		{  
			ConsoleComponent.log(event.info.code);
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			var code:String = event.info.code.split(".")[2];
			if(code == "Success"){
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
			//定义空的方法
			ns.client = {};
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);
			sv = stage.stageVideos[0];
			sv.attachNetStream(ns);
			sv.viewPort = new Rectangle(-130,0,500,281);
			ns.play(streamName);
			//监控
			MonitorComponent.setNetStream(ns);
			MonitorComponent.timer.start();
		}
	}
}