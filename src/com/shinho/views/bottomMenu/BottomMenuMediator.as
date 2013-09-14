package com.shinho.views.bottomMenu {
	import com.shinho.events.ApplicationEvent;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.StampDatabase;
	import com.shinho.views.bottomMenu.BottomMenu;
	import com.shinho.views.bottomMenu.BottomMenuEvents;
	import com.shinho.views.countrySelector.CountrySelectorEvents;
	import com.shinho.views.statsBox.StatsBoxEvents;
	import org.robotlegs.mvcs.Mediator;
	import com.shinho.models.LanguageModel;
	
	
	
	public final class BottomMenuMediator extends Mediator {
		/// -------------------------------------------------------------------   inject VIEW dependancy
		[Inject]
		public var view:BottomMenu;		
		/// -------------------------------------------------------------------   inject MODEL dependancy
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var stamps:StampDatabase;
		[Inject]
		public var lang:LanguageModel;

		
		
		
		// ----------------------------------------------------------------------- Constructor
		public function BottomMenuMediator() {
			super();
		}
		
		
		
		// ----------------------------------------------------------------------- On Register
		override public function onRegister():void {
			super.onRegister();
			view.page = page;
			view.changeLang(lang.labels);
			/// -------------------------------------------------------------------   listen for buttons
			addViewListener(BottomMenuEvents.ADD_FIRST_STAMP, addStamp);
			addViewListener(BottomMenuEvents.CHANGE_COUNTRY, showCountrySelector);
			addViewListener(BottomMenuEvents.SHOW_STATS, showStats);
		}
		
		
		
		// ----------------------------------------------------------------------- Add Stamp
		private function addStamp(e:BottomMenuEvents):void {
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.ADD_STAMP));
		}
		
		
		
		// ----------------------------------------------------------------------- On Stage Resize
/*		private function onStageResize(e:Event):void {
			page.setActualStage(view.stage.stageWidth, view.stage.stageHeight);
			page.forceResize();
			view.onResize();
		}*/
		
		
		
		// ------------------------------------------------------------------------  COUNTRY SELECTOR
		private function showCountrySelector(e:BottomMenuEvents):void {
			if (view.stampsDisplayed) {
				eventDispatcher.dispatchEvent(new CountrySelectorEvents(CountrySelectorEvents.LOAD_BOARD));
			}
		}
		
		
		
		// ------------------------------------------------------------------------  STATS BOX
		private function showStats(e:BottomMenuEvents):void {
			if (view.stampsDisplayed) {
				eventDispatcher.dispatchEvent(new StatsBoxEvents(StatsBoxEvents.LOAD_BOARD));
			}
		}
	}
}