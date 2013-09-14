package com.shinho.views.bottomMenu
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	
	
	
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class ButtonChangeCountry extends MovieClip
	{
		private var _button:MovieClip = new btChangeCountrytSWC();
		
		
		
		public function ButtonChangeCountry()
		{
			super();
			addChild(_button);
			_button.buttonMode = true;
			_button.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_button.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		
		
		private function onOver(e:MouseEvent):void
		{
			TweenMax.to (_button.iconOver, 0.4, { alpha:1 } );
			TweenMax.to (_button.legend, 0.4, { tint:0xffffff } );

		}
		
		
		
		private function onOut(e:MouseEvent):void
		{
			TweenMax.to (_button.iconOver, 0.4, { alpha:0 } );
			TweenMax.to (_button.legend, 0.4, { tint:0x999999 } );
		}
		
		
		
		public function changeLabel(label:String):void
		{
			_button.legend.text = label;
		}
	}
}