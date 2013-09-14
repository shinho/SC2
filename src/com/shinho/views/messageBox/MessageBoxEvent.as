package com.shinho.views.messageBox {
	import flash.events.Event;
	
	
	
	public class MessageBoxEvent extends Event {
		public static const LOAD_BOARD:String = 'MessageBoxEvent_loadboard';
		public static const OPTION_SELECTED:String = 'MessageBoxEvent_option_selected';
		public static const YES:String = 'yes_selected';
		public static const NO:String = 'no_selected';
		private var _typeBox:String;
		private var _title:String;
		private var _question:String;
		
		
		
		public function MessageBoxEvent(type:String, typeBox:String, title:String = "", question:String = ""){
			super(type);
			_typeBox = typeBox;
			_title = title;
			_question = question;
		}
		
		
		
		public function get typeBox():String {
			return _typeBox;
		}
		
		
		
		public function get title():String {
			return _title;
		}
		
		
		
		public function get question():String {
			return _question;
		}
		
		
		
		override public function clone():Event {
			return new MessageBoxEvent(type, typeBox, title, question);
		}
	}
}