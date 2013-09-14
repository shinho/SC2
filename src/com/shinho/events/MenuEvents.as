

package com.shinho.events
{
	import flash.events.Event;
	
	public class MenuEvents extends Event
	{
		public static const IMPORT_XML:String = 'import xml';
		public static const EXPORT_XML:String = 'export xml';
		
		private var _body:*;
		
		public function MenuEvents(type:String, body:* = null)
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
			return new MenuEvents(type, body);
		}
	
	}
}