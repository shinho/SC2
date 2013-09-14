package com.shinho.views.countrySelector
{

	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.shinho.enums.LangEnum;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.dto.CountryDTO;
	import com.shinho.util.Color;
	import com.shinho.util.SpriteUtils;
	import com.shinho.views.components.GlowButton;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	import org.osflash.signals.Signal;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class CountrySelectorView extends MovieClip
	{
		// properties
		public var countries:Vector.<CountryDTO>;
		public var countrySelectedSignal:Signal = new Signal(CountryDTO);
		public var countrySelectorBoard:MovieClip = new CountrySelectorSWC();
		public var page:FlexLayout;
		private var blackBackground:Sprite = SpriteUtils.drawQuad(0,0,10,10);
		private var suggestButtons:Array;
		private var suggestions:Vector.<CountryDTO> = Vector.<CountryDTO>([]);


		public function CountrySelectorView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}


		public function changeLabels(item:XMLList):void
		{
			countrySelectorBoard.title.text = item[LangEnum.COUNTRYSELECTOR_TITLE].@label;
			countrySelectorBoard.userInput.text = item[LangEnum.COUNTRYSELECTOR_TYPEHERE].@label;
		}


		public function closeBoard():void
		{
			this.visible = false;
			SpriteUtils.removeAllChild(countrySelectorBoard);
			removeChild(blackBackground);
			removeChild(countrySelectorBoard);
			countrySelectorBoard = null;
			blackBackground = null;
		}


		public function countrySelected():CountryDTO
		{
			var countrySelected:CountryDTO;
			for (var i:int = 0; i < countries.length; i++)
			{
				if (countries[i].country == countrySelectorBoard.userInput.text)
				{
					countrySelected = countries[i];
				}
			}
			return countrySelected;
		}


		private function getSuggestion(index:int):String
		{
			var suggestionText:String;
			if (index > suggestions.length)
			{
				suggestionText = "";
			}
			else
			{
				suggestionText = suggestions[index - 1].country;
			}
			return suggestionText;
		}


		private function writeSuggestions():void
		{
			for (var i:int = 0; i < suggestButtons.length; i++)
			{
				var item:MovieClip = suggestButtons[i];
				item.legend.text = getSuggestion(i + 1);
			}
		}


		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			/// cretes backgroun and animates
			addChild(blackBackground);
			page.add(blackBackground, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60);
			TweenMax.to(blackBackground, 0, {tint: Color.BLACK1, x: -page.wide});
			TweenMax.to(blackBackground, 1.3, {x: 0, alpha: 0.90, ease: Expo.easeOut});

			/// add country selector board
			addChild(countrySelectorBoard);
			page.add(countrySelectorBoard, page.CENTERX, -(countrySelectorBoard.width / 2), page.CENTERY,
			         -(countrySelectorBoard.height / 2), page.NONE, 0, page.NONE, 0);
			page.forceResize();

			suggestions = countries.concat();
			countrySelectorBoard.btOk.alpha = 0;

			// TODO : change this in the fla
			var closeButton:GlowButton = new GlowButton(countrySelectorBoard.btClose);

			suggestButtons = new Array(countrySelectorBoard.sug01, countrySelectorBoard.sug02,
			                           countrySelectorBoard.sug03, countrySelectorBoard.sug04,
			                           countrySelectorBoard.sug05, countrySelectorBoard.sug06,
			                           countrySelectorBoard.sug07);

			for (var i:int = 0; i < suggestButtons.length; i++)
			{
				var item:MovieClip = suggestButtons[i];
				item.buttonMode = true;
				item.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				item.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
				item.addEventListener(MouseEvent.CLICK, suggestClicked, false, 0, true);
			}
			countrySelectorBoard.userInput.addEventListener(MouseEvent.CLICK, clearInputField, false, 0, true);
			countrySelectorBoard.userInput.addEventListener(KeyboardEvent.KEY_UP, suggest, false, 0, true);

			countrySelectorBoard.btOk.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			countrySelectorBoard.btOk.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			countrySelectorBoard.btOk.addEventListener(MouseEvent.CLICK, onCountrySelected);

			countrySelectorBoard.btClose.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			countrySelectorBoard.btClose.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);

			writeSuggestions();
		}


		private function onCountrySelected(event:MouseEvent):void
		{
			countrySelectedSignal.dispatch(countrySelected());
			closeBoard();
		}


		private function onOver(e:MouseEvent):void
		{
			e.currentTarget.filters = [new GlowFilter(Color.GLOW_BLUE, .75, 5, 5, 2, 3, false, false)];
		}


		private function onOut(e:MouseEvent):void
		{
			e.currentTarget.filters = [];
		}


		private function suggestClicked(e:MouseEvent):void
		{
			var countryName:String = e.target.parent.legend.text;
			if (countryName != "")
			{
				countrySelectorBoard.userInput.text = e.target.parent.legend.text;
				countrySelectorBoard.btOk.alpha = 1;
				countrySelectorBoard.btOk.buttonMode = true;
			}
		}


		private function suggest(e:KeyboardEvent):void
		{
			suggestions.length = 0;
			for (var i:int = 0; i < countries.length; i++)
			{
				var country:CountryDTO = countries[i] as CountryDTO;
				var countryName:String = country.country.toLowerCase();
				if (countryName.indexOf(countrySelectorBoard.userInput.text.toLowerCase()) == 0)
				{
					suggestions.push(countries[i]);
				}
			}
			writeSuggestions();
		}


		private function clearInputField(e:MouseEvent):void
		{
			e.target.text = "";
			countrySelectorBoard.btOk.alpha = 0;
			countrySelectorBoard.btOk.buttonMode = false;
		}
	}
}