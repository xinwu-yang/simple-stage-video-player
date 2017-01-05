package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	import com.cxria.video.base.BaseUI;
	import com.cxria.video.util.str.StringUtils;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
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
		public static var callBtn:Button;
		
		public static var nc:NetConnection;
		public static var serverNc:NetConnection;
		
		/**
		 * 初始化输入框label
		 */
		private static function newUrlLabel():TextField
		{
			labelText = newTextField();
			labelText.height = 20;
			labelText.y=292;
			labelText.x=-30;
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
			urlText.y=292;
			urlText.x=10;
			urlText.text = "rtmp://192.168.1.29/server";
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
			streamText.y =292;
			streamText.x = 143;
			streamText.text = "mp4:2.mp4";
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
			urlBtn.x = 186;
			urlBtn.width = 29;
			urlBtn.height = 14;
			urlBtn.label = "play";
			urlBtn.setStyle("textFormat",BaseUI.textFormat);
			urlBtn.addEventListener(MouseEvent.CLICK,btnClick);
			return urlBtn;
		}
		
		/**
		 * 连接服务器
		 */
		private static function newCallButton():Button
		{
			callBtn = newBtn();
			callBtn.y = 291;
			callBtn.x = 216;
			callBtn.width = 29;
			callBtn.height = 14;
			callBtn.label = "call";
			callBtn.setStyle("textFormat",BaseUI.textFormat);
			callBtn.addEventListener(MouseEvent.CLICK,callClick);
			return callBtn;
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
			if(nc.connected){
				nc.close();
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
			stage.addChild(newCallButton());
		}
		
		/**
		 * 隐藏所有组件
		 */
		public static function hide(stage:Stage):void
		{
			stage.removeChild(urlText);
			stage.removeChild(labelText);
			stage.removeChild(urlBtn);
			stage.removeChild(streamText);
		}
		
		/**
		 * 设置NetConnection
		 */
		public static function setNetConnection(netc:NetConnection):void
		{
			nc = netc;
		}
		
		/**
		 * 鼠标单击事件
		 */
		protected static function callClick(e:MouseEvent):void
		{
			if(serverNc != null && serverNc.connected){
				call();
			}else{
				serverNc = new NetConnection();
				serverNc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				serverNc.connect("rtmp://192.168.1.29/server");
			}
		}

		/**
		 * 处理NetStatusEvent事件
		 */
		private static function onNetStatus(event:NetStatusEvent):void  
		{
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			var code:String = event.info.code.split(".")[2];
			if(code == "Success"){
				call();
			}
		}
		
		/**
		 * 调用服务器方法
		 */
		private static function call():void
		{
			serverNc.call("app/createStream",new Responder(function(result:Object):void 
			{
				ConsoleComponent.log("result: " + JSON.stringify(result));
			},null),
				{"name" : "2"},{"src" : "1" , "format" : "mp4"},{"startTime" : 850, "len" : 10}
			);
		}
	}
}