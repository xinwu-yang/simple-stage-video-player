package com.cxria.video.base
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class BaseUI
	{
		//全局字体样式设置
		public static var textFormat:TextFormat = new TextFormat();
		
		public static function setStyle():void
		{
			//字体设置
			textFormat.font = "Microsoft YaHei";
			textFormat.size = 5;
			textFormat.align = TextFormatAlign.CENTER;
		}
		
		public function BaseUI()
		{
		}
	}
}