package com.cxria.video.domain
{
	import com.cxria.video.components.ConsoleComponent;
	
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;

	public class StreamInfo
	{	
		public var fps:Number;
		
		public var delay:Number;
		
		public var time:Number;
		
		public var useHardwareDecoder:Boolean;
		
		public var useJitterBuffer:Boolean;
		
		public var currentBytesPerSecond:Number;
		
		public var droppedFrames:Number;
		
		public var isLive:Boolean;
		
		public var playbackBytesPerSecond:Number;
		
		public var srtt:Number;
				
		private var ns:NetStream;
		
		public function StreamInfo(ns:NetStream)
		{
			if(ns != null){
				this.ns = ns;
				fps = ns.currentFPS;
				delay = ns.liveDelay;
				time = ns.time;
				useHardwareDecoder = ns.useHardwareDecoder;
				useJitterBuffer = ns.useJitterBuffer;
				var nsi:NetStreamInfo = ns.info;
				if(nsi != null){
					isLive = nsi.isLive;
					currentBytesPerSecond = nsi.currentBytesPerSecond;
					droppedFrames = nsi.droppedFrames;
					playbackBytesPerSecond = nsi.playbackBytesPerSecond;
					srtt = nsi.SRTT;	
				}
				ConsoleComponent.log("useHardwareDecoder : " + useHardwareDecoder);
				ConsoleComponent.log("useJitterBuffer : " + useJitterBuffer);
				ConsoleComponent.log("isLive : " + isLive);
			}
		}
		
		public function update():void
		{
			if(ns != null){
				fps = ns.currentFPS;
				delay = ns.liveDelay;
				time = ns.time;
				var nsi:NetStreamInfo = ns.info;
				if(nsi != null){
					currentBytesPerSecond = nsi.currentBytesPerSecond;
					droppedFrames = nsi.droppedFrames;
					playbackBytesPerSecond = nsi.playbackBytesPerSecond;
					srtt = nsi.SRTT;	
				}
			}
		}
	}
}