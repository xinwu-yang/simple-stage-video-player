package com.cxria.video.base
{
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import fl.controls.Button;
	import fl.controls.TextArea;

	public class BaseComponent
	{
		public function BaseComponent(){}
		/**
		 * 实例化TextField
		 */
		public static function newTextField():TextField
		{
			return new TextField(); 
		}
		
		/**
		 * 实例化Button
		 */
		public static function newBtn():Button
		{
			return new Button();
		}
		
		/**
		 * 实例化TextArea
		 */
		public static function newTextarea():TextArea
		{
			return new TextArea();
		}
		
		/**
		 * 实例化定时器
		 */
		public static function newTimer(time:Number):Timer
		{
			return new Timer(time);
		}
	}
}