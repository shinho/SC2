package com.shinho.commands {
	//Robotlegs import command
	import org.robotlegs.mvcs.Command;
	import flash.events.Event;
	import com.shinho.models.PreferencesModel;
	
	
	
	/**
	 * @author Nelson Alexandre
	 */
	public class LoadPrefs extends Command {
		[Inject]
		public var pref:PreferencesModel;
		
		
		
		override public function execute():void {
			pref.loadPrefXMLFile();
			contextView.stage.nativeWindow.addEventListener(Event.CLOSING, appClosing);
		}
		
		
		
		private function appClosing(e:Event):void {
			pref.saveXMLFile();
		}
	}
}