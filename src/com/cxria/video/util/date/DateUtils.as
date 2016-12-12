package com.cxria.video.util.date
{
	/**
	 * 时间相关函数
	 */
	public class DateUtils
	{
		public static function now():String
		{
			var nowdate:Date = new Date();
//			var year:Number = nowdate.getFullYear(); 
//			var month:Number = nowdate.getMonth()+1;
//			var day:Number = nowdate.getDate();
			var hour:Number = nowdate.getHours();
			var minutes:Number = nowdate.getMinutes();
			var seconds:Number = nowdate.getSeconds();
			//year + "-" + month + "-" + day + " " + 
			return hour + ":" + minutes + ":" + seconds;
		}
	}
}