

package com.shinho.views.countrySelector
{
	import flash.events.Event;
	
	public class CountrySelectorEvents extends Event
	{
		public static const LOAD_BOARD:String = 'CountrySelectorEvents_loadboard';
		///public static const CLOSE_BOARD:String = 'CountrySelector_closeboard';
		
		
		private var _body:*;
		
		public function CountrySelectorEvents(type:String, body:* = null)
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
			return new CountrySelectorEvents(type, body);
		}
	
	}
}