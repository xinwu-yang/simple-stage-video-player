warning: LF will be replaced by CRLF in bin-debug/history/history.css.
The file will have its original line endings in your working directory.
warning: LF will be replaced by CRLF in bin-debug/history/history.js.
The file will have its original line endings in your working directory.
warning: LF will be replaced by CRLF in bin-debug/history/historyFrame.html.
The file will have its original line endings in your working directory.
warning: LF will be replaced by CRLF in bin-debug/swfobject.js.
The file will have its original line endings in your working directory.
[1mdiff --git a/bin-debug/SimpleStageVideo.swf b/bin-debug/SimpleStageVideo.swf[m
[1mindex cbbd7c8..4ce843f 100644[m
Binary files a/bin-debug/SimpleStageVideo.swf and b/bin-debug/SimpleStageVideo.swf differ
[1mdiff --git a/src/SimpleStageVideo.as b/src/SimpleStageVideo.as[m
[1mindex 1093a01..5311460 100644[m
[1m--- a/src/SimpleStageVideo.as[m
[1m+++ b/src/SimpleStageVideo.as[m
[36m@@ -1,14 +1,19 @@[m
 package[m
 {[m
 	import com.cxria.video.api.Api;[m
[32m+[m	[32mimport com.cxria.video.api.nc.NcClient;[m
 	import com.cxria.video.base.AppConfig;[m
[32m+[m	[32mimport com.cxria.video.base.BaseUI;[m
 	import com.cxria.video.components.ConsoleComponent;[m
[32m+[m	[32mimport com.cxria.video.components.ControlBarComponent;[m
[32m+[m	[32mimport com.cxria.video.components.MonitorComponent;[m
 	import com.cxria.video.components.UrlComponent;[m
 	import com.cxria.video.util.str.StringUtils;[m
 	[m
 	import flash.display.Sprite;[m
 	import flash.display.StageAlign;[m
 	import flash.display.StageQuality;[m
[32m+[m	[32mimport flash.display.StageScaleMode;[m
 	import flash.events.Event;[m
 	import flash.events.NetStatusEvent;[m
 	import flash.events.StageVideoAvailabilityEvent;[m
[36m@@ -27,6 +32,7 @@[m [mpackage[m
 		private var sv:StageVideo;[m
 		private var on:Boolean = false;[m
 		private var nc:NetConnection = new NetConnection();[m
[32m+[m		[32mprivate var ncClient:NcClient = new NcClient();[m
 		//播放器暴露的接口[m
 		private var api:Api = new Api(nc,ns,video,sv,stage);[m
 		[m
[36m@@ -62,12 +68,12 @@[m [mpackage[m
 		 */[m
 		private function loadComponents():void[m
 		{	[m
[31m-			//BaseUI.setStyle();[m
[31m-			//UrlComponent.load(stage);[m
[31m-			//UrlComponent.hide(stage);[m
[31m-			//ConsoleComponent.load(stage);[m
[31m-			//MonitorComponent.load(stage);[m
[31m-			//ControlBarComponent.load(stage);[m
[32m+[m			[32mBaseUI.setStyle();[m
[32m+[m			[32mUrlComponent.load(stage);[m
[32m+[m			[32mUrlComponent.hide(stage);[m
[32m+[m			[32mConsoleComponent.load(stage);[m
[32m+[m			[32mMonitorComponent.load(stage);[m
[32m+[m			[32mControlBarComponent.load(stage);[m
 		}[m
 		[m
 		/**[m
[36m@@ -77,6 +83,7 @@[m [mpackage[m
 		{[m
 			stage.align = StageAlign.TOP_LEFT;[m
 			stage.quality = StageQuality.BEST;[m
[32m+[m			[32mstage.scaleMode = StageScaleMode.NO_BORDER;[m
 			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,onStageVideoState);[m
 		}[m
 		[m
[36m@@ -88,7 +95,7 @@[m [mpackage[m
 			on = e.availability == StageVideoAvailability.AVAILABLE;[m
 			api.setStageVideoON(on);[m
 			ConsoleComponent.log("StageVideoAvailability : " + on);[m
[31m-			nc.client = {};[m
[32m+[m			[32mnc.client = ncClient;[m
 			if(on){[m
 				nc.addEventListener(NetStatusEvent.NET_STATUS, onStageVideoNetStatus);[m
 			}else{[m
[1mdiff --git a/src/com/cxria/video/api/Api.as b/src/com/cxria/video/api/Api.as[m
[1mindex 28acc7b..2dadbcd 100644[m
[1m--- a/src/com/cxria/video/api/Api.as[m
[1m+++ b/src/com/cxria/video/api/Api.as[m
[36m@@ -226,6 +226,7 @@[m [mpackage com.cxria.video.api[m
 			sv = stage.stageVideos[0];[m
 			sv.attachNetStream(ns);[m
 			sv.viewPort = new Rectangle(0,0,AppConfig.WIDTH,AppConfig.HEIGHT);[m
[32m+[m			[32mns.bufferTime = 0;[m
 			ns.play(streamName);[m
 			//监控[m
 			MonitorComponent.setNetStream(ns);[m
[1mdiff --git a/src/com/cxria/video/base/AppConfig.as b/src/com/cxria/video/base/AppConfig.as[m
[1mindex d2df343..2830bc9 100644[m
[1m--- a/src/com/cxria/video/base/AppConfig.as[m
[1m+++ b/src/com/cxria/video/base/AppConfig.as[m
[36m@@ -5,7 +5,8 @@[m [mpackage com.cxria.video.base[m
 	 */[m
 	public class AppConfig[m
 	{[m
[31m-		public static var SERVER_NAME:String = "rtmp://192.168.1.29/server";[m
[32m+[m		[32m//直播相关URL配置[m
[32m+[m		[32mpublic static var SERVER_NAME:String = "rtmps://woxspace.local.cxria.com:1443/server";[m
 		public static var WIDTH:Number = 1280;[m
 		public static var HEIGHwarning: LF will be replaced by CRLF in src/com/cxria/video/api/Api.as.
The file will have its original line endings in your working directory.
T:Number = 720;[m
 	}[m
[1mdiff --git a/src/com/cxria/video/components/UrlComponent.as b/src/com/cxria/video/components/UrlComponent.as[m
[1mindex d697323..4d27a93 100644[m
[1m--- a/src/com/cxria/video/components/UrlComponent.as[m
[1m+++ b/src/com/cxria/video/components/UrlComponent.as[m
[36m@@ -20,6 +20,7 @@[m [mpackage com.cxria.video.components[m
 	 */[m
 	public class UrlComponent extends BaseComponent[m
 	{[m
[32m+[m		[32m//mp4:2017-02-06-11-02-22-365978c.mp4[m
 		public static var urlText:TextField;[m
 		public static var streamText:TextField = newSTextField("");[m
 		public static var labelText:TextField; [m
[36m@@ -74,7 +75,7 @@[m [mpackage com.cxria.video.components[m
 			streamText.width = 40;[m
 			streamText.y =292;[m
 			streamText.x = 143;[m
[31m-			streamText.text = "mp4:1.mp4";[m
[32m+[m			[32mstreamText.text = "mp4:h3d.mp4";[m
 			streamText.setTextFormat(BaseUI.textFormat);[m
 			return streamText;[m
 		}[m
warning: LF will be replaced by CRLF in src/com/cxria/video/components/UrlComponent.as.
The file will have its original line endings in your working directory.
