package com.shinho.views.decades
{

	import com.shinho.controllers.StampsController;
	import com.shinho.models.DecadeYearsModel;
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
		public var decades:DecadeYearsModel;


		public function DecadesMediator()
		{
		}


		override public function onRegister():void
		{
			trace("decades now mediating");
			view.page = page;
			view.init();
			controller.stampDataReadySignal.add(display);
//			addContextListener(StampsDatabaseEvents.STAMP_ADDED, refreshDecades);
//			addContextListener(StampsDatabaseEvents.STAMP_DELETED, refreshDecades);
		}


		private function display():void
		{
			view.displayDecades(controller.getDecades(), controller.getCurrentDecade());
			view.decadeSelectedSignal.add(decadeSelected) ;

		}


		private function decadeSelected(newDecade:String):void
		{
			view.setSelectedCurrentDecade(newDecade);
			decades.currentDecade = newDecade;

		}
	}
}