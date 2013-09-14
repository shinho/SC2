package com.shinho.views.components {
	import flash.display.MovieClip;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class ButtonBlack extends MovieClip {
		//PROPERTIES
		//private var bt:ButtonBlackSWC;
		// var to check if click can be triggered
		public var isEnabled:Boolean = true;



		public function ButtonBlack(labeltext:String, xpos:int=0, ypos:int=0){
/*			bt = new ButtonBlackSWC();
			addChild(bt);
			place(xpos, ypos);
			TweenMax.to(bt.over, 0, {alpha: 0});
			bt.btText.text = labeltext;
			this.buttonMode = true;
			bt.top.addEventListener(MouseEvent.ROLL_OVER, over);
			bt.top.addEventListener(MouseEvent.MOUSE_OUT, out);*/
		}

/*		private function place(xpos:int, ypos:int):void {
			this.x = xpos;
			this.y = ypos;
		}


		private function over(e:Event):void {
			TweenMax.to(bt.over, 0.4, {alpha: 1});
		}



		private function out(e:Event):void {
			TweenMax.to(bt.over, 0.4, {alpha: 0});
		}



		public function setEnabled():void {
			bt.btText.textColor = 0xffffff;
			isEnabled = true;
		}



		public function setDisabled():void {
			bt.btText.textColor = 0x333333;
			isEnabled = false;
		}*/


	}
}