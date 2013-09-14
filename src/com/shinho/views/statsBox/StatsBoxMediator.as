package com.shinho.views.statsBox
{
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.CountryStampsModel;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.LanguageModel;
	import com.shinho.models.StampDatabase;
	import com.shinho.util.SpriteUtils;

	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;


	public class StatsBoxMediator extends Mediator
	{
		[Inject]
		public var countryStamps:CountryStampsModel;
		[Inject]
		public var lang:LanguageModel;
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var stamps:StampDatabase;
		[Inject]
		public var view:StatsBox;


		public function StatsBoxMediator()
		{
		}


		override public function onRegister():void
		{
			view.page = page;
			view.changeLabels(lang.labels);
			addViewListener(StatsBoxEvents.STATS_BOARD_INIT_CALCULATION, showResults);
		}


		private function closeBoard(e:MouseEvent):void
		{
			SpriteUtils.removeAllChild(view);
			contextView.removeChild(view);
		}


		private function showResults(e:StatsBoxEvents):void
		{
			eventMap.mapListener(view.board.btClose, MouseEvent.CLICK, closeBoard);
			view.showStats(countryStamps.stampsOwned, countryStamps.getBiggerStampNumber(), countryStamps.totalValue,
			               countryStamps.totalCost);
		}
	}
}