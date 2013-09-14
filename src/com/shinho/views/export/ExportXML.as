package com.shinho.views.export
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.shinho.models.FlexLayout;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import com.shinho.events.ApplicationEvent;
	import com.shinho.models.StampDatabase;
	import com.shinho.views.components.GlowButton;
	
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class ExportXML extends Sprite
	{
		public var board:MovieClip;
		private var backLeft:MovieClip = new QuadSWC();
		public var page:FlexLayout;
		private var file:File = new File();
		private var stamps:Array;
		private var prefsXML:XML;
		private var stream:FileStream;
		private var MSG_save:String;
		private var MSG_select:String;
		
		
		
		// -----------------------------------------------------------------------------------   CONSTRUCTOR
		public function ExportXML()
		{
			addChild(backLeft);
			board = new Export_SWC();
			addChild(board);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		// -----------------------------------------------------------------------------------   INIT
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			/// ----------------   creates background and animates
			page.add(backLeft, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60);
			TweenMax.to(backLeft, 0, {tint: 0x111111, x: -page.wide});
			TweenMax.to(backLeft, 1.3, {x: 0, alpha: 0.90, ease: Expo.easeOut});
			/// ----------------   creates boards and center it on screen
			page.add(board, page.CENTERX, -(board.width / 2), page.CENTERY, -(board.height / 2), page.NONE, 0, page.NONE, 0);
			var closeButton:GlowButton = new GlowButton(board.btClose);
			page.forceResize();
		}
		
		
		
		// -----------------------------------------------------------------------------------   PRINT INFO
		public function printInfo(countryName:String, stamps:Array):void
		{
			this.stamps = stamps;
			board.countryName.text = countryName;
			board.progress.text = "0 / " + stamps.length;
			file = File.documentsDirectory.resolvePath(StampDatabase.DIR_EXPORT + File.separator + countryName + ".xml");
			file.addEventListener(Event.SELECT, dirSelected);
			file.addEventListener(Event.CANCEL, exportCanceled);
			///file.browseForDirectory("Select a directory");
			file.browseForSave(MSG_select);
		}
		
		
		
		// -----------------------------------------------------------------------------------   EXPORT CANCELED
		private function exportCanceled(e:Event):void
		{
			trace("ExportXML Canceled");
			dispatchEvent(new ApplicationEvent(ApplicationEvent.EXPORT_XML_CANCELED));
		}
		
		
		
		// -----------------------------------------------------------------------------------   DIR SELECTED
		private function dirSelected(e:Event):void
		{
			board.fileName.text = file.nativePath;
			trace(file.nativePath);
			createXMLData();
			writeXMLData();
		}
		
		
		
		// -----------------------------------------------------------------------------------   CREATE XML DATA
		private function createXMLData():void
		{
			prefsXML =       <stamplist/>;
			for (var i:int = 0; i < stamps.length; i++)
			{
				board.progress.text = i + " / " + stamps.length;
				var item:XML =     <stamp />;
				item.@country = stamps[i].country;
				item.@type = stamps[i].type;
				item.@number = stamps[i].number;
				item.@year = stamps[i].year;
				item.@serie = stamps[i].serie;
				item.@denomination = stamps[i].denomination;
				item.@inscription = stamps[i].inscription;
				item.@perforation = stamps[i].perforation;
				item.@printer = stamps[i].printer;
				item.@paper = stamps[i].paper;
				item.@designer = stamps[i].designer;
				item.@history = stamps[i].history;
				item.@color = stamps[i].color;
				item.@variety = stamps[i].variety;
				item.@watermark = stamps[i].watermark;
				item.@main_catalog = stamps[i].main_catalog;
				///item.@circulation = stamps[i].circulation;
				///item.@amount = stamps[i].amount;
				item.@owned = stamps[i].owned;
				///item.@format = stamps[i].format;
				///item.@condition = stamps[i].condition;
				item.@spares = stamps[i].spares;
				item.@current_value = stamps[i].current_value;
				///item.@date_purchased = stamps[i].date_purchased;
				item.@seller = stamps[i].seller;
				item.@cost = stamps[i].cost;
				///item.@hinged = stamps[i].hinged;
				///item.@centering = stamps[i].centering;
				///item.@gum = stamps[i].gum;
				item.@cancel = stamps[i].cancel;
				item.@grade = stamps[i].grade;
				item.@comments = stamps[i].comments;
				item.@used = stamps[i].used;
				item.@condition_value = stamps[i].condition_value;
				item.@hinged_value = stamps[i].hinged_value;
				item.@centering_value = stamps[i].centering_value;
				item.@gum_value = stamps[i].gum_value;
				item.@faults = stamps[i].faults;
				item.@purchase_year = stamps[i].purchase_year;
				prefsXML.appendChild(item);
			}
		}
		
		
		
		// -----------------------------------------------------------------------------------   WRITE XML DATA
		private function writeXMLData():void
		{
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += prefsXML.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(outputString);
			stream.close();
			board.progress.text = MSG_save;
			dispatchEvent(new ApplicationEvent(ApplicationEvent.EXPORT_XML_SAVED));
			stamps = null;
		}
		
		
		
		//  ------------------------------------------------------------------------------------   Change Labels
		public function changeLabels(item:XMLList):void
		{
			board.title.text = item[20].@label;
			board.labelCountry.text = item[21].@label;
			board.labelFilename.text = item[22].@label;
			board.labelProgress.text = item[23].@label;
			MSG_save = item[24].@label;
			MSG_select = item[25].@label;
		}
	}
}