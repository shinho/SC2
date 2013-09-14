package com.shinho.util
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;


	public class SpriteUtils
	{
		public function SpriteUtils():void
		{
		}


		public static function drawQuad(xpos:uint, ypos:uint, width:uint, height:uint, tint:uint = 0x000000):Sprite
		{
			var mc:Sprite = new Sprite();
			// drawing a white rectangle
			mc.graphics.beginFill(tint);
			// white
			mc.graphics.drawRect(xpos, ypos, width, height);
			// x, y, width, height
			mc.graphics.endFill();
			return mc;
		}


		public static function setPosition(displayObject:DisplayObject, xpos:Number, ypos:Number):void
		{
			displayObject.x = xpos;
			displayObject.y = ypos;
		}


		public static function removeAllChild(mc:Sprite):void
		{
			if (mc != null)
			{
				while (mc.numChildren != 0 && mc != null)
					mc.removeChildAt(0);
				mc = null;
			}
		}
	}
}