package com.shinho.views.pictureStripe
{

      import com.shinho.controllers.StampsController;
      import com.shinho.events.ApplicationEvent;
      import com.shinho.models.StampsModel;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.StampDatabase;
      import com.shinho.models.dto.StampDTO;

      import flash.events.Event;

      import org.robotlegs.mvcs.Mediator;

      public class SeriesStripeMediator extends Mediator
      {
            [Inject]
            public var view:SeriesStripeView;
            [Inject]
            public var page:FlexLayout;
            [Inject]
            public var db:StampDatabase;
            [Inject]
            public var countryStamps:StampsModel;
            [Inject]
            public var controller:StampsController;


            public function SeriesStripeMediator()
            {
            }


            override public function onRegister():void
            {
                  view.stripeIsReadySignal.add(saveCurrentStripe);
                  view.showSelectedStampSignal.add(stampClicked);
                  eventMap.mapListener(view.stage, Event.RESIZE, onStageResize);
                  view.page = page;
            }


            private function stampClicked(stamp:StampDTO):void
            {
                  countryStamps.currentStamp = stamp;
                  db.stampInfoChanged = false;
                  view.currentStampNumber = stamp.number;
                  controller.currentSeriesStripe = view.setCurrentStripe();
                  db.stampsInCurrentSerie = view.stampsInSerie;
                  db.currentSerieName = view.serieName;
                  eventDispatcher.dispatchEvent(new PictureStripeEvents(PictureStripeEvents.SHOW_STAMP, view));
                  eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOCK_WHEEL));
            }


            private function saveCurrentStripe():void
            {
                  if (view.pictureStripeReference != null)
                  {
                        eventDispatcher.dispatchEvent(new PictureStripeEvents(PictureStripeEvents.STAMPS_STRIPE_READY));
                  }
            }


            private function onStageResize(e:Event):void
            {
                  view.checkWidth();
            }

      }
}