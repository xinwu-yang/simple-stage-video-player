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
		public static var stopBtn:Button;
		public static var seekBtn:Button;
		
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
			modelBox.addEventListener(Event.CHANGE,changeModel);
			return modelBox;
		}
		
		private static function newStopButton():Button
		{
			stopBtn = newBtn();
			stopBtn.y = 250;
			stopBtn.x = 90;
			stopBtn.width = 29;
			stopBtn.height = 18;
			stopBtn.label = "stop";
			stopBtn.addEventListener(MouseEvent.CLICK,stopClick);
			stopBtn.setStyle("textFormat",BaseUI.textFormat);
			return stopBtn;
		}
		
		private static function newSeekButton():Button
		{
			seekBtn = newBtn();
			seekBtn.y = 250;
			seekBtn.x = 160;
			seekBtn.width = 29;
			seekBtn.height = 18;
			seekBtn.label = "seek";
			seekBtn.addEventListener(MouseEvent.CLICK,seekClick);
			seekBtn.setStyle("textFormat",BaseUI.textFormat);
			return seekBtn;
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
			stage.addChild(newStopButton());
			stage.addChild(newSeekButton());
		}
		
		/**
		 * 暂停/继续
		 */
		public static function pauseClick(e:MouseEvent):void
		{
			if(ns != null){
				ns.togglePause();
			}
		} 
		
		/**
		 * 静音/关闭静音
		 */
		public static function soundClick(e:MouseEvent):void
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
		 * 设置音量大小
		 */
		public static function changeSound(vol:Number):void
		{
			if(ns != null){
				ns.soundTransform = new SoundTransform(vol,0);
			}
		}
		
		/**
		 * 切换模式
		 */
		public static function changeModel(e:Event):void {
			ConsoleComponent.log(modelBox.selectedItem.label + " : " + modelBox.selectedItem.data);
		}
		
		/**
		 * 停止
		 */
		public static function stopClick(e:MouseEvent):void
		{
			if(ns != null){
				ns.close();
				ConsoleComponent.log("NetStream Close");
			}
		} 
		
		/**
		 * 停止
		 */
		public static function seekClick(e:MouseEvent):void
		{
			if(ns != null){
				ns.seek(120);
			}
		} 
	}
}