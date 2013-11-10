package com.shinho.views.decades
{

      import com.shinho.controllers.StampsController;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.StampDatabase;
      import com.shinho.models.dto.StampDTO;

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


            public function DecadesMediator()
            {
            }


            override public function onRegister():void
            {
                  trace( "decades now mediating" );
                  view.page = page;
                  view.init();
                  controller.stampDataReadySignal.add( onStampsReady );
                  controller.stampAddedSignal.add( display );
                  controller.stampDeletedSignal.add( display );
                  controller.stampUpdatedSignal.add( display );
            }


            private function onStampsReady():void
            {
                  display( null );
            }


            private function display( stampDetails:StampDTO ):void
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