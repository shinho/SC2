package com.shinho.views.importer
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import flash.events.Event;
	import com.shinho.models.FlexLayout;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import com.shinho.events.ApplicationEvent;
	import com.shinho.views.components.GlowButton;
	import com.shinho.views.components.BlackCheckBoxGroup;
	
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class XMLimportView extends Sprite
	{
		public var board:XMLimport_SWC = new XMLimport_SWC();
		public var boardMethod: XMLmethod_SWC = new XMLmethod_SWC();
		private var backLeft:MovieClip = new QuadSWC();
		public var page:FlexLayout;
		private var file:FileReference = new FileReference();
		public var progress_value:uint = 0;
		public var total_progress:uint;
		public var index:int = -1;
		public var update:Boolean = false;
		public var options:BlackCheckBoxGroup;
		
		
		
		//  ------------------------------------------------------------------------------------   Constructor
		public function XMLimportView()
		{
			addChild(backLeft);
			addChild(boardMethod);
			var optionsButtons:Array = new Array(boardMethod.optionFull, boardMethod.optionImport);
			boardMethod.optionFillIn.alpha = 0.35;
			options = new BlackCheckBoxGroup(optionsButtons);
			options.setSelected(1);
			var okButton:GlowButton = new GlowButton(boardMethod.btOk);
			var closeButtonMethod:GlowButton = new GlowButton(boardMethod.btClose);
			var closeButton:GlowButton = new GlowButton(board.btClose);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		//  ------------------------------------------------------------------------------------   initi
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			//  cretes background and animates
			page.add(backLeft, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60);
			TweenMax.to(backLeft, 0, {tint: 0x111111, x: -page.wide});
			TweenMax.to(backLeft, 1.3, {x: 0, alpha: 0.90, ease: Expo.easeOut});
			// cretes boards and center it on screen
			page.add(boardMethod, page.CENTERX, -(board.width / 2), page.CENTERY, -(board.height / 2), page.NONE, 0, page.NONE, 0);
			page.forceResize();
		}
		
		
		//  ------------------------------------------------------------------------------------   update progress
		public function updateProgress(e:Event):void
		{
			board.bar.width = (progress_value / total_progress) * 255;
			board.progress.text = String(progress_value + " / " + total_progress);
			dispatchEvent(new ApplicationEvent(ApplicationEvent.IMPORT_XML_DISPLAY_UPDATED));
		}
		
		
		//  ------------------------------------------------------------------------------------   change bar
		public function changeBar(progress:int):void
		{
			board.bar.width = progress * 2.5;
		}
		
		
		//  ------------------------------------------------------------------------------------   stop progress
		public function stopProgress():void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateProgress);
		}
		
		
		//  ------------------------------------------------------------------------------------   Load file
		public function loadFile():void
		{
			removeChild(boardMethod);
			addChild(board);
			board.bar.width = 0;
			page.add(board, page.CENTERX, -(board.width / 2), page.CENTERY, -(board.height / 2), page.NONE, 0, page.NONE, 0);
			page.forceResize();
			this.addEventListener(Event.ENTER_FRAME, updateProgress);
			clearFields();
			file.addEventListener(Event.SELECT, fileSelected);
			file.addEventListener(Event.CANCEL, importCanceled);
			file.browse();
		}
		
		
		//  ------------------------------------------------------------------------------------   clear fields
		private function clearFields():void
		{
			board.countryName.text = "";
			board.xmlStamps.text = "";
			board.progress.text = "";
		}
		
		
		//  ------------------------------------------------------------------------------------   label shown when done
		public function doneLabels(item:XMLList):void
		{
			board.bar.visible = false;
			board.legend1.text = item[13].@label;
			board.legend2.text = item[14].@label;
			board.xmlStamps.text = String(progress_value);
			board.legend3.text = item[15].@label;
			board.progress.text = String(total_progress - progress_value);
		}
		
		
		
		//  ------------------------------------------------------------------------------------   file Selected
		private function fileSelected(e:Event):void
		{
			file.addEventListener(Event.COMPLETE, loadXML);
			file.load();
			///dispatchEvent(new ApplicationEvent(ApplicationEvent.IMPORT_XML_FILE_SELECTED, e.target));
		}
		
		
		
		//  ------------------------------------------------------------------------------------   Load XML
		private function loadXML(e:Event):void
		{
			trace("xml loaded");
			var xml:XML = new XML(e.target.data);
			dispatchEvent(new ApplicationEvent(ApplicationEvent.IMPORT_XML_FILE_SELECTED, xml));
		}
		
		
		
		//  ------------------------------------------------------------------------------------   Import Canceled
		private function importCanceled(e:Event):void
		{
			trace("import canceled");
			dispatchEvent(new ApplicationEvent(ApplicationEvent.IMPORT_XML_CANCEL));
		}
		
		
		
		//  ------------------------------------------------------------------------------------   Change Labels
		public function changeLabels(item:XMLList):void
		{
			board.title.text = item[9].@label;
			board.legend1.text = item[10].@label;
			board.legend2.text = item[11].@label;
			board.legend3.text = item[12].@label;
			boardMethod.title.text = item[16].@label;
			boardMethod.lengend1.text = item[17].@label;
			boardMethod.lengend2.text = item[18].@label;
			boardMethod.lengend3.text = item[19].@label;
		}
	}
}