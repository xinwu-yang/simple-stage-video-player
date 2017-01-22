package
{
	import com.cxria.video.api.Api;
	import com.cxria.video.base.AppConfig;
	import com.cxria.video.components.ConsoleComponent;
	import com.cxria.video.components.UrlComponent;
	import com.cxria.video.util.str.StringUtils;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.external.ExternalInterface;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[SWF(backgroundColor="#111")]
	public class SimpleStageVideo extends Sprite
	{
		private var ns:NetStream;
		private var video:Video;
		private var sv:StageVideo;
		private var on:Boolean = false;
		private var nc:NetConnection = new NetConnection();
		//播放器暴露的接口
		private var api:Api = new Api(nc,ns,video,sv,stage);
		
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
				ExternalInterface.addCallback("seek",api.seek);
				ExternalInterface.addCallback("changeSound",api.changeSound);
				ExternalInterface.addCallback("play",api.play);
				ExternalInterface.addCallback("createStream",api.createStream);
				ExternalInterface.addCallback("closeStream",api.closeStream);
				ExternalInterface.addCallback("loopOff",api.loopOff);
				ExternalInterface.addCallback("setWH",api.setWH);
			}
		}

		/**
		 * 加载播放器相关组件
		 */
		private function loadComponents():void
		{	
			//BaseUI.setStyle();
			//UrlComponent.load(stage);
			//UrlComponent.hide(stage);
			//ConsoleComponent.load(stage);
			//MonitorComponent.load(stage);
			//ControlBarComponent.load(stage);
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
			api.setStageVideoON(on);
			ConsoleComponent.log("StageVideoAvailability : " + on);
			nc.client = {};
			if(on){
				nc.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);
			}else{
				nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
			UrlComponent.setNetConnection(nc);
			nc.proxyType = "best";
			nc.connect(AppConfig.SERVER_NAME);
		}
		
		/**
		 * 处理NetStatusEvent事件
		 */
		private function onNetStatus(event:NetStatusEvent):void  
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			var code:String = event.info.code.split(".")[2];
			ConsoleComponent.log("NetConnection : " + code);
			if(code == "Success"){
				var streamName:String = UrlComponent.streamText.text;
				if(StringUtils.isEmpty(streamName)){
					ConsoleComponent.log("StreamName is empty");
					return;
				}
				api.playVideo(nc,streamName);
			}
		}

		/**
		 * 处理StageNetStatusEvent事件
		 */
		private function onStageVideoNetStatus(event:NetStatusEvent):void  
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			var code:String = event.info.code.split(".")[2];
			ConsoleComponent.log("NetConnection : " + code);
			if(code == "Success"){
				var streamName:String = UrlComponent.streamText.text;
				if(StringUtils.isEmpty(streamName)){
					ConsoleComponent.log("StreamName is empty");
					return;
				}
				api.playStageVideo(nc,streamName);
			}
		}

	}
}