package com.shinho.events
{
	import flash.events.Event;


	public class StampsDatabaseEvents extends Event
	{
		public static const ADD_STAMP:String = 'StampDatabaseEvents_add_stamp';
		public static const STAMPSDATABASE_EMPTY:String = 'StampsDatabaseEvents_stampsdatabase_empty';
		public static const STAMP_ADDED:String = 'StampsDatabaseEvents_stamp_added';
		public static const DECADE_READY:String = 'StampsDatabaseEvents_decades_ready';
		public static const STAMPINFO_UPDATED:String = 'StampsDatabaseEvents_stampinfo_updated';
		public static const UPDATE_STRIPE:String = 'StampsDatabaseEvents_update_stripe';
		public static const STAMP_DELETED:String = 'StampsDatabaseEvents_stamp_deleted';
		public static const SHOW_BOARD_MESSAGE:String = 'StampsDatabaseEvents_show_board_message';
		public static const ALL_CALCULATED:String = 'StampsDatabaseEvents_all-Calculated';
		public static const INDEXES_UPDATED:String = 'StampsDatabaseEvents_indexes-updated';
		public static const XML_ITEM_ADDED:String = 'StampsDatabaseEvents_xml_item_added';
		private var _body:*;

		public function StampsDatabaseEvents( type:String, body:* = null )
		{
			super( type );
			_body = body;
		}


		override public function clone():Event
		{
			return new StampsDatabaseEvents( type, body );
		}


		public function get body():*
		{
			return _body;
		}
	}
}