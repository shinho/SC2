package com.shinho.views.components {
	import flash.display.Sprite;
	
	
	
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class CountryNameView extends Sprite {
		private static var btCountry:ButtonCountry = new ButtonCountry();
		
		
		
		public function CountryNameView() {
			super();
			addChild(btCountry);
			btCountry.y = 61;
			btCountry.height = 49;
		}
		

		public function refreshCountryName(countryName:String):void {
			btCountry.btText.text = countryName;
			btCountry.back.width = btCountry.btText.textWidth + 25;
			btCountry.dividerLine.x = btCountry.back.width;
			btCountry.btText.width = btCountry.btText.textWidth + 10;
		}
	}
}