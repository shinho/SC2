package com.shinho.views
{

      import com.shinho.controllers.StampsController;
      import com.shinho.events.ApplicationEvent;
      import com.shinho.events.MenuEvents;
      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.StampsModel;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.util.SpriteUtils;
      import com.shinho.views.export.ExportXML;
      import com.shinho.views.types.TypesMenuEvents;

      import flash.events.Event;
      import flash.events.MouseEvent;

      import org.robotlegs.mvcs.Mediator;

      public final class ApplicationMediator extends Mediator
      {

            [Inject]
            public var controller:StampsController;
            [Inject]
            public var page:FlexLayout;
            [Inject]
            public var stamps:StampsModel;
            [Inject]
            public var view:ApplicationMainView;

            // properties
            private static var topMargin:int = 110;
            private static var baseMargin:int = 40;
            private static var marginLeft:int = 25;
            private static var marginRigth:int = 25;
            private static var minDisplayWidth:int = 900;
            private static var minDisplayHeight:int = 600;
            private static var barHeight:int = 50;
            private var exportBoard:ExportXML;
            private var useWheel:Boolean = false;


            public function ApplicationMediator()
            {
                  super();
            }


            override public function onRegister():void
            {
                  super.onRegister();

                  eventMap.mapListener( view.stage, Event.RESIZE, onStageResize );
                  eventMap.mapListener( view.stage, MouseEvent.MOUSE_WHEEL, wheelMoved );

                  addContextListener( StampsDatabaseEvents.STAMPSDATABASE_EMPTY, emptyDatabase );
                  addContextListener( MenuEvents.EXPORT_XML, exportXML );
                  addContextListener( TypesMenuEvents.TYPE_SELECTED, typeSelected );
                  addContextListener( ApplicationEvent.EXPORT_XML_CLOSE, closeExportXML );
                  addContextListener( ApplicationEvent.LOCK_WHEEL, lockWheel );
                  addContextListener( ApplicationEvent.UNLOCK_WHEEL, unLockWheel );

                  controller.stampDataReadySignal.add( displayStamps );
                  controller.stampAddedSignal.add( updateSerie );
                  controller.stampDeletedSignal.add( updateSerie );
                  controller.stampUpdatedSignal.add( updateSerie );

                  page.defineStage( topMargin, baseMargin, marginLeft, marginRigth, minDisplayWidth, minDisplayHeight );
                  page.add( view.bar, page.LEFT, 0, page.TOP, topMargin - barHeight, page.WIDE, 0, page.NONE, 0 );
                  onStageResize( null );
                  view.page = page;
            }


            private function displayStamps():void
            {
                  view.clearDisplay();
                  view.setStampSeries( controller.getSeries() );
                  view.currentStamp = controller.getCurrentStamp();
                  view.displayCountryName( controller.currentCountryName );
                  view.prepareSeriesStripes( controller.getStamps() );
                  useWheel = true;
            }


            private function updateSerie( stampDetails:StampDTO ):void
            {
                  trace( "Application Mediator : update serie" );
                  view.seriesChanged( stamps.stampSeries, controller.currentSeriesStripe );
            }


            private function onStageResize( e:Event ):void
            {
                  page.setActualStage( view.stage.stageWidth, view.stage.stageHeight );
                  page.forceResize();
                  view.onResize();
            }


            private function wheelMoved( e:MouseEvent ):void
            {
                  if ( useWheel )
                  {
                        view.wheelMovement( e.delta );
                  }
            }


            private function lockWheel( e:ApplicationEvent ):void
            {
                  useWheel = false;
            }


            private function unLockWheel( e:ApplicationEvent ):void
            {
                  useWheel = true;
            }


            private function emptyDatabase( e:StampsDatabaseEvents ):void
            {
                  view.clearDisplay();
                  view.displayCountryName( "Database is empty... add first stamp!" );
            }


            private function typeSelected( e:TypesMenuEvents ):void
            {
                  if ( view.stampsDisplayed )
                  {
                        view.clearDisplay();
                  }
            }


            private function exportXML( e:MenuEvents ):void
            {
                  if ( view.stampsDisplayed )
                  {
                        exportBoard = new ExportXML();
                        contextView.addChild( exportBoard );
                  }
            }


            private function closeExportXML( e:ApplicationEvent ):void
            {
                  SpriteUtils.removeAllChild( exportBoard );
                  contextView.removeChild( exportBoard );
                  exportBoard = null;
            }
      }
}