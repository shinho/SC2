package com.shinho.commands {
	//Robotlegs import command
	import org.robotlegs.mvcs.Command;
	import flash.events.Event;
	import com.shinho.models.LanguageModel;
	
	
	
	/**
	 * @author Nelson Alexandre
	 */
	public class LoadLang extends Command {
		[Inject]
		public var lang:LanguageModel;
		
		
		
		override public function execute():void {
			lang.loadLanguage();
			contextView.stage.nativeWindow.addEventListener(Event.CLOSING, appClosing);
		}
		
		
		
		private function appClosing(e:Event):void {
		}
	}
}