package com.shinho.views.decades
{

	import com.greensock.*;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class DecadeButtonYear extends MovieClip
	{
		// PROPERTIES
		public var decade:String;
		private var bt:MovieClip;


		public function DecadeButtonYear(decadeStr:String)
		{
			bt = new ButtonDecadeSWC();
			addChild(bt);
			TweenMax.to(bt.front, 0, {tint: 0x0a2032});
			bt.btText.text = decadeStr;
			decade = decadeStr;
		}


		public function setDeselected():void
		{
			TweenMax.to(bt.front, 0.6, {alpha: 0});
			bt.top.addEventListener(MouseEvent.ROLL_OVER, front);
			bt.top.addEventListener(MouseEvent.MOUSE_OUT, out);
		}


		public function setSelected():void
		{
			TweenMax.to(bt.front, 0.6, {alpha: 0.8});
			bt.top.removeEventListener(MouseEvent.MOUSE_OUT, out);
			bt.top.removeEventListener(MouseEvent.MOUSE_OVER, front);
		}


		private function front(e:Event):void
		{
			TweenMax.to(bt.front, 0.8, {alpha: 0.9});
		}


		private function out(e:Event):void
		{
			TweenMax.to(bt.front, 0.8, {alpha: 0});
		}

	}
}