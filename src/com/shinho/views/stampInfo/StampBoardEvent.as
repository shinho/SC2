package com.shinho.views.stampInfo {
	import flash.events.Event;
	
	
	public class StampBoardEvent extends Event {
		public static const PASTE_CLICKED:String = 'StampBoardEvent_paste_clicked';
		public static const COPY_CLICKED:String = 'StampBoardEvent_copy_clicked';
		public static const CLEAR_IMAGE:String = 'StampBoardEvent_clear_image';
		private var _body:*;
		
		
		public function StampBoardEvent(type:String,body:* = null){
			super(type);
			_body = body;
		}
		
		
		public function get body():* {
			return _body;
		}
		
		
		override public function clone():Event {
			return new StampBoardEvent(type,body);
		}
	}
}