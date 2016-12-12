package com.cxria.video.util.str
{
	/**
	 * 字符串工具类
	 */
	public class StringUtils
	{
		public static function isEmpty(str:String):Boolean
		{
			if(str == null || str.length == 0){
				return true;
			}
			return false;
		}
	}
}