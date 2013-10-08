package com.shinho.views.statsBox
{
	import flash.events.Event;
	
	public class StatsBoxEvents extends Event
	{
		public static const LOAD_BOARD:String = 'StatsBox_loadboard';
		
		
		private var _body:*;
		
		public function StatsBoxEvents(type:String, body:* = null)
		{
			super(type);
			_body = body;
		}
		
		public function get body():*
		{
			return _body;
		}
		
		override public function clone():Event
		{
			return new StatsBoxEvents(type, body);
		}
	
	}
}