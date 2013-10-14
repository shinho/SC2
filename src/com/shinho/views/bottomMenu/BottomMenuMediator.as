package com.shinho.views.bottomMenu
{

      import com.shinho.events.ApplicationEvent;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.StampDatabase;
      import com.shinho.views.countrySelector.CountrySelectorEvents;
      import com.shinho.views.statsBox.StatsBoxEvents;

      import org.robotlegs.mvcs.Mediator;

      import com.shinho.models.LanguageModel;

      public final class BottomMenuMediator extends Mediator
      {
            [Inject]
            public var view:BottomMenu;
            [Inject]
            public var page:FlexLayout;
            [Inject]
            public var stamps:StampDatabase;
            [Inject]
            public var lang:LanguageModel;


            public function BottomMenuMediator()
            {
                  super();
            }


            override public function onRegister():void
            {
                  super.onRegister();
                  view.page = page;
                  view.changeLang( lang.labels );
                  view.changeCountrySignal.add( showCountrySelector );
                  view.addNewStampSignal.add( addStamp );
                  view.showStatsSignal.add( showStats );
            }


            private function addStamp():void
            {
                  eventDispatcher.dispatchEvent( new ApplicationEvent( ApplicationEvent.ADD_STAMP ) );
            }


            private function showCountrySelector():void
            {
                  if ( view.stampsDisplayed )
                  {
                        eventDispatcher.dispatchEvent( new CountrySelectorEvents( CountrySelectorEvents.LOAD_BOARD ) );
                  }
            }


            private function showStats():void
            {
                  if ( view.stampsDisplayed )
                  {
                        eventDispatcher.dispatchEvent( new StatsBoxEvents( StatsBoxEvents.LOAD_BOARD ) );
                  }
            }
      }
}