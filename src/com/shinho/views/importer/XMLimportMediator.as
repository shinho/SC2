package com.shinho.views.importer {
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.events.ApplicationEvent;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.LanguageModel;
	import com.shinho.models.StampDatabase;
	import com.shinho.util.SpriteUtils;

	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.shinho.views.importer.XMLimportView;
	import com.shinho.models.XMLimported;
	
	public class XMLimportMediator extends Mediator {
		//---- inject VIEW dependancy
		[Inject]
		public var view:XMLimportView;
		//---- inject MODEL dependancy
		[Inject]
		public var stamps:StampDatabase;
		[Inject]
		public var importedXML:XMLimported;
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var lang:LanguageModel;
		// properties
		private var index:int = -1;
		private var nstamps:uint;
		private var added:uint = 0;
		
		
		
		public function XMLimportMediator(){
		}
		
		
		
		override public function onRegister():void {
			view.page = page;
			view.changeLabels(lang.labels);
			addViewListener(ApplicationEvent.IMPORT_XML_FILE_SELECTED, fileSelected);
			addViewListener(ApplicationEvent.IMPORT_XML_DISPLAY_UPDATED, importNext);
			addViewListener(ApplicationEvent.IMPORT_XML_CANCEL, importCanceled);
			// listen for buttons
			eventMap.mapListener(view.boardMethod.btOk, MouseEvent.CLICK, loadFile);
			eventMap.mapListener(view.boardMethod.btClose, MouseEvent.CLICK, closeBoard);
		}
		
		
		
		private function loadFile(e:MouseEvent):void {
			view.loadFile();
		}
		
		
		
		private function fileSelected(e:ApplicationEvent):void {
			eventMap.unmapListener(view.board.btClose, MouseEvent.CLICK, closeBoard);
			eventMap.mapListener(view.board.btClose, MouseEvent.CLICK, closeBoard);
			addContextListener(ApplicationEvent.IMPORT_XML_OK, xmlOK);
			addContextListener(ApplicationEvent.IMPORT_XML_MAL_FORMED, xmlMalformed);
			view.board.countryName.text = e.body;
			importedXML.loadXML(e.body);
		}
		
		
		
		private function xmlOK(e:ApplicationEvent):void {
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.IMPORT_XML_OK, xmlOK);
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.IMPORT_XML_MAL_FORMED, xmlMalformed);
			nstamps = importedXML.stamplist.length();
			view.board.xmlStamps.text = String(nstamps);
			view.board.countryName.text = importedXML.stamplist[0].@country;
			view.total_progress = importedXML.stamplist.length();
			addContextListener(StampsDatabaseEvents.XML_ITEM_ADDED, updateDisplay);
			index = 0;
			view.total_progress = nstamps;
			stamps.importMethod = view.options.selected;
			importNext(null);
		}
		
		
		
		private function updateDisplay(e:StampsDatabaseEvents):void {
			if (e.body){
				added++;
			}
			view.index = index;
			view.progress_value = index;
			index++;
			if (index >= nstamps){
				exiting();
			}
		}
		
		
		
		private function importNext(e:ApplicationEvent):void {
			if (index > view.index){
				stamps.importNewStamps(importedXML.stamplist, index);
			}
		}
		
		
		
		private function exiting():void {
			eventMap.unmapListener(eventDispatcher, StampsDatabaseEvents.XML_ITEM_ADDED, updateDisplay);
			view.progress_value = added;
			view.stopProgress();
			view.doneLabels(lang.labels);
		}
		
		
		
		private function closeBoard(e:MouseEvent):void {
			eventMap.unmapListener(eventDispatcher, MouseEvent.CLICK, closeBoard);
			SpriteUtils.removeAllChild(view);
			contextView.removeChild(view);
			eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.UPDATE_STRIPE));
		}
		
		
		
		private function xmlMalformed(e:ApplicationEvent):void {
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.IMPORT_XML_MAL_FORMED, xmlMalformed);
		}
		
		
		
		private function importCanceled(e:ApplicationEvent):void {
			closeBoard(null);
		}
	}
}