package com.shinho.views.components
{

	import com.shinho.util.Color;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class GlowButton extends Sprite
	{
		private var button:MovieClip;
		private var enabled:Boolean;


		public function GlowButton(button:MovieClip, enabled:Boolean = true)
		{
			this.enabled = enabled;
			this.button = button;
			button.buttonMode = true;
			button.addEventListener(MouseEvent.MOUSE_OVER, dotOnOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, dotOnOut);

		}


		public function destroy():void
		{
			button.removeEventListener(MouseEvent.MOUSE_OVER, dotOnOver);
			button.removeEventListener(MouseEvent.MOUSE_OUT, dotOnOut);
			//button.removeEventListener(MouseEvent.CLICK, buttonClicked);
		}


		public function disable():void
		{
			enabled = false;
		}


		public function enable():void
		{
			enabled = true;
		}


		private function dotOnOver(e:MouseEvent):void
		{
			if (enabled)
			{
				e.currentTarget.filters = [new GlowFilter(Color.GLOW_BLUE, .75, 5, 5, 2, 3, false, false)];
			}
		}


		private function dotOnOut(e:MouseEvent):void
		{
			if (enabled)
			{
				e.currentTarget.filters = [];
			}
		}
	}
}