package com.shinho.models {
	import com.shinho.events.ApplicationEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import org.robotlegs.mvcs.Actor;
	
	
	
	public class XMLimported extends Actor {
		public var stamplist:XMLList;
		
		
		
		public function XMLimported() {
			///trace("importer model instantiated");
		}
		
		
		
		public function loadXML(stampsXML:XML):void {
			var hasErrors:Boolean = false;
			var stamp:XML;
			stamplist = new XMLList(stampsXML.children());
			if (stamplist.length() > 0) {
				trace("list as " + stamplist.length() + " stamps");
				for each (stamp in stamplist) {
					if (stamp.@country.length() == 0 || stamp.@type.length() == 0 || stamp.@number.length() == 0) {
						hasErrors = true;
					}
				}
			} else {
				trace("file has no stamps");
				hasErrors = true;
			}
			if (hasErrors) {
				trace("xml has errors ********");
				eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.IMPORT_XML_MAL_FORMED));
			} else {
				trace("xml has no errors");
				eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.IMPORT_XML_OK));
			}
		}
	}
}