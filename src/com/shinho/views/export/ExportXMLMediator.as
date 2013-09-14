package com.shinho.views.export
{
	import com.shinho.events.ApplicationEvent;
import com.shinho.models.CountriesModel;
import com.shinho.models.FlexLayout;
	import com.shinho.models.LanguageModel;
	import com.shinho.models.StampDatabase;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;
	import com.shinho.views.export.ExportXML;
	
	
	
	public class ExportXMLMediator extends Mediator
	{
		//---- inject VIEW dependancy
		[Inject]
		public var view:ExportXML;
		//---- inject MODEL dependancy
		[Inject]
		public var stamps:StampDatabase;
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var lang:LanguageModel;
		[Inject]
		public var countries:CountriesModel;
		
		
		
		// -----------------------------------------------------------------------------------   CONSTRUCTOR
		public function ExportXMLMediator()
		{
		}
		
		
		
		// -----------------------------------------------------------------------------------   ON REGISTER
		override public function onRegister():void
		{
			view.page = page;
			view.changeLabels(lang.labels);
			addViewListener(ApplicationEvent.EXPORT_XML_SAVED, fileSaved);
			addViewListener(ApplicationEvent.EXPORT_XML_CANCELED, exportCanceled);
			view.printInfo(countries.currentCountryName, stamps.getAllStampsFromCountry(""));
		}
		
		
		
		// -----------------------------------------------------------------------------------   CLOSE BOARD
		private function closeBoard(e:MouseEvent):void
		{
			eventMap.unmapListener(eventDispatcher, MouseEvent.CLICK, closeBoard);
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.EXPORT_XML_CLOSE));
		}
		
		
		
		// -----------------------------------------------------------------------------------   FILE SAVED
		private function fileSaved(e:ApplicationEvent):void
		{
			eventMap.unmapListener(eventDispatcher, ApplicationEvent.EXPORT_XML_SAVED, fileSaved);
			eventMap.mapListener(view.board.btClose, MouseEvent.CLICK, closeBoard);
		}
		
		
		
		// -----------------------------------------------------------------------------------   EXPORT CANCELED
		private function exportCanceled(e:ApplicationEvent):void
		{
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.EXPORT_XML_CLOSE));
		}
		
		
		
	}
}