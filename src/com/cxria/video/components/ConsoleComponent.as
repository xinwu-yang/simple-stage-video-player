package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	import com.cxria.video.util.date.DateUtils;
	
	import flash.display.Stage;
	import flash.text.TextFormat;
	
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
			console.height = 283;
			console.text = "Console : \n";
			console.editable = false;
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 8;
			console.setStyle("textFormat",textFormat);
			return console;
		}
				
		public static function load(stage:Stage):void
		{
			stage.addChild(newConsole());
		}
		
		public static function log(log:String):void
		{
			if(console != null){
				console.text += DateUtils.now() + " - " + log + "\n";
			}
		}
		
		public function ConsoleComponent()
		{
			super();
		}
	}
}