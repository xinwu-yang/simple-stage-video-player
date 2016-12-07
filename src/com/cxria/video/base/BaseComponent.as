package com.cxria.video.base
{
	import flash.text.TextField;
	
	import fl.controls.Button;

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
	}
}