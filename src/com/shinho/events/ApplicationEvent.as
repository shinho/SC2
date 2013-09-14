package com.shinho.events {
	import flash.events.Event;
	
	
	
	public class ApplicationEvent extends Event {
		// --------------------------------------------------------------------  Main Events
		public static const ADD_STAMP:String = 'ApplicationEvent_Add_Stamp';
		// --------------------------------------------------------------------  EXPORT XML
		public static const EXPORT_XML_CLOSE:String = 'ApplicationEvent_export_xml_close_board';
		public static const EXPORT_XML_SAVED:String = 'ApplicationEvent_export_xml_close_saved';
		public static const EXPORT_XML_CANCELED:String = 'ApplicationEvent_export_xml_canceled';
		// --------------------------------------------------------------------  IMPORT XML
		public static const IMPORT_XML_FILE_SELECTED:String = 'ApplicationEvent_import_xml_file_selected';
		public static const IMPORT_XML_MAL_FORMED:String = 'ApplicationEvent_import_xml_mal_formed';
		public static const IMPORT_XML_OK:String = 'ApplicationEvent_import_xml_ok';
		public static const IMPORT_XML_CANCEL:String = 'ApplicationEvent_import_xml_cancel';
		public static const IMPORT_XML_DISPLAY_UPDATED:String = 'ApplicationEvent_import_xml_display_updated';
		public static const LOCK_WHEEL:String = 'ApplicationEvent_lockwheel';
		public static const UNLOCK_WHEEL:String = 'ApplicationEvent_unlockwheel';
		// context events
		public static const PREFERENCES_LOADED:String = 'ContextEvent_preferences_loaded';
		public static const LANGUAGES_LOADED:String = 'ContextEvent_languages_loaded';
		public static const LANGUAGES_FAILED:String = 'ContextEvent_languages_failed';
		
		private var _body:*;
		
		
		
		public function ApplicationEvent(type:String, body:* = null){
			super(type);
			_body = body;
		}
		
		
		
		public function get body():* {
			return _body;
		}
		
		
		
		override public function clone():Event {
			return new ApplicationEvent(type, body);
		}
	
	}
}