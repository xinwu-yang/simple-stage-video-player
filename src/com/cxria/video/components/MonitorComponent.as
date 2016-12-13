package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	import com.cxria.video.domain.StreamInfo;
	
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.media.StageVideo;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class MonitorComponent extends BaseComponent
	{
		public static var timer:Timer;
		public static var streamInfo:StreamInfo;
		private static var ns:NetStream;
		private static var sv:StageVideo;
		
		//label
		public static var fpsLabel:TextField;
		public static var delayLabel:TextField;
		public static var timeLabel:TextField;
		public static var currentBytesPerSecondLabel:TextField;
		public static var droppedFramesLabel:TextField;
		public static var playbackBytesPerSecondLabel:TextField;
		public static var srttLabel:TextField;
		
		private static function newMonitor():void
		{
			timer = newTimer(1000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		public static function setNetStream(nets:NetStream):void
		{
			ns = nets;
			streamInfo = new StreamInfo(nets);
		}
		
		public static function load(stage:Stage):void
		{
			newMonitor();
			stage.addChild(newFPSLabel());
			stage.addChild(newDelayLabel());
			stage.addChild(newTimeLabel());
			stage.addChild(newCurrentBytesPerSecondLabel());
			stage.addChild(newDroppedFramesLabel());
			stage.addChild(newPlaybackBytesPerSecondLabel());
			stage.addChild(newSrttLabel());
		}
		
		protected static function onTimer(event:TimerEvent):void
		{
			if(ns == null){
				ConsoleComponent.log("NetStream is Null");
				timer.stop();
			}
			if(streamInfo != null){
				streamInfo.update();
				fpsLabel.text = "FPS: " + streamInfo.fps.toFixed(2);
				delayLabel.text = "Delay: " + streamInfo.delay;
				timeLabel.text = "Time: " + streamInfo.time.toFixed(0);
				currentBytesPerSecondLabel.text = "CurrentBytesPerSecond: " + streamInfo.currentBytesPerSecond.toFixed(0);
				droppedFramesLabel.text = "DroppedFrames: " + streamInfo.droppedFrames;
				playbackBytesPerSecondLabel.text = "PlaybackBytesPerSecond: " + streamInfo.playbackBytesPerSecond.toFixed(0);
				srttLabel.text = "Srtt: " + streamInfo.srtt;
				
			}
		}
		
		public function MonitorComponent()
		{
			super();
		}
		
		//ui init
		private static function newFPSLabel():TextField
		{
			fpsLabel = newTextField();
			fpsLabel.height = 20;
			fpsLabel.y=322;
			fpsLabel.x=-130;
			fpsLabel.text = "FPS:";
			return fpsLabel;
		}

		private static function newDelayLabel():TextField
		{
			delayLabel = newTextField();
			delayLabel.height = 20;
			delayLabel.y=354;
			delayLabel.x=-130;
			delayLabel.text = "Delay:";
			return delayLabel;
		}

		private static function newTimeLabel():TextField
		{
			timeLabel = newTextField();
			timeLabel.height = 20;
			timeLabel.y=322;
			timeLabel.x=-60;
			timeLabel.text = "Time:";
			return timeLabel;
		}
		
		private static function newCurrentBytesPerSecondLabel():TextField
		{
			currentBytesPerSecondLabel = newTextField();
			currentBytesPerSecondLabel.height = 20;
			currentBytesPerSecondLabel.width = 160;
			currentBytesPerSecondLabel.y=354;
			currentBytesPerSecondLabel.x=-60;
			currentBytesPerSecondLabel.text = "CurrentBytesPerSecond:";
			return currentBytesPerSecondLabel;
		}
		
		
		private static function newDroppedFramesLabel():TextField
		{
			droppedFramesLabel = newTextField();
			droppedFramesLabel.height = 20;
			droppedFramesLabel.width = 200;
			droppedFramesLabel.y=322;
			droppedFramesLabel.x=20;
			droppedFramesLabel.text = "DroppedFrames:";
			return droppedFramesLabel;
		}
		
		private static function newPlaybackBytesPerSecondLabel():TextField
		{
			playbackBytesPerSecondLabel = newTextField();
			playbackBytesPerSecondLabel.height = 20;
			playbackBytesPerSecondLabel.width = 180;
			playbackBytesPerSecondLabel.y=354;
			playbackBytesPerSecondLabel.x=120;
			playbackBytesPerSecondLabel.text = "PlaybackBytesPerSecond:";
			return playbackBytesPerSecondLabel;
		}
		
		private static function newSrttLabel():TextField
		{
			srttLabel = newTextField();
			srttLabel.height = 20;
			srttLabel.width = 140;
			srttLabel.y=322;
			srttLabel.x=160;
			srttLabel.text = "Srtt:";
			return srttLabel;
		}
	}
}