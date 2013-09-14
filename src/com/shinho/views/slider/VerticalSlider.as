package com.shinho.views.slider
{
	import com.greensock.TweenMax;
	import com.shinho.models.FlexLayout;
	import com.shinho.util.AppDesign;
	import com.shinho.util.Color;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class VerticalSlider extends Sprite
	{
		//PROPERTIES
		public var contentHeight:Number = 0;
		public var page:FlexLayout;
		public var slider:VerticalSlider_SWC;
		private static var miniumTrackHeight:uint = 35;
		private static var capPixels:uint = 9;
		private static var miniumHeight:uint = 50;
		private static var sliderTrack:VerticalTrack_SWC;


		public function VerticalSlider():void
		{
		}


		// ----------------------------------------------------------------------------
		// PUBLIC methods
		// ----------------------------------------------------------------------------

		public function display():void
		{
			sliderTrack = new VerticalTrack_SWC();
			addChild(sliderTrack);
			page.add(sliderTrack, page.RIGHT, -AppDesign.SLIDER_WIDTH, page.TOP, page.header, page.NONE, 0, page.NONE,
			         0);
			slider = new VerticalSlider_SWC();
			addChild(slider);
			slider.buttonMode = true;
			TweenMax.to(slider, 0.3, {alpha: .8});
			TweenMax.to(sliderTrack, 0.3, {alpha: .9});
			///   checks for slider movement
			slider.addEventListener(MouseEvent.MOUSE_DOWN, moveSlider, false, 0, false);
			slider.visible = true;
		}


		public function newTrackHeight(totalPixels:int):void
		{
			totalPixels = totalPixels < miniumHeight ? miniumHeight : totalPixels;
			var middlePixels:uint = totalPixels - (2 * capPixels);
			sliderTrack.middle.height = middlePixels;
			sliderTrack.bottom.y = middlePixels + capPixels;
		}


		public function setHeight(totalPixels:int):void
		{
			totalPixels = totalPixels < miniumTrackHeight ? miniumTrackHeight : totalPixels;
			var middlePixels:uint = totalPixels - (2 * capPixels);
			slider.middle.height = middlePixels;
			slider.bottom.y = middlePixels + capPixels;
		}


		// ----------------------------------------------------------------------------
		// PRIVATE methods
		// ----------------------------------------------------------------------------

		private function moveSlider(e:Event):void
		{
			var margin:Rectangle = new Rectangle(page.wide - AppDesign.SLIDER_WIDTH, page.header, 0,
			                                     sliderTrack.height - slider.height);
			slider.filters = [new GlowFilter(Color.GLOW_BLUE, .75, 5, 5, 2, 3, false, false)];
			slider.startDrag(false, margin);
			this.addEventListener(MouseEvent.MOUSE_UP, stopSlider);
		}


		private function stopSlider(e:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, stopSlider);
			slider.stopDrag();
			slider.filters = [];
		}
	}
}