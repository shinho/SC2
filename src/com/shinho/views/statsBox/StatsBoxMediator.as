package com.shinho.views.statsBox
{

      import com.shinho.controllers.StampsController;
      import com.shinho.models.StampsModel;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.LanguageModel;
      import com.shinho.models.StampDatabase;
      import com.shinho.util.SpriteUtils;

      import flash.events.MouseEvent;

      import org.robotlegs.mvcs.Mediator;

      public class StatsBoxMediator extends Mediator
      {
            [Inject]
            public var stampsModel:StampsModel;
            [Inject]
            public var lang:LanguageModel;
            [Inject]
            public var page:FlexLayout;
            [Inject]
            public var view:StatsBox;
            [Inject]
            public var controller:StampsController;


            public function StatsBoxMediator()
            {
            }


            override public function onRegister():void
            {
                  view.page = page;
                  view.changeLabels( lang.labels );
                  view.initCalculationSignal.add( showResults );
            }


            private function closeBoard( e:MouseEvent ):void
            {
                  SpriteUtils.removeAllChild( view );
                  contextView.removeChild( view );
            }


            private function showResults():void
            {
                  eventMap.mapListener( view.board.btClose, MouseEvent.CLICK, closeBoard );
                  controller.calculateStatistics();
                  view.showStats( stampsModel.stampsOwned, stampsModel.getBiggerStampNumber(), stampsModel.totalValue,
                          stampsModel.totalCost );
            }
      }
}