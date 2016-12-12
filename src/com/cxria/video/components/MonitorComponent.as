package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;

	public class MonitorComponent extends BaseComponent
	{
		public static var timer:Timer;
		private static var ns:NetStream;
		
		private static function newMonitor():void
		{
			timer = newTimer(1000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		public static function setNetStream(nets:NetStream):void
		{
			ns = nets;
		}
		
		public static function load():void
		{
			newMonitor();
		}
		
		protected static function onTimer(event:TimerEvent):void
		{
			if(ns == null){
				ConsoleComponent.log("NetStream is Null");
			}
			ConsoleComponent.log("currentFPS : " + ns.currentFPS);
		}
		
		public function MonitorComponent()
		{
			super();
		}
	}
}