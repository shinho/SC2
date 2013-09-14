package com.shinho.views
{

	import com.shinho.controllers.StampsController;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.dto.SerieDTO;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.util.AppDesign;
	import com.shinho.util.SpriteUtils;
	import com.shinho.views.bottomMenu.BottomMenu;
	import com.shinho.views.components.CountryNameView;
	import com.shinho.views.decades.DecadesView;
	import com.shinho.views.pictureStripe.SeriesStripeView;
	import com.shinho.views.slider.VerticalSlider;
	import com.shinho.views.types.TypesMenu;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class ApplicationMainView extends Sprite
	{

		public var bar:Sprite = new MenuBarSWC();
		[Inject]
		public var controller:StampsController;
		public var currentStamp:StampDTO;
		[Inject]
		public var page:FlexLayout;
		public var stampsDisplayed:Boolean = false;
		private static const MINIMUM_STRIPES:uint = 10;
		private static var _allStripes:Sprite;
		private static var _allStripesMask:Sprite;
		private static var _verticalSlider:VerticalSlider;
		private static var _logo:MovieClip = new LogotipoSWC();
		private static var _selos:MovieClip = new Selos_SWC();
		private static var _background:MovieClip = new BackgroundSWC();
		private static var _bottomMenu:BottomMenu;
		private static var _btCountry:CountryNameView = new CountryNameView();
		private static var _totalStripes:int;
		private static var _currentStripeIndex:int;
		private static var _maxStripes:uint;
		private static var _stripesTotalHeight:Number;
		private static var _seriesStripes:Vector.<SeriesStripeView>;
		private var _numberOfStampSeries:uint = 0;
		private var _stampSeries:Vector.<SerieDTO>;
		private var decadeYears:DecadesView = new DecadesView();
		private var typesMenu:TypesMenu = new TypesMenu();
		private var _usableHeight:Number;


		public function ApplicationMainView()
		{
			addChild(_background);
			addChild(_selos);
			addChild(_logo);
			addChild(bar);
			changeBuild();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}


		// ----------------------------------------------------------------------------
		// PUBLIC methods
		// ----------------------------------------------------------------------------

		public function clearDisplay():void
		{
			_allStripes.visible = false;
			if (stampsDisplayed == true)
			{
				for (var i:int = 0; i < _seriesStripes.length; i++)
				{
					try
					{
						_seriesStripes[i].destroy();
					}
					catch (e:Error)
					{
						/// do nothing
					}
				}
				SpriteUtils.removeAllChild(_allStripes);
			}
			stampsDisplayed = false;
			_bottomMenu.stampsDisplayed = stampsDisplayed;
			_stampSeries = null;
			_seriesStripes = null;
			_allStripes.visible = true;
		}


		public function displayCountryName(countryName:String):void
		{
			_btCountry.refreshCountryName(countryName);
			typesMenu.x = _btCountry.x + _btCountry.width;
		}


		public function displayVisibleStripes():void
		{
			var initDisplay:int = _currentStripeIndex - (MINIMUM_STRIPES / 2) > 0 ? _currentStripeIndex - (MINIMUM_STRIPES / 2) : 0;
			var endDisplay:int = _currentStripeIndex + MINIMUM_STRIPES > _numberOfStampSeries ? _numberOfStampSeries : _currentStripeIndex + MINIMUM_STRIPES;
			for (var i:int = initDisplay; i < endDisplay; i++)
			{
				var stripeView:SeriesStripeView = _seriesStripes[i] as SeriesStripeView;
				if (!stripeView.isDisplayed)
				{
					stripeView.setData(_stampSeries[i].serieStamps);
					_verticalSlider.visible = true;
					stampsDisplayed = true;
					_bottomMenu.stampsDisplayed = stampsDisplayed;
				}
			}
		}


		public function insertInStripePointer(index:int):void
		{
			_seriesStripes.splice(index, 0, null);
		}


		public function moveStripeToTop(serie:SeriesStripeView):void
		{
			if (_verticalSlider.slider.height < _allStripesMask.height)
			{
				var stripeY:Number = 0;
				for (var i:int = 0; i < _seriesStripes.length; i++)
				{

					if (_seriesStripes[i].serieIndex == serie.serieIndex)
					{
						stripeY = _seriesStripes[i].y;
					}

				}
				var middlePart:int = _allStripesMask.height;
				var step:Number = _stripesTotalHeight / (middlePart - _verticalSlider.slider.height);
				var distance:Number = stripeY - page.header;
				_verticalSlider.slider.y = (distance / step) + page.header;
				if (_verticalSlider.slider.y + _verticalSlider.slider.height > page.footer)
				{
					_verticalSlider.slider.y = page.footer - _verticalSlider.slider.height;
				}
				if (_verticalSlider.slider.y < page.header)
				{
					_verticalSlider.slider.y = page.header;
				}
			}
		}


		public function moveToDecade(decade:String):void
		{
			if (stampsDisplayed)
			{
				var counter:uint = 0;
				var foundStripe:Boolean = false;
				while (!foundStripe && counter <= _numberOfStampSeries - 1)
				{
					var serie:SeriesStripeView = _seriesStripes[counter];
					if (serie.serieDecade == decade)
					{
						foundStripe = true;
					}
					else
					{
						counter++;
					}
				}
				_currentStripeIndex = counter;
				displayVisibleStripes();
				moveStripeToTop(_seriesStripes[_currentStripeIndex]);
			}
		}


		public function onResize():void
		{
			if (_verticalSlider)
			{
				_usableHeight = _allStripesMask.height;
				_verticalSlider.newTrackHeight(_usableHeight);
				var numVisibleStripes:int = (_usableHeight / AppDesign.STRIPE_HEIGTH)+1;
				var percent:Number = (_usableHeight / _stripesTotalHeight);
				if (_numberOfStampSeries > numVisibleStripes)
				{
					var sliderPixels:uint = int(_usableHeight * percent) > 50 ? int(_usableHeight * percent) : 50;
					_verticalSlider.setHeight(sliderPixels);
				}
				else
				{
					_verticalSlider.setHeight(_usableHeight);
				}
				_verticalSlider.slider.x = page.wide - AppDesign.SLIDER_WIDTH;
				_verticalSlider.slider.y = page.header;
			}
		}


		public function prepareSeriesStripes(stampList:Vector.<StampDTO>):void
		{
			_maxStripes = MINIMUM_STRIPES;
			stampsDisplayed = false;
			_bottomMenu.stampsDisplayed = stampsDisplayed;
			_seriesStripes = Vector.<SeriesStripeView>([]);
			/// then sort every stripe using PictureStripe Class
			_currentStripeIndex = 0;
			for (var i:int = 0; i < _numberOfStampSeries; i++)
			{
				var _stripe:SeriesStripeView = new SeriesStripeView(_stampSeries[i].serieName,
				                                                    _stampSeries[i].serieYear, i);
				_allStripes.addChild(_stripe);
				SpriteUtils.setPosition(_stripe, AppDesign.BUTTON_YEAR_DISPLACE,
				                        (i * AppDesign.STRIPE_HEIGTH) + page.header);
				_seriesStripes[i] = _stripe;
			}
			displayVisibleStripes();

			_stripesTotalHeight = _numberOfStampSeries * AppDesign.STRIPE_HEIGTH;
			_verticalSlider.contentHeight = _stripesTotalHeight;
			onResize();
			page.forceResize();
		}


		public function refreshSerie(data:Vector.<StampDTO>, serieName:String, year:String):void
		{
			var foundIndex:int = -1;
			var found:Boolean = false;
			while (!found && foundIndex <= _seriesStripes.length)
			{
				foundIndex++;
				if (_seriesStripes[foundIndex].serieName == serieName && _seriesStripes[foundIndex].serieYear == year)
				{
					found = true;
				}
			}
			_seriesStripes[foundIndex].refreshStripe(data, "1");
		}


		public function serieChanged(newStamps:Vector.<StampDTO>, prevSerie:String, prevYear:String,
		                             currentSerie:String, currentYear:String):void
		{
			var justUpdateStripe:Boolean = false;
			var newSeries:Vector.<StampDTO> = Vector.<StampDTO>([]);
			var serieItems:Vector.<StampDTO>;
			var add:int = newSeries.length - _seriesStripes.length;
			if (add < -2)
			{
				trace("OOOOOOOOPPPPPPPPPSSSSSSSS");
			}
			for (var foundIndex:int = 0; foundIndex <= newSeries.length - 1; foundIndex++)
			{
				var added:Boolean = false;
				try
				{
					if (_seriesStripes[foundIndex].serieName != newSeries[foundIndex].serie || _seriesStripes[foundIndex].serieYear != newSeries[foundIndex].year && _seriesStripes[foundIndex].serieName != null)
					{
						if (add >= 1)
						{
							insertNewStripe(newStamps, newSeries, foundIndex);
							added = true;
						}
						if (add <= -1)
						{
							deleteSerie(foundIndex);
						}
						if (add == 0)
						{
							// --------------  check to insert
							if (_seriesStripes[foundIndex].serieName == newSeries[foundIndex + 1].serie && _seriesStripes[foundIndex].serieYear == newSeries[foundIndex + 1].year)
							{
								insertNewStripe(newStamps, newSeries, foundIndex);
								added = true;
								add = -1;
							}
							// --------------  check to delete
							if (foundIndex + 1 <= _seriesStripes.length)
							{
								var pointer:uint = foundIndex + 1;
								if (_seriesStripes[pointer].serieName == newSeries[foundIndex].serie && _seriesStripes[pointer].serieYear == newSeries[foundIndex].year)
								{
									deleteSerie(foundIndex);
									add = 1;
								}
							}
						}
					}
					// --------------  check to update
					if ((_seriesStripes[foundIndex].serieName == prevSerie && _seriesStripes[foundIndex].serieYear == prevYear) || (_seriesStripes[foundIndex].serieName == currentSerie && _seriesStripes[foundIndex].serieYear == currentYear))
					{
						if (!added)
						{
							serieItems = getSerieItems(newStamps, newSeries[foundIndex].serie,
							                           newSeries[foundIndex].year);
							_seriesStripes[foundIndex].refreshStripe(serieItems, foundIndex.toString());
							added = false;
						}
					}
				}
				catch (e:Error)
				{
					/// ignore error : no stripe pointer, add a new one
					if (add >= 1)
					{
						insertNewStripe(newStamps, newSeries, foundIndex);
						added = true;
					}
				}
			}
			while (_seriesStripes.length > newSeries.length)
			{
				deleteSerie(_seriesStripes.length - 1);
			}
			_totalStripes = newSeries.length;
		}


		public function setStampSeries(value:Vector.<SerieDTO>):void
		{
			_stampSeries = value;
 			_numberOfStampSeries = _stampSeries.length;
		}


		public function wheelMovement(delta:Number):void
		{
			if (delta < 0 && _verticalSlider.slider.y + _verticalSlider.slider.height <= page.footer)
			{
				delta = delta < -3 ? -3 : delta;
				_verticalSlider.slider.y = (_verticalSlider.slider.y - delta + _verticalSlider.slider.height < page.footer ? _verticalSlider.slider.y - delta : page.footer - _verticalSlider.slider.height);
			}
			if (delta > 0 && _verticalSlider.slider.y >= page.header)
			{
				delta = delta > 3 ? 3 : delta;
				_verticalSlider.slider.y = (_verticalSlider.slider.y - delta > page.header ? _verticalSlider.slider.y - delta : page.header);
			}
		}


		// ----------------------------------------------------------------------------
		// PRIVATE methods
		// ----------------------------------------------------------------------------

		private function changeBuild():void
		{
			_logo.build.text = AppDesign.BUILD;
			_logo.build.width = 120;
		}


		private function deleteSerie(foundIndex:int):void
		{
			_allStripes.removeChild(_seriesStripes[foundIndex]);
			displaceStripesUp(foundIndex + 1);
			_seriesStripes.splice(foundIndex, 1);
		}


		private function displaceStripesDown(initIndex:int):void
		{
			while (initIndex <= _seriesStripes.length - 1)
			{
				_seriesStripes[initIndex].serieIndex = _seriesStripes[initIndex].serieIndex + 1;
				_seriesStripes[initIndex].y = _seriesStripes[initIndex].y + AppDesign.STRIPE_HEIGTH;
				initIndex++;
			}
		}


		private function displaceStripesUp(initIndex:int):void
		{
			while (initIndex <= _seriesStripes.length - 1)
			{
				_seriesStripes[initIndex].serieIndex = _seriesStripes[initIndex].serieIndex - 1;
				_seriesStripes[initIndex].y = _seriesStripes[initIndex].y - AppDesign.STRIPE_HEIGTH;
				initIndex++;
			}
		}


		private function getSerieItems(newStamps:Vector.<StampDTO>, serieName:String, year:String):Vector.<StampDTO>
		{
			var serieItems:Vector.<StampDTO> = Vector.<StampDTO>([]);
			for (var u:int = 0; u < newStamps.length; u++)
			{
				if (newStamps[u].serie == serieName && newStamps[u].year == year)
				{
					serieItems.push(newStamps[u]);
				}
			}
			return serieItems;
		}


		private function insertNewSerie(serieStamps:Vector.<StampDTO>, index:int, serieName:String, year:String):void
		{
			var _stripe:SeriesStripeView = new SeriesStripeView(serieName, year, index);
			_allStripes.addChild(_stripe);
			SpriteUtils.setPosition(_stripe, AppDesign.BUTTON_YEAR_DISPLACE,
			                        (index * AppDesign.STRIPE_HEIGTH) + page.header);
			_seriesStripes[index] = _stripe;
			_seriesStripes[index].setData(serieStamps);
			_seriesStripes[index].displayStripe();
		}


		private function insertNewStripe(newStamps:Vector.<StampDTO>, newSeries:Vector.<StampDTO>, foundIndex:int):void
		{
			displaceStripesDown(foundIndex);
			insertInStripePointer(foundIndex);
			var serieItems:Vector.<StampDTO> = getSerieItems(newStamps, newSeries[foundIndex].serie,
			                                                 newSeries[foundIndex].year);
			insertNewSerie(serieItems, foundIndex, newSeries[foundIndex].serie, newSeries[foundIndex].year);
		}


		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			page.add(_background, page.NONE, 0, page.NONE, 0, page.WIDE, 0, page.TALL, 0);
			page.add(_selos, page.WIDE, 0, page.NONE, 0, page.NONE, 0, page.NONE, 0);

			_allStripes = new Sprite();
			_allStripesMask = SpriteUtils.drawQuad(0, 0, page.wide, page.tall);
			addChild(_allStripes);
			addChild(_allStripesMask);
			_allStripes.mask = _allStripesMask;
			page.add(_allStripesMask, page.LEFT, 0, page.NONE, page.header + 1, page.WIDE, -AppDesign.SLIDER_WIDTH,
			         page.TALL, -page.header - (page.tall - page.footer) );

			_bottomMenu = new BottomMenu();
			addChild(_bottomMenu);
			_bottomMenu.stampsDisplayed = stampsDisplayed;

			addChild(_btCountry);
			addChild(typesMenu);
			addChild(decadeYears);
			decadeYears.decadeSelectedSignal.add(moveToDecade)

			_verticalSlider = new VerticalSlider();
			_verticalSlider.page = page;
			_verticalSlider.display();
			addChild(_verticalSlider);
			_verticalSlider.addEventListener(Event.ENTER_FRAME, scrollStripes, false, 0, false);

			onResize();
			page.forceResize();
		}


		private function scrollStripes(e:Event):void
		{
			if (_allStripes)
			{
				var middlepart:int = _allStripesMask.height;
				var step:Number = (_stripesTotalHeight / (middlepart - _verticalSlider.slider.height));
				var yDisplace:Number = int(step * (_verticalSlider.slider.y - page.header));
				if (yDisplace > _stripesTotalHeight - AppDesign.STRIPE_HEIGTH)
				{
					yDisplace = _stripesTotalHeight - AppDesign.STRIPE_HEIGTH;
				}
				_allStripes.y = -yDisplace;
				if (_currentStripeIndex != (yDisplace / AppDesign.STRIPE_HEIGTH))
				{
					_currentStripeIndex = yDisplace / AppDesign.STRIPE_HEIGTH;
					displayVisibleStripes();
					decadeYears.setSelectedCurrentDecade(_seriesStripes[_currentStripeIndex].serieDecade);
				}
			}
		}
	}
}