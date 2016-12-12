package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	import com.cxria.video.util.date.DateUtils;
	
	import flash.display.Stage;
	
	import fl.controls.TextArea;
	
	public class ConsoleComponent extends BaseComponent
	{
		
		public static var console:TextArea;
		
		private static function newConsole():TextArea
		{
			console = newTextarea();
			console.x = 370;
			console.y = 0;
			console.width = 250;
			console.height = 350;
			console.text = "Console : \n";
			console.editable = false;
			return console;
		}
				
		public static function load(stage:Stage):void
		{
			stage.addChild(newConsole());
		}
		
		public static function log(log:String):void
		{
			console.text += DateUtils.now() + " - " + log + "\n";
		}
		
		public function ConsoleComponent()
		{
			super();
		}
	}
}