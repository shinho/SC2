package com.shinho.views.types {
	import flash.display.MovieClip;
	import com.greensock.*;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class ButtonTypeView extends MovieClip {
		//PROPERTIES
		private var _id:int = 0;
		private var buttonType:MovieClip;
		private static var fadeValue:Number = .65;





		public function ButtonTypeView(buttonID:int, labeltext:String){
			buttonType = new ButtonNewType_SWC();
			addChild(buttonType);
			buttonType.label.text = labeltext;
			_id = buttonID;
		}



		private function over(e:Event):void {
			TweenMax.to(buttonType.front, 0.8, {alpha: fadeValue});
		}



		private function out(e:Event):void {
			TweenMax.to(buttonType.front, 0.8, {alpha: 0});
		}



		public function setSelected():void {
			TweenMax.to(buttonType.front, 0.8, {alpha: fadeValue-0.1});
			buttonType.top.removeEventListener(MouseEvent.MOUSE_OUT, out);
			buttonType.top.removeEventListener(MouseEvent.MOUSE_OVER, over);
		}



		public function setDeselected():void {
			TweenMax.to(buttonType.front, 0.8, {alpha: 0});
			buttonType.top.addEventListener(MouseEvent.ROLL_OVER, over);
			buttonType.top.addEventListener(MouseEvent.MOUSE_OUT, out);
		}



		public function get id():int {
			return _id;
		}
	}
}