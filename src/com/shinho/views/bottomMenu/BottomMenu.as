package com.shinho.views.bottomMenu
{

      import com.shinho.models.FlexLayout;

      import flash.display.MovieClip;

      import flash.display.Sprite;
      import flash.events.Event;
      import flash.events.MouseEvent;

      import org.osflash.signals.Signal;

      /**
       * ...
       * @author Nelson Alexandre
       */
      public class BottomMenu extends MovieClip
      {

            // buttons
            public var btChangeCountry:ButtonMenuType = new ButtonMenuType(ButtonMenuType.CHANGE_COUNTRY);
            public var btStats:ButtonMenuType = new ButtonMenuType(ButtonMenuType.STATISTICS);
            public var btAddStamp:ButtonMenuType = new ButtonMenuType(ButtonMenuType.ADD_FIRST);
            public var page:FlexLayout;
            public var stampsDisplayed:Boolean;
            public var showStatsSignal:Signal = new Signal();
            public var addNewStampSignal:Signal = new Signal();
            public var changeCountrySignal:Signal = new Signal();


            public function BottomMenu()
            {
                  trace( "bottom menu initialised" );
                  this.addEventListener( Event.ADDED_TO_STAGE, init );
            }


            private function init( e:Event ):void
            {
                  var bottomMenuHolder:Sprite = new Sprite();
                  this.removeEventListener( Event.ADDED_TO_STAGE, init );
                  addChild( bottomMenuHolder );
                  page.add( bottomMenuHolder, page.NONE, 0, page.TALL, -40, page.NONE, 0, page.NONE, 0 );
                  var backArea:MovieClip = new MenuBarSWC();
                  bottomMenuHolder.addChild( backArea );
                  page.add( backArea, page.NONE, 0, page.NONE, 0, page.WIDE, 0, page.NONE, 40 );
                  page.forceResize();
                  bottomMenuHolder.addChild( btAddStamp );
                  btAddStamp.x = 52;
                  btAddStamp.y = 3;
                  bottomMenuHolder.addChild( btChangeCountry );
                  btChangeCountry.x = 162;
                  btChangeCountry.y = 3;
                  bottomMenuHolder.addChild( btStats );
                  btStats.x = 276;
                  btStats.y = 3;
                  btStats.addEventListener( MouseEvent.CLICK, btStatsClicked );
                  btAddStamp.addEventListener( MouseEvent.CLICK, btAddClicked );
                  btChangeCountry.addEventListener( MouseEvent.CLICK, btChangeCountryClicked );
            }


            //  -----------------------------------------------------------------------   btStatsClicked
            private function btStatsClicked( e:MouseEvent ):void
            {
                  showStatsSignal.dispatch();
            }


            //  -----------------------------------------------------------------------   btStatsClicked
            private function btAddClicked( e:MouseEvent ):void
            {
                  addNewStampSignal.dispatch();
            }


            //  -----------------------------------------------------------------------   btStatsClicked
            private function btChangeCountryClicked( e:MouseEvent ):void
            {
                  changeCountrySignal.dispatch();
            }


            public function changeLang( item:XMLList ):void
            {
                  btAddStamp.changeLabel( item[0].@label );
                  btChangeCountry.changeLabel( item[1].@label );
                  btStats.changeLabel( item[2].@label );
            }
      }
}