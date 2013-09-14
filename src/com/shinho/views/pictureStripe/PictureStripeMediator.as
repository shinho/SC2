package com.shinho.views.pictureStripe {
	import com.shinho.events.ApplicationEvent;
	import com.shinho.models.CountryStampsModel;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.StampDatabase;
	import com.shinho.models.dto.StampDTO;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;


	public class PictureStripeMediator extends Mediator {
		//---- inject VIEW dependancy
		[Inject]
		public var view:SeriesStripeView;
		//---- inject MODEL dependancy
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var stamps:StampDatabase;
		[Inject]
		public var countryStamps:CountryStampsModel;


		public function PictureStripeMediator(){
		/*Avoid doing work in your constructors!
		 Mediators are only ready to be used when onRegister gets called*/
		}



		override public function onRegister():void {
			// redispatch view events to the system
			eventMap.mapListener(view, PictureStripeEvents.STAMPS_STRIPE_READY, dispatch, PictureStripeEvents);
			// map listeners
			addViewListener(PictureStripeEvents.STAMPS_STRIPE_READY, saveCurrentStripe);
			view.showSelectedStampSignal.add(stampClicked);
			eventMap.mapListener(view.stage, Event.RESIZE, onStageResize);
			// passes the flexlayout data
			view.page = page;
		}



		private function stampClicked(stamp:StampDTO):void {
			countryStamps.currentStamp = stamp;
			stamps.stampInfoChanged = false;
			view.currentStampNumber = stamp.number;
			stamps.currentStripe = view.setCurrentStripe();
			stamps.stampsInCurrentSerie = view.stampsInSerie;
			stamps.currentSerieName = view.serieName;
			eventDispatcher.dispatchEvent(new PictureStripeEvents(PictureStripeEvents.SHOW_STAMP, view));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOCK_WHEEL));
		}


		private function saveCurrentStripe(e:PictureStripeEvents):void {
			if (view.pictureStripeReference != null) {
				stamps.currentStripe = view.setCurrentStripe();
			}
		}

		
		
		private function onStageResize(e:Event):void {
			view.checkWidth();
		}


	}
}