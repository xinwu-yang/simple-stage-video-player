package com.cxria.video.components
{
	import com.cxria.video.base.BaseComponent;
	import com.cxria.video.base.BaseUI;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;

	/**
	 * 播放器控制条
	 */
	public class ControlBarComponent extends BaseComponent
	{
		private static var ns:NetStream;
		private static var volume:Number = 0;
		public static var pauseBtn:Button;
		public static var soundBtn:Button;//静音和开放按钮 
		public static var modelBox:ComboBox;
		//private var urlBtn:Button;
		//private var urlBtn:Button;
		
		private static function newPauseBtn():Button
		{
			pauseBtn = newBtn();
			pauseBtn.y = 250;
			pauseBtn.x = -60;
			pauseBtn.width = 29;
			pauseBtn.height = 18;
			pauseBtn.label = "pause";
			pauseBtn.addEventListener(MouseEvent.CLICK,pauseClick);
			pauseBtn.setStyle("textFormat",BaseUI.textFormat);
			return pauseBtn;
		}
		
		private static function newSoundBtn():Button
		{
			soundBtn = newBtn();
			soundBtn.y = 250;
			soundBtn.x = -30;
			soundBtn.width = 29;
			soundBtn.height = 18;
			soundBtn.label = "sound";
			soundBtn.addEventListener(MouseEvent.CLICK,soundClick);
			soundBtn.setStyle("textFormat",BaseUI.textFormat);
			return soundBtn;
		}
		
		private static function newModelComboBox():ComboBox
		{
			modelBox = newComboBox();
			modelBox.x = 20;
			modelBox.y = 250;
			modelBox.width = 53;
			modelBox.height = 18;
			modelBox.textField.setStyle("textFormat",BaseUI.textFormat);
			modelBox.editable=false;
			modelBox.prompt="模式选择";
			modelBox.rowCount=4;
			modelBox.dropdown.setRendererStyle("textFormat",BaseUI.textFormat);
			modelBox.dropdown.rowHeight=13;
			
			modelBox.addItem({label:"360°3D",data:"1"});
			modelBox.addItem({label:"360°",data:"2"});
			modelBox.addItem({label:"3D",data:"3"});
			modelBox.addItem({label:"2D",data:"4"});
			modelBox.addEventListener(Event.CHANGE,changeFun);
			return modelBox;
		}
		
		/**
		 * 设置NetStream
		 */
		public static function setNetStream(nets:NetStream):void
		{
			ns = nets;
		}
		
		/**
		 * 加载所有UI组建
		 */
		public static function load(stage:Stage):void
		{
			stage.addChild(newPauseBtn());
			stage.addChild(newSoundBtn());
			stage.addChild(newModelComboBox());
		}
		
		/**
		 * 暂停/继续
		 */
		protected static function pauseClick(e:MouseEvent):void
		{
			if(ns != null){
				ns.togglePause();
			}
		} 
		
		/**
		 * 静音/关闭静音
		 */
		protected static function soundClick(e:MouseEvent):void
		{
			if(ns != null){
				if(ns.soundTransform.volume != 0){
					volume = ns.soundTransform.volume;
					ns.soundTransform = new SoundTransform(0,0);
					ConsoleComponent.log("Sound Off");
				}else{
					ns.soundTransform = new SoundTransform(volume,0);
					ConsoleComponent.log("Sound On");
				}
			}
		}
		
		/**
		 * 切换模式
		 */
		protected static function changeFun(e:Event):void {
			ConsoleComponent.log(modelBox.selectedItem.label + " : " + modelBox.selectedItem.data);
		}
	}
}