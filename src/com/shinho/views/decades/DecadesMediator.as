package com.shinho.views.decades
{

      import com.shinho.controllers.StampsController;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.StampDatabase;

      import org.robotlegs.mvcs.Mediator;

      public class DecadesMediator extends Mediator
      {

            [Inject]
            public var controller:StampsController;
            [Inject]
            public var page:FlexLayout;
            [Inject]
            public var stamps:StampDatabase;
            [Inject]
            public var view:DecadesView;
            [Inject]
            public var db:StampDatabase;


            public function DecadesMediator()
            {
            }


            override public function onRegister():void
            {
                  trace( "decades now mediating" );
                  view.page = page;
                  view.init();
                  controller.stampDataReadySignal.add( display );
            }


            private function display():void
            {
                  view.displayDecades( controller.getDecades(), controller.getCurrentDecade() );
                  view.decadeSelectedSignal.add( decadeSelected );

            }


            private function decadeSelected( newDecade:String ):void
            {
                  view.setSelectedCurrentDecade( newDecade );
                  controller.setCurrentDecade( newDecade );

            }
      }
}