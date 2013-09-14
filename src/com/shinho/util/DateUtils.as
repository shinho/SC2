package com.shinho.util
{

	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class DateUtils
	{

		public function DateUtils()
		{
			super();
		}


		public static function getCurrentYear():Number
		{
			var currentDate:Date = new Date();
			var year:Number = currentDate.fullYear;
			return year;
		}
	}
}