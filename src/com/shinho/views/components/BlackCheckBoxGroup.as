package com.shinho.views.components {
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import com.greensock.easing.Expo;
	
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class BlackCheckBoxGroup {
		public var selected:int = 0;
		private var buttons:Array;
		private var enabled:Boolean;
		private static var speed:Number = 0.15;
		
		
		
		public function BlackCheckBoxGroup(buttons:Array, enabled:Boolean = true){
			this.buttons = buttons;
			this.enabled = enabled;
			for (var i:int = 0; i < buttons.length; i++){
				var item:Object = buttons[i];
				item.buttonMode = true;
				item.value = i + 1;
				item.addEventListener(MouseEvent.MOUSE_OVER, dotOnOver);
				item.addEventListener(MouseEvent.MOUSE_OUT, dotOnOut);
				item.addEventListener(MouseEvent.CLICK, dotClicked);
			}
		}
		
		
		
		public function setLegends(legends:Array):void {
			if (buttons.length > 0 && legends.length == buttons.length){
				for (var i:int = 0; i < buttons.length; i++){
					var item:Object = buttons[i];
					item.legendHolder.legend.text = legends[i];
				}
			}
		}
		
		
		
		public function setSelected(checkButtonNumber:int):void {
			if (checkButtonNumber >= 0 && checkButtonNumber <= buttons.length + 1) {
				selected = checkButtonNumber;
			} else {
				selected = 0;
			}
			displayState();
		}
		
		
		
		public function enable():void {
			enabled = true;
		}
		
		
		
		public function disable():void {
			enabled = false;
		}
		
		
		
		private function dotOnOver(e:MouseEvent):void {
			if (enabled){
				e.currentTarget.filters = [new GlowFilter(0x32ebfb, .75, 5, 5, 2, 3, false, false)];
				if (e.currentTarget.legendHolder != null){
					TweenLite.to(e.currentTarget.legendHolder, speed, {alpha: 1, ease: Expo.easeOut});
				}
			}
		}
		
		
		
		private function dotOnOut(e:MouseEvent):void {
			if (enabled){
				e.currentTarget.filters = [];
				if (e.currentTarget.value != selected && e.currentTarget.legendHolder != null){
					TweenLite.to(e.currentTarget.legendHolder,speed, {alpha: 0, ease: Expo.easeOut});
				}
			}
		}
		
		
		
		private function dotClicked(e:MouseEvent):void {
			if (enabled){
				if (selected == e.currentTarget.value){
					selected = 0;
				} else {
					selected = e.currentTarget.value;
				}
				displayState();
			}
		}
		
		
		
		private function displayState():void {
			for (var i:int = 0; i < buttons.length; i++){
				var item:Object = buttons[i];
				if (i + 1 == selected) {
					//item.btOn.alpha = 1;
					TweenLite.to(item.btOn, speed, {alpha: 1, ease: Expo.easeOut});
				} else {
					//item.btOn.alpha = 0;
					TweenLite.to(item.btOn, speed, {alpha: 0, ease: Expo.easeOut});
				}
			}
		}
	}
}