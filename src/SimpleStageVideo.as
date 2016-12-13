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
			MonitorComponent.load(stage);
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
			var customClient:Object = new Object();
			customClient.onMetaData = onMetaData;
			ns.client = customClient;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);
			sv = stage.stageVideos[0];
			sv.attachNetStream(ns);
			sv.viewPort = new Rectangle(-130,0,500,281);
			ns.play(streamName);
			
			//监控
			MonitorComponent.setNetStream(ns);
			MonitorComponent.timer.start();
		}
		
		private function onMetaData(infoObject:Object):void
		{
			var rw:Number = 0;
			var rh:Number = 0;
			
			var sw:int = 500;
			var sh:int = 282;
			
			var w:int = infoObject.width;
			var h:int = infoObject.height;

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
			sv.viewPort = new Rectangle(120 - rw / 2,0,rw,rh);                                   
		}
	}
}