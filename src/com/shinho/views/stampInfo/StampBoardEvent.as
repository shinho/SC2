package com.shinho.views.stampInfo {
	import flash.events.Event;
	
	
	public class StampBoardEvent extends Event {
		public static const CLOSE_BOARD:String = 'StampBoardEvent_close_board';
		public static const EDIT_CLICKED:String = 'StampBoardEvent_edit_clicked';
		public static const SAVE_CLICKED:String = 'StampBoardEvent_save_clicked';
		public static const ADD_CLICKED:String = 'StampBoardEvent_add_clicked';
		public static const CLEAR_CLICKED:String = 'StampBoardEvent_clear_clicked';
		public static const DELETE_CLICKED:String = 'StampBoardEvent_delete_clicked';
		public static const PASTE_CLICKED:String = 'StampBoardEvent_paste_clicked';
		public static const COPY_CLICKED:String = 'StampBoardEvent_copy_clicked';
		public static const CLEAR_IMAGE:String = 'StampBoardEvent_clear_image';
		public static const KEEP_ORIGINAL_DATA:String = 'StampBoardEvent_keeporiginaldata';
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