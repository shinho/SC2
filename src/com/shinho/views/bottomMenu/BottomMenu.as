package com.shinho.views.bottomMenu {
	import com.greensock.*;
	import com.shinho.views.bottomMenu.BottomMenuEvents;
	import com.shinho.models.FlexLayout;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.xml.XMLDocument;
	
	
	
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class BottomMenu extends MovieClip {
		// PROPERTIES
		private var bt:MovieClip;
		public var decade:String;
		private static var bottomMenuHolder:Sprite = new Sprite();
		// buttons
		public var btChangeCountry:ButtonChangeCountry = new ButtonChangeCountry();
		public var btStats:ButtonStatistics = new ButtonStatistics();
		public var btAddStamp:ButtonAddFirst = new ButtonAddFirst();
		public var page:FlexLayout;
		public var stampsDisplayed:Boolean;
		
		
		
		public function BottomMenu() {
			trace("bottom menu initialised");
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		private function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(bottomMenuHolder);
			page.add(bottomMenuHolder, page.NONE, 0, page.TALL, -40, page.NONE, 0, page.NONE, 0);
			var backArea:MovieClip = new MenuBarSWC();
			bottomMenuHolder.addChild(backArea);
			page.add(backArea, page.NONE, 0, page.NONE, 0, page.WIDE, 0, page.NONE, 40);
			page.forceResize();
			bottomMenuHolder.addChild(btAddStamp);
			btAddStamp.x = 52;
			btAddStamp.y = 3;
			bottomMenuHolder.addChild(btChangeCountry);
			btChangeCountry.x = 162;
			btChangeCountry.y = 3;
			bottomMenuHolder.addChild(btStats);
			btStats.x = 276;
			btStats.y = 3;
			btStats.addEventListener(MouseEvent.CLICK, btStatsClicked);
			btAddStamp.addEventListener(MouseEvent.CLICK, btAddClicked);
			btChangeCountry.addEventListener(MouseEvent.CLICK, btChangeCountryClicked);
		}
		
		
		
		//  -----------------------------------------------------------------------   btStatsClicked
		private function btStatsClicked(e:MouseEvent):void {
			dispatchEvent(new BottomMenuEvents(BottomMenuEvents.SHOW_STATS));
		}
		
		
		
		//  -----------------------------------------------------------------------   btStatsClicked
		private function btAddClicked(e:MouseEvent):void {
			dispatchEvent(new BottomMenuEvents(BottomMenuEvents.ADD_FIRST_STAMP));
		}
		
		
		
		//  -----------------------------------------------------------------------   btStatsClicked
		private function btChangeCountryClicked(e:MouseEvent):void {
			dispatchEvent(new BottomMenuEvents(BottomMenuEvents.CHANGE_COUNTRY));
		}
		
		public function changeLang(item:XMLList):void {
			btAddStamp.changeLabel(item[0].@label);
			btChangeCountry.changeLabel(item[1].@label);
			btStats.changeLabel (item[2].@label);
		}
	}
}