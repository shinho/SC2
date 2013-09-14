package com.shinho.views.types {
	import flash.events.Event;

	public class TypesMenuEvents extends Event {
		// events

		
		private var _body:*;
		public static const TYPE_SELECTED:String = 'TypesMenuEvents_TYPE_SELECTED';


		public function TypesMenuEvents(type:String, body:* = null){
			super(type);
			_body = body;
		}


		public function get body():* {
			return _body;
		}


		override public function clone():Event {
			return new TypesMenuEvents(type, body);
		}

	}
}