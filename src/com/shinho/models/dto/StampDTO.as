package com.shinho.models.dto
{

	import com.shinho.models.StampDatabase;

	import flash.filesystem.File;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class StampDTO
	{

		public var amount:String;
		public var cancel:String;
		public var centering:String;
		public var centering_value:int;
		public var circulation:String;
		public var color:String;
		public var comments:String;
		public var condition:String;
		public var condition_value:int;
		public var cost:Number;
		public var country:String;
		public var current_value:Number;
		public var date_purchased:String;
		public var denomination:String;
		public var designer:String;
		public var faults:String;
		public var format:String;
		public var grade:String;
		public var gum:String;
		public var gum_value:int;
		public var hinged:String;
		public var hinged_value:int;
		public var history:String;
		public var id:int;
		public var inscription:String;
		public var issue_date:String;
		public var main_catalog:String;
		public var number:String;
		public var owned:Boolean;
		public var paper:String;
		public var perforation:String;
		public var printer:String;
		public var purchase_year:int;
		public var seller:String;
		public var serie:String;
		public var spares:int;
		public var type:String;
		public var used:Boolean;
		public var variety:String;
		public var watermark:String;
		public var year:String;
		public var originalID:String;

		public function StampDTO()
		{
		}


		public function getPath():String
		{
			var slash:String = File.separator;
			var path:File = File.documentsDirectory.resolvePath(StampDatabase.DIR_IMAGES + slash + country + slash + type + slash + number);
			return path.url;
		}


		public function getStampDecade():String
		{
			return year.substr(0, 3) + "0";
		}
	}

}