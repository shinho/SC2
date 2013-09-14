package com.shinho.util {
	import flash.display.Sprite
	
	
	
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class Shapes {

		public function Shapes() {
			super();
		}
		
		
		
		public static function drawRoundBox(xpos:int, ypos:int, width:int, height:int, roundness:int,borderWidth:int, borderColor:int, fillColor:int):Sprite {
			var square:Sprite = new Sprite();
			square.graphics.lineStyle(borderWidth, borderColor);
			square.graphics.beginFill(fillColor);
			square.graphics.drawRoundRect(xpos, ypos, width, height, roundness);
			square.graphics.endFill();
			return square;
		}

	}
}