package com.shinho.views
{

	import com.shinho.controllers.StampsController;
	import com.shinho.events.ApplicationEvent;
	import com.shinho.events.MenuEvents;
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.FlexLayout;
	import com.shinho.util.SpriteUtils;
	import com.shinho.views.decades.DecadesEvents;
	import com.shinho.views.export.ExportXML;
	import com.shinho.views.importer.XMLimportView;
	import com.shinho.views.statsBox.StatsBoxEvents;
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
//		[Inject]
//		public var stamps:StampDatabase;
//		[Inject]
//		public var countries:CountriesModel;
		[Inject]
		public var view:ApplicationMainView;
		private static var topMargin:int = 110;
		private static var baseMargin:int = 40;
		private static var marginLeft:int = 25;
		private static var marginRigth:int = 25;
		private static var minDisplayWidth:int = 900;
		private static var minDisplayHeight:int = 600;
		private static var barHeight:int = 50;
		private var exportBoard:ExportXML;
		/*		private var statsBoard:StatsBox;*/
		private var importBoard:XMLimportView;
		private var useWheel:Boolean = false;


		public function ApplicationMediator()
		{
			/* Avoid doing work in your constructors!
			 Mediators are only ready to be used when onRegister gets called*/
			super();
		}


		override public function onRegister():void
		{
			super.onRegister();

			eventMap.mapListener(view.stage, Event.RESIZE, onStageResize);
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_WHEEL, wheelMoved);

			controller.stampDataReadySignal.add(displayStamps);
			addContextListener(StampsDatabaseEvents.STAMPSDATABASE_EMPTY, emptyDatabase);

			addContextListener(StampsDatabaseEvents.UPDATE_STRIPE, checkUpdateMethod);
			addContextListener(StampsDatabaseEvents.STAMP_ADDED, refreshAddedStamp);
			addContextListener(StampsDatabaseEvents.STAMP_DELETED, refreshDeletedStamp);

			addContextListener(TypesMenuEvents.TYPE_SELECTED, typeSelected);

			addContextListener(DecadesEvents.DECADE_SELECTED, decadeSelected);

			addContextListener(MenuEvents.EXPORT_XML, exportXML);

			page.defineStage(topMargin, baseMargin, marginLeft, marginRigth, minDisplayWidth, minDisplayHeight);
			page.add(view.bar, page.LEFT, 0, page.TOP, topMargin - barHeight, page.WIDE, 0, page.NONE, 0);
			onStageResize(null);
			view.page = page;

			addContextListener(ApplicationEvent.EXPORT_XML_CLOSE, closeExportXML);
			addContextListener(ApplicationEvent.LOCK_WHEEL, lockWheel);
			addContextListener(ApplicationEvent.UNLOCK_WHEEL, unLockWheel);
		}


		private function displayStamps():void
		{
			view.clearDisplay();
			view.setStampSeries(controller.getSeries());
			view.currentStamp = controller.getCurrentStamp();
			view.displayCountryName(controller.currentCountryName);
			view.prepareSeriesStripes(controller.getStamps());
			useWheel = true;
		}


		private function refreshNewCountry():void
		{
//			view.clearDisplay();
//			stamps.changeCountry();
		}


		private function refreshNewType():void
		{
//			view.clearDisplay();
//			stamps.changeType(stamps.currentType);
//			///view.moveStripeTop(stamps.currentSerieName);
		}


		private function updateSerie():void
		{
//			var data:Array = stamps.getStampsOfSerie(stamps.currentSerieName, stamps.currentYear);
//			stamps.currentStripe.refreshStripe(data, stamps.currentStampID, false);
//			view.serieChanged(stamps.stampArray, stamps.originalSerieName, stamps.originalYear, stamps.currentSerieName, stamps.currentYear);
//			view.moveStripeTop(stamps.currentSerieName, stamps.currentYear);
		}


		private function updateStripe():void
		{
//			var data:Array = stamps.getStampsOfSerie(stamps.currentSerieName, stamps.currentYear);
//			stamps.currentStripe.refreshStripe(data, stamps.currentStampID);
//			view.moveStripeTop(stamps.currentSerieName, stamps.currentYear);
		}


		private function onStageResize(e:Event):void
		{
			page.setActualStage(view.stage.stageWidth, view.stage.stageHeight);
			page.forceResize();
			view.onResize();
		}


		private function wheelMoved(e:MouseEvent):void
		{
			if (useWheel)
			{
				view.wheelMovement(e.delta);
			}
		}


		/*		private function typeSelected(e:MouseEvent):void
		 {
		 if (view.stampsDisplayed)
		 {
		 view.clearDisplay();
		 var newType:int = e.target.parent.parent.id;
		 stamps.changeType(newType);
		 }
		 }*/

		private function lockWheel(e:ApplicationEvent):void
		{
			useWheel = false;
		}


		private function unLockWheel(e:ApplicationEvent):void
		{
			useWheel = true;
		}


		private function emptyDatabase(e:StampsDatabaseEvents):void
		{
			view.clearDisplay();
			view.displayCountryName("Database is empty... add first stamp!");
		}


		private function addStamp(e:MouseEvent):void
		{
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.ADD_STAMP));
		}


		private function typeSelected(e:TypesMenuEvents):void
		{
			if (view.stampsDisplayed)
			{
				view.clearDisplay();
			}
		}


		private function decadeSelected(e:DecadesEvents):void
		{
			view.moveToDecade(e.body);
		}


		private function refreshAddedStamp(e:StampsDatabaseEvents):void
		{
			updateSerie();
		}


		private function refreshDeletedStamp(e:StampsDatabaseEvents):void
		{
//			view.serieChanged(stamps.stampArray, stamps.originalSerieName, stamps.originalYear, stamps.currentSerieName, stamps.currentYear);
//			view.moveStripeTop(stamps.currentSerieName, stamps.currentYear);
		}


		private function checkUpdateMethod(e:StampsDatabaseEvents):void
		{
//			switch (stamps.StampInfoUpdateState)
//			{
//				case StampDatabase.DECADE_UPDATED:
//					trace("--> updating decade");
//					updateSerie();
//					///refreshAddedStamp();
//					break;
//				case StampDatabase.SERIE_UPDATED:
//					trace("--> updating serie");
//					updateSerie();
//					break;
//				case StampDatabase.STRIPE_UPDATED:
//					trace("--> updating serie");
//					updateSerie();
//					break;
//				case StampDatabase.NONE_UPDATED:
//					trace("--> updating serie (nothing changed)");
//					///updateStripe();
//					updateSerie();
//					break;
//				case StampDatabase.NUMBER_UPDATED:
//					trace("--> updating serie (number changed)");
//					updateStripe();
//					///refreshAddedStamp();
//					break;
//				case StampDatabase.COUNTRY_UPDATED:
//					trace("--> updating country");
//					refreshNewCountry();
//					break;
//				case StampDatabase.TYPE_UPDATED:
//					trace("--> updating type");
//					refreshNewType();
//					break;
//			}
		}


		// ------------------------------------------------------------------------  STATS BOX

		private function showStats(e:MouseEvent):void
		{
			if (view.stampsDisplayed)
			{
				eventDispatcher.dispatchEvent(new StatsBoxEvents(StatsBoxEvents.LOAD_BOARD));
			}
		}


		private function exportXML(e:MenuEvents):void
		{
			if (view.stampsDisplayed)
			{
				exportBoard = new ExportXML();
				contextView.addChild(exportBoard);
			}
		}


		private function closeExportXML(e:ApplicationEvent):void
		{
			SpriteUtils.removeAllChild(exportBoard);
			contextView.removeChild(exportBoard);
			exportBoard = null;
		}
	}
}