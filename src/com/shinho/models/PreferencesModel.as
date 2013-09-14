package com.shinho.models
{
	/**
	 * ...
	 * @author Nelson Alexandre
	 */ // Imports
	import com.shinho.events.ApplicationEvent;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import org.robotlegs.mvcs.Actor;


	//framework
	public class PreferencesModel extends Actor
	{
		[Inject]
		public var lang:LanguageModel;
		[Inject]
		public var stamps:StampDatabase;
		private var prefsFile:File;
		private var prefsXML:XML;
		private var stream:FileStream;


		public function PreferencesModel()
		{
		}


		public function loadPrefXMLFile():void
		{
			prefsFile = File.applicationStorageDirectory;
			prefsFile = prefsFile.resolvePath("preferences.xml");
			readXML();
		}


		public function saveXMLFile():void
		{
			trace("Preparing to Close App");
			saveData();
		}


		private function createXMLData():void
		{
			prefsXML = <preferences/>;
			prefsXML.currentCountry.@index = stamps.currentCountry;
			prefsXML.currentType.@index = stamps.currentType;
			prefsXML.saveDate = new Date().toString();
			prefsXML.language = lang.currentLang;
		}


		private function processXMLData():void
		{
			prefsXML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			stamps.currentCountry = prefsXML.currentCountry.@index;
			stamps.currentType = prefsXML.currentType.@index;
			lang.currentLang = prefsXML.language;
			dispatch(new ApplicationEvent(ApplicationEvent.PREFERENCES_LOADED));
		}


		private function readXML():void
		{
			stream = new FileStream();
			if (prefsFile.exists)
			{
				stream.open(prefsFile, FileMode.READ);
				trace("Preferences File Exists");
				processXMLData();
			}
			else
			{
				trace("Preferences File Dont Exist");
				stamps.init();
				saveData();
				dispatch(new ApplicationEvent(ApplicationEvent.PREFERENCES_LOADED));
			}
		}


		private function saveData():void
		{
			createXMLData();
			writeXMLData();
		}


		private function writeXMLData():void
		{
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += prefsXML.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			stream = new FileStream();
			stream.open(prefsFile, FileMode.WRITE);
			stream.writeUTFBytes(outputString);
			stream.close();
		}
	}
}