package com.shinho.views.decades
{
	import flash.events.Event;
	
	
	
	public class DecadesEvents extends Event
	{
		// events
		private var _body:*;
		public static const DECADE_SELECTED:String = 'DecadesEvents_DECADE_SELECTED';
		
		
		
		public function DecadesEvents(type:String, body:* = null)
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
			return new DecadesEvents(type, body);
		}
	}
}