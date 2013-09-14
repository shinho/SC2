package com.shinho.views.pictureStripe
{

	import com.greensock.*;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.util.AppDesign;
	import com.shinho.util.Color;
	import com.shinho.util.SpriteUtils;
	import com.shinho.views.pictureStripe.thumb.Thumb;

	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	import org.osflash.signals.Signal;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class SeriesStripeView extends MovieClip
	{

		public var currentStampNumber:String = "-1";
		public var page:FlexLayout;
		public var pictureStripeReference:SeriesStripeView;
		public var showSelectedStampSignal:Signal = new Signal(StampDTO);
		public var thumbsHolder:Sprite;
		private var _currentThumb:int = 0;
		private var _holderMask:Sprite;
		private var _isDisplayed:Boolean = false;
		private var _numberOfStamps:int;
		private var _numberSerieItems:int = 0;
		private var _serieDecade:String;
		private var _serieIndex:uint;
		private var _serieName:String;
		private var _serieYear:String;
		private var _stamps:Vector.<StampDTO>;
		private var _stripeAsset:PictureStripeSWC = new PictureStripeSWC();
		private var _thumbs:Array = new Array();
		private var _thumbsDisplayed:Boolean = false;


		public function SeriesStripeView(serieName:String, year:String, index:uint):void
		{
			pictureStripeReference = null;
			_serieIndex = index;
			_serieName = serieName;
			_serieYear = year;
			_serieDecade = year.substr(0, 3) + "0";
			addEventListener(MouseEvent.MOUSE_OVER, moveStripeToTop);
		}


		// ----------------------------------------------------------------------------
		// Public Methods
		// ----------------------------------------------------------------------------

		public function checkWidth():void
		{
			if (isDisplayed)
			{
				_holderMask.width = page.wide - AppDesign.X_START_DISPLAY_STAMPS - AppDesign.SLIDER_WIDTH - AppDesign.BUTTON_YEAR_DISPLACE - AppDesign.SLIDER_GAP;
				if (thumbsHolder.width > _holderMask.width)
				{
					_stripeAsset.slider.x = 7;
					TweenMax.to(_stripeAsset.slider, 0.3, {alpha: 1});
					TweenMax.to(_stripeAsset.draggerBackground, 0.5, {alpha: 1});
					_stripeAsset.slider.addEventListener(Event.ENTER_FRAME, scrollStripes);
				}
				else
				{
					_stripeAsset.slider.x = 7;
					TweenMax.to(_stripeAsset.slider, 0.5, {alpha: 0});
					TweenMax.to(_stripeAsset.draggerBackground, 0.5, {alpha: 0});
					_stripeAsset.slider.removeEventListener(Event.ENTER_FRAME, scrollStripes);
					scrollStripes(null);
				}
			}
		}


		public function destroy():void
		{
			destroyThumbs();
			_stripeAsset.slider.removeEventListener(MouseEvent.MOUSE_DOWN, moveSlider);
			_stripeAsset.slider.removeEventListener(MouseEvent.MOUSE_UP, stopSlider);
			removeEventListener(MouseEvent.MOUSE_OVER, moveStripeToTop);
			_stripeAsset = null;
			pictureStripeReference = null;
			_thumbs = null;
			thumbsHolder = null;
			_holderMask = null;
			_stamps = null;
		}


		public function displayStripe(serieStamps:Vector.<StampDTO> = null):void
		{
//			if (serieStamps != null)
//			{
//				_stamps = serieStamps;
//			}
			_numberSerieItems = serieStamps.length;
			var isDisplayed:Boolean = false;
			var stamp:StampDTO;
			for (var i:int = 0; i < _numberSerieItems; i++)
			{
				stamp = serieStamps[i] as StampDTO;
				var thumb:Thumb = new Thumb(stamp, stamp.getPath());
				thumb.alpha = 1;
				_thumbs.push(thumb);
				thumbsHolder.addChild(thumb);
				SpriteUtils.setPosition(thumb, i * 60 + AppDesign.STAMP_PADDING + AppDesign.X_START_DISPLAY_STAMPS, 5);
				thumb.addEventListener(MouseEvent.MOUSE_OVER, onThumbOver);
				thumb.thumbLoadedSignal.add(add2List);
				if (stamp.number == currentStampNumber)
				{
					isDisplayed = true;
					pictureStripeReference = this;
				}
			}
		}


		public function refreshStripe(data:Vector.<StampDTO>, currentStampNum:String, goDisplay:Boolean = true):void
		{
			currentStampNumber = currentStampNum;
			destroyThumbs();
			_thumbs = [];
			_currentThumb = 0;
			_serieName = data[0].serie;
			_serieYear = data[0].year;
			_stripeAsset.legenda.text = _serieName;
			_stripeAsset.ano.text = serieYear;
			if (goDisplay)
			{
				displayStripe(data);
			}
			_numberOfStamps = data.length;
		}


		public function setCurrentStripe():MovieClip
		{
			pictureStripeReference = this;
			return pictureStripeReference;
		}


		public function setData(serieStamps:Vector.<StampDTO>):void
		{
			_stamps = serieStamps;
			_numberOfStamps = serieStamps.length;

			/// add picture stripe background
			addChild(_stripeAsset);
			_stripeAsset.legenda.text = _serieName;
			_stripeAsset.ano.text = serieYear;

			thumbsHolder = new Sprite();
			addChild(thumbsHolder);

			_holderMask = SpriteUtils.drawQuad(0, 0,
			                                   page.wide - AppDesign.X_START_DISPLAY_STAMPS - AppDesign.SLIDER_WIDTH - AppDesign.BUTTON_YEAR_DISPLACE - AppDesign.SLIDER_GAP,
			                                   AppDesign.STRIPE_HEIGTH * 6);
			addChild(thumbsHolder);
			addChild(_holderMask);
			thumbsHolder.mask = _holderMask;
			_holderMask.x = AppDesign.X_START_DISPLAY_STAMPS;
			_stripeAsset.middlepart.width = page.wide - AppDesign.BUTTON_YEAR_DISPLACE - AppDesign.SLIDER_WIDTH - 180;
			page.add(_stripeAsset.middlepart, page.NONE, 0, page.NONE, 0, page.WIDE,
			         -AppDesign.BUTTON_YEAR_DISPLACE - AppDesign.SLIDER_WIDTH - 180, page.NONE, 0);
			_stripeAsset.rightpart.x = page.wide - AppDesign.SLIDER_WIDTH - 70;
			page.add(_stripeAsset.rightpart, page.WIDE, -AppDesign.SLIDER_WIDTH - 70, page.NONE, 0, page.NONE, 0, page.NONE,
			         0);

			/// horizontal slider control
			_stripeAsset.slider.alpha = 0;
			_stripeAsset.draggerBackground.alpha = 0;
			_stripeAsset.slider.buttonMode = true;
			_stripeAsset.slider.addEventListener(MouseEvent.MOUSE_DOWN, moveSlider, false, 0, true);
			_stripeAsset.slider.addEventListener(MouseEvent.MOUSE_UP, stopSlider, false, 0, true);

			displayStripe(serieStamps);
			_isDisplayed = true;
		}


		// ----------------------------------------------------------------------------
		// Private Methods
		// ----------------------------------------------------------------------------

		private static function moveToTop(clip:DisplayObject):void
		{
			clip.parent.setChildIndex(clip, clip.parent.numChildren - 1);
		}


		private function add2List(thumb:Thumb):void
		{
			thumb.addEventListener(MouseEvent.CLICK, imgSelected);
			_currentThumb++;
			if (_currentThumb == _numberSerieItems)
			{
				displayThumbs(_thumbs);
			}
		}


		private function destroyThumbs():void
		{
			if (thumbsHolder != null)
			{
				SpriteUtils.removeAllChild(thumbsHolder);
				for (var i:int = 0; i < _thumbs.length; i++)
				{
					var thumb:Thumb = _thumbs[i];
					thumb.removeEventListener(MouseEvent.CLICK, imgSelected);
					thumb.destroy();
					thumb = null;
				}
			}
		}


		private function displayThumbs(thumbsList:Array):void
		{
			var xDisplace:int = AppDesign.X_START_DISPLAY_STAMPS;
			for (var i:int = 0; i < thumbsList.length; i++)
			{
				var thumb:Thumb = thumbsList[i];
				var ratio:Number = thumb.width / thumb.height;
				var newWidth:Number = AppDesign.THUMB_MAX_HEIGHT * ratio;
				thumb.width = newWidth;
				thumb.height = AppDesign.THUMB_MAX_HEIGHT;
				var padding:int = newWidth + AppDesign.STAMP_PADDING;
				SpriteUtils.setPosition(thumb, xDisplace, 5);
				thumb.alpha = 1;
				xDisplace = xDisplace + padding;
			}
			checkWidth();
			_thumbsDisplayed = true;
			dispatchEvent(new PictureStripeEvents(PictureStripeEvents.STAMPS_STRIPE_READY));
		}


		private function imgSelected(e:Event):void
		{
			var thumb:Thumb = e.currentTarget as Thumb;
			showSelectedStampSignal.dispatch(thumb.stamp);
		}


		private function moveSlider(e:Event):void
		{
			var margin:Rectangle = new Rectangle(7, 7, 33, 0);
			_stripeAsset.slider.startDrag(true, margin);
			addEventListener(MouseEvent.MOUSE_UP, stopSlider, false, 0, true);
			e.currentTarget.filters = [new GlowFilter(Color.GLOW_BLUE, .75, 5, 5, 2, 3, false, false)];
		}


		private function stopSlider(e:Event):void
		{
			_stripeAsset.slider.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_UP, stopSlider);
			_stripeAsset.slider.filters = [];
		}


		private function scrollStripes(e:Event):void
		{
			if (thumbsHolder)
			{
				var step:Number = (thumbsHolder.width - _holderMask.width) / 33;
				thumbsHolder.x = -(step * (_stripeAsset.slider.x - 7));
			}
		}


		private function moveStripeToTop(e:MouseEvent):void
		{
			moveToTop(this);
		}


		private function onThumbOver(event:MouseEvent):void
		{
			moveToTop(event.currentTarget as DisplayObject);
		}


		public function get stampsInSerie():int
		{
			return _numberSerieItems;
		}


		public function get serieName():String
		{
			return _serieName;
		}


		public function get serieIndex():uint
		{
			return _serieIndex;
		}


		public function set serieIndex(value:uint):void
		{
			_serieIndex = value;
		}


		public function get serieYear():String
		{
			return _serieYear;
		}


		public function get serieDecade():String
		{
			return _serieDecade;
		}


		public function get isDisplayed():Boolean
		{
			return _isDisplayed;
		}
	}
}