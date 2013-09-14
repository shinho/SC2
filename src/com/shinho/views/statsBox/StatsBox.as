package com.shinho.views.statsBox
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import com.shinho.enums.LangEnum;
	import com.shinho.models.FlexLayout;
	import com.shinho.views.components.GlowButton;
	import com.shinho.views.statsBox.StatsBoxEvents;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.shinho.util.Formatter;
	
	
	
	/**
	 * ...
	 * @author ...
	 */ //  ------------------------------------------------------------------------------------   CLASS
	public final class StatsBox extends Sprite
	{
		public var board:StatsBox_SWC = new StatsBox_SWC();
		public var page:FlexLayout;
		

		public function StatsBox()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		

		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			var closeButton:GlowButton = new GlowButton(board.btClose);

			/// cretes background and animates
			var backLeft:MovieClip = new QuadSWC();
			addChild(backLeft);
			page.add(backLeft, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60);
			TweenMax.to(backLeft, 0, {tint: 0x111111, x: -page.wide});
			TweenMax.to(backLeft, 1.3, {x: 0, alpha: 0.90, ease: Expo.easeOut});

			/// cretes boards and center it on screen
			addChild(board);
			page.add(board, page.CENTERX, -(board.width / 2), page.CENTERY, -(board.height / 2), page.NONE, 0, page.NONE, 0);
			page.forceResize();
			dispatchEvent(new StatsBoxEvents(StatsBoxEvents.STATS_BOARD_INIT_CALCULATION));
		}
		
		

		public function showStats(owned:int, total:int, value:Number, cost:Number):void
		{
			var ownedPerc:Number = (owned / total) * 100;
			var costPerc:Number = (cost / value) * 100;
			var avgValue:Number = (value / owned);
			var avgCost:Number = (cost / owned);
			board.numberOfStamps.text = owned + " / " + total + "  ( " + Formatter.decimals(ownedPerc, 2, true) + "% )";
			board.valueOfStamps.text = Formatter.decimals(cost, 2, true) + " / " + Formatter.decimals(value, 2, true) + "  ( " + Formatter.decimals(costPerc, 2, false) + "% )";
			board.avgOfStamps.text = Formatter.decimals(avgCost, 3, true) + "  |  " + Formatter.decimals(avgValue, 3, true);
		}
		
		

		public function changeLabels(item:XMLList):void
		{
			board.title.text = item[LangEnum.STATSBOX_TITLE].@label;
			board.numberLabel.text = item[LangEnum.STATSBOX_NUMBER_STAMPS_OWNED].@label;
			board.costLabel.text = item[LangEnum.STATSBOX_COST].@label;
			board.averageLabel.text = item[LangEnum.STATSBOX_AVERAGE].@label;
		}
	}
}