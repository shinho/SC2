package com.shinho.views.decades
{

	import com.greensock.TweenMax;
	import com.shinho.models.FlexLayout;
	import com.shinho.util.AppDesign;
	import com.shinho.util.SpriteUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class DecadesView extends Sprite
	{
		public var page:FlexLayout;
		public var yearsHolder:Sprite;
		private var _buttonYear:DecadeButtonYear;
		private var _decadesPointer:Array = [];
		private var _isDisplayed:Boolean = false;
		public var decadeSelectedSignal : Signal = new Signal(String);


		public function DecadesView()
		{
		}


		public function destroyDecades():void
		{
			_decadesPointer.length = 0;
			_buttonYear = null;
			SpriteUtils.removeAllChild(yearsHolder);
			_isDisplayed = false;
		}


		public function displayDecades(decades:Array, currentDecade:String):void
		{
			if (_isDisplayed)
			{
				destroyDecades();
			}

			yearsHolder.y = page.header;
			for (var i:int = 0; i < decades.length; i++)
			{
				_buttonYear = new DecadeButtonYear(decades[i]);
				yearsHolder.addChild(_buttonYear);
				_decadesPointer.push(_buttonYear);
				_buttonYear.y = i * AppDesign.BUTTON_DECADE_HEIGHT;
				_buttonYear.buttonMode = true;
				_buttonYear.addEventListener(MouseEvent.CLICK, decadeSelected);
			}
			setSelectedCurrentDecade(currentDecade);
			_isDisplayed = true;
		}


		public function init():void
		{
			var darkArea:Sprite = new QuadSWC();
			this.addChild(darkArea);
			TweenMax.to(darkArea, 0, {alpha: 0.4});
			page.add(darkArea, page.LEFT, 0, page.NONE, page.header + 1, page.NONE, 50, page.TALL,
			         -page.header + 1 - 40);

			yearsHolder = new Sprite();
			addChild(yearsHolder);
			page.forceResize();
		}


		public function setSelectedCurrentDecade(currentDecade:String):void
		{
			for (var i:int = 0; i < _decadesPointer.length; i++)
			{
				var decade:DecadeButtonYear = _decadesPointer[i] as DecadeButtonYear;
				if (decade.decade == currentDecade)
				{
					decade.setSelected();
				}
				else
				{
					decade.setDeselected();
				}
			}
		}


		private function decadeSelected(event:MouseEvent):void
		{
			decadeSelectedSignal.dispatch(event.currentTarget.decade);
		}
	}
}