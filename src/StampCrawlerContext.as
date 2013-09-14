package
{
	//------------------------------------------------------------------------------------- DISPLAY CONTAINERS
	import com.shinho.commands.AddStampCommand;
	import com.shinho.commands.ChooseImportXMLMethod;
	import com.shinho.commands.CountrySelectorLoad;
	import com.shinho.commands.Initialize;
	import com.shinho.commands.LoadLang;
	import com.shinho.commands.LoadPrefs;
	import com.shinho.commands.MessageBoxLoad;
	import com.shinho.commands.SetupStage;
	import com.shinho.commands.ShowStampInfo;
	import com.shinho.commands.StatsLoad;
	import com.shinho.commands.Update;
	import com.shinho.controllers.StampsController;
	import com.shinho.events.ApplicationEvent;
	import com.shinho.events.MenuEvents;
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.CountriesModel;
	import com.shinho.models.CountryStampsModel;
	import com.shinho.models.DecadeYearsModel;
	import com.shinho.models.FieldEntriesModel;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.LanguageModel;
	import com.shinho.models.PreferencesModel;
	import com.shinho.models.StampDatabase;
	import com.shinho.models.TypesModel;
	import com.shinho.models.XMLimported;
	import com.shinho.views.ApplicationMainView;
	import com.shinho.views.ApplicationMediator;
	import com.shinho.views.bottomMenu.BottomMenu;
	import com.shinho.views.bottomMenu.BottomMenuMediator;
	import com.shinho.views.countrySelector.CountrySelectorEvents;
	import com.shinho.views.countrySelector.CountrySelectorMediator;
	import com.shinho.views.countrySelector.CountrySelectorView;
	import com.shinho.views.decades.DecadesMediator;
	import com.shinho.views.decades.DecadesView;
	import com.shinho.views.export.ExportXML;
	import com.shinho.views.export.ExportXMLMediator;
	import com.shinho.views.importer.XMLimportMediator;
	import com.shinho.views.importer.XMLimportView;
	import com.shinho.views.messageBox.MessageBox;
	import com.shinho.views.messageBox.MessageBoxEvent;
	import com.shinho.views.messageBox.MessageBoxMediator;
	import com.shinho.views.pictureStripe.PictureStripeMediator;
	import com.shinho.views.pictureStripe.SeriesStripeView;
	import com.shinho.views.pictureStripe.thumb.Thumb;
	import com.shinho.views.pictureStripe.thumb.ThumbMediator;
	import com.shinho.views.stampInfo.StampInfoView;
	import com.shinho.views.stampInfo.StampInfoViewMediator;
	import com.shinho.views.statsBox.StatsBox;
	import com.shinho.views.statsBox.StatsBoxEvents;
	import com.shinho.views.statsBox.StatsBoxMediator;
	import com.shinho.views.types.TypesMenu;
	import com.shinho.views.types.TypesMenuMediator;

	import flash.display.DisplayObjectContainer;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;


	public class StampCrawlerContext extends Context
	{
		public function StampCrawlerContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}


		override public function startup():void
		{
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, Update, ContextEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadLang, ContextEvent);
			commandMap.mapEvent(ApplicationEvent.LANGUAGES_LOADED, LoadPrefs, ApplicationEvent);
			commandMap.mapEvent(ApplicationEvent.PREFERENCES_LOADED, SetupStage, ApplicationEvent);
			commandMap.mapEvent(ApplicationEvent.PREFERENCES_LOADED, Initialize, ApplicationEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, ShowStampInfo, ContextEvent);
			commandMap.mapEvent(CountrySelectorEvents.LOAD_BOARD, CountrySelectorLoad, CountrySelectorEvents);
			commandMap.mapEvent(MessageBoxEvent.LOAD_BOARD, MessageBoxLoad, MessageBoxEvent);
			commandMap.mapEvent(StatsBoxEvents.LOAD_BOARD, StatsLoad, StatsBoxEvents);
			commandMap.mapEvent(MenuEvents.IMPORT_XML, ChooseImportXMLMethod, MenuEvents);
			commandMap.mapEvent(StampsDatabaseEvents.ADD_STAMP, AddStampCommand, StampsDatabaseEvents);

			mediatorMap.createMediator(contextView);
			mediatorMap.mapView(ApplicationMainView, ApplicationMediator);
			mediatorMap.mapView(SeriesStripeView, PictureStripeMediator);
			mediatorMap.mapView(StampInfoView, StampInfoViewMediator);
			mediatorMap.mapView(CountrySelectorView, CountrySelectorMediator);
			mediatorMap.mapView(MessageBox, MessageBoxMediator);
			mediatorMap.mapView(StatsBox, StatsBoxMediator);
			mediatorMap.mapView(BottomMenu, BottomMenuMediator);
			mediatorMap.mapView(ExportXML, ExportXMLMediator);
			mediatorMap.mapView(DecadesView, DecadesMediator);
			mediatorMap.mapView(XMLimportView, XMLimportMediator);
			mediatorMap.mapView(Thumb, ThumbMediator);
			mediatorMap.mapView(TypesMenu, TypesMenuMediator);

			injector.mapSingleton(PreferencesModel);
			injector.mapSingleton(LanguageModel);
			injector.mapSingleton(StampDatabase);
			injector.mapSingleton(FlexLayout);
			injector.mapSingleton(StampsController);
			injector.mapSingleton(XMLimported);
			injector.mapSingleton(CountriesModel);
			injector.mapSingleton(FieldEntriesModel);
			injector.mapSingleton(TypesModel);
			injector.mapSingleton(DecadeYearsModel);
			injector.mapSingleton(CountryStampsModel);
//			viewMap.mapType(ApplicationMainView);
			//commandMap.mapEvent(MenuEvents.IMPORT_XML, ImportXML);
			//injector.mapSingleton(Importer);
			//mediatorMap.mapView(ImportXMLView, ImportXMLMediator);*/
			super.startup();
		}
	}
}