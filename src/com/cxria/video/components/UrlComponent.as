package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import fl.controls.Button;
	
	/**
	 * url地址填写的输入框
	 */
	public class UrlComponent extends BaseComponent
	{
		public static var urlText:TextField;
		public static var labelText:TextField;
		public static var urlBtn:Button;
		
		/**
		 * 初始化输入框 
		 */
		private static function newUrlTextField():TextField
		{
			urlText = newTextField();
			urlText.border = true; 
			urlText.type = TextFieldType.INPUT;
			urlText.restrict = null;
			urlText.height = 20;
			urlText.width = 180;
			urlText.x=-60;
			urlText.y=290;
			return urlText;
		}
		
		/**
		 * 初始化输入框label
		 */
		private static function newUrlLabel():TextField
		{
			labelText = newTextField();
			labelText.height = 20;
			labelText.y=292;
			labelText.x=-130;
			labelText.text = "RTMP地址 ：";
			return labelText;
		}
		
		/**
		 * 初始化输入框相关按钮
		 */
		private static function newUrlButton():Button
		{
			urlBtn = newBtn();
			urlBtn.y = 290;
			urlBtn.x = 125;
			urlBtn.width = 41;
			urlBtn.height = 20;
			urlBtn.label = "play";
			return urlBtn;
		}
		
		/**
		 * 加载组件所有模块
		 */
		public static function load(stage:Stage):void
		{
			stage.addChild(newUrlTextField());
			stage.addChild(newUrlLabel());
			stage.addChild(newUrlButton());
		}
	}
}