package com.shinho.views.bottomMenu {
	import flash.events.Event;

	public class BottomMenuEvents extends Event {
		// events

		
		private var _body:*;
		public static const SHOW_STATS:String = 'ApplicationEvent_Show_Stats';
		public static const CHANGE_COUNTRY:String = 'ApplicationEvent_Change_Country';
		public static const ADD_FIRST_STAMP:String = 'ApplicationEvent_Add_First_Stamp';
		

		public function BottomMenuEvents(type:String, body:* = null){
			super(type);
			_body = body;
		}


		public function get body():* {
			return _body;
		}


		override public function clone():Event {
			return new BottomMenuEvents(type, body);
		}

	}
}