package com.shinho.commands
{
	//Robotlegs import command
	import org.robotlegs.mvcs.Command;
	import flash.events.ErrorEvent
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	import flash.desktop.NativeApplication;
	
///import mx.controls.Alert;
	
	/**
	 * @author Nelson Alexandre
	 */
	public class Update extends Command
	{
		
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		
		override public function execute():void
		{
			trace("Check For Update Version");
			checkForUpdate();
		}
		
		private function checkForUpdate():void
		{
			setApplicationVersion(); // Find the current version so we can show it below
			appUpdater.updateURL = "http://www.stampcrawler.com/updates/update.xml"; // Server-side XML file describing update
			appUpdater.isCheckForUpdateVisible = false; // We won't ask permission to check for an update
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); // Once initialized, run onUpdate
			appUpdater.addEventListener(ErrorEvent.ERROR, onError); // If something goes wrong, run onError
			appUpdater.initialize(); // Initialize the update framework
		}
		
		private function onError(event:ErrorEvent):void
		{
			trace("error loading update.xml");
		}
		
		private function onUpdate(event:UpdateEvent):void
		{
			appUpdater.checkNow(); // Go check for an update now
		}
		
		// Find the current version for our Label below
		private function setApplicationVersion():void
		{
			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			//ver.text = "Current version is " + appXML.ns::version;
			trace("Current version is " + appXML.ns::versionNumber);
		}
	
	}
}

