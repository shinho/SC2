package com.shinho.models
{
	/**
	 * ...
	 * @author Nelson Alexandre
	 */ //Flash
// Robotlegs

	import com.shinho.events.ApplicationEvent;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import org.robotlegs.mvcs.Actor;

	public class LanguageModel extends Actor
	{
		public var currentLang:String = LANG_EN;
		public static const LANGUAGE_FILE:String = "lang" + File.separator;
		public static const LANG_EN:String = "en-US";
		public static const LANG_PT:String = "pt-PT";
		private var _langXML:XML;


		public function LanguageModel()
		{
			trace("Language model initiated");
		}


		public function getLabelAt(index:int):String
		{
			var item:XMLList = _langXML.children();
			return item[index].@label;
		}


		public function loadLanguage():void
		{
			var xmlFile:File = File.applicationDirectory.resolvePath(LANGUAGE_FILE + currentLang + ".xml");
			var stream:FileStream = new FileStream();
			if (xmlFile.exists)
			{
				stream.open(xmlFile, FileMode.READ);
				_langXML = XML(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
				dispatch(new ApplicationEvent(ApplicationEvent.LANGUAGES_LOADED));
			}
			else
			{
				trace("language file not found!");
				dispatch(new ApplicationEvent(ApplicationEvent.LANGUAGES_FAILED));
			}
		}


		public function get labels():XMLList
		{
			return _langXML.children();
		}
	}
}