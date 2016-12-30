package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	import com.cxria.video.base.BaseUI;
	import com.cxria.video.util.str.StringUtils;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import fl.controls.Button;
	
	/**
	 * url地址填写的输入框
	 */
	public class UrlComponent extends BaseComponent
	{
		public static var urlText:TextField;
		public static var streamText:TextField;
		public static var labelText:TextField; 
		public static var urlBtn:Button;
		public static var nc:NetConnection;
		
		/**
		 * 初始化输入框label
		 */
		private static function newUrlLabel():TextField
		{
			labelText = newTextField();
			labelText.height = 20;
			labelText.y=292;
			labelText.x=-100;
			labelText.text = "URL";
			labelText.setTextFormat(BaseUI.textFormat);
			return labelText;
		}
		
		/**
		 * 初始化url输入框 
		 */
		private static function newUrlTextField():TextField
		{
			urlText = newTextField();
			urlText.border = true; 
			urlText.type = TextFieldType.INPUT;
			urlText.restrict = null;
			urlText.height = 12;
			urlText.width = 130;
			urlText.x=-60;
			urlText.y=292;
			urlText.text = "rtmp://192.168.1.29/live";
			urlText.setTextFormat(BaseUI.textFormat);
			return urlText;
		}
		
		/**
		 * 初始化流名输入框 
		 */
		private static function newStreamTextField():TextField
		{
			streamText = newTextField();
			streamText.border = true; 
			streamText.type = TextFieldType.INPUT;
			streamText.restrict = null;
			streamText.height = 12;
			streamText.width = 40;
			streamText.x = 73;
			streamText.y =292;
			streamText.text = "123456";
			streamText.setTextFormat(BaseUI.textFormat);
			return streamText;
		}
		
		/**
		 * 初始化输入框相关按钮
		 */
		private static function newUrlButton():Button
		{
			urlBtn = newBtn();
			urlBtn.y = 291;
			urlBtn.x = 116;
			urlBtn.width = 29;
			urlBtn.height = 14;
			urlBtn.label = "play";
			urlBtn.setStyle("textFormat",BaseUI.textFormat);
			urlBtn.addEventListener(MouseEvent.CLICK,btnClick);
			return urlBtn;
		}
		
		/**
		 * 鼠标单击事件
		 */
		protected static function btnClick(e:MouseEvent):void
		{
			if(StringUtils.isEmpty(urlText.text)){
				ConsoleComponent.log("Url is empty");
				return;
			}
			nc.connect(urlText.text);
		}
		
		/**
		 * 加载组件所有模块
		 */
		public static function load(stage:Stage):void
		{
			stage.addChild(newUrlTextField());
			stage.addChild(newUrlLabel());
			stage.addChild(newUrlButton());
			stage.addChild(newStreamTextField());
		}
		
		/**
		 * 设置NetConnection
		 */
		public static function setNetConnection(netc:NetConnection):void
		{
			nc = netc;
		}
	}
}