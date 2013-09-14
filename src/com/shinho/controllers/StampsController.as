package com.shinho.controllers
{

	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.*;
	import com.shinho.models.dto.SerieDTO;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.models.dto.TypesDTO;

	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;


	public class StampsController extends Actor
	{

		[Inject]
		public var countries:CountriesModel;
		[Inject]
		public var countryStamps:CountryStampsModel;
		[Inject]
		public var db:StampDatabase;
		[Inject]
		public var decadeYearsModel:DecadeYearsModel;
		[Inject]
		public var fields:FieldEntriesModel;
		[Inject]
		public var types:TypesModel;
		private var _stampDataReadySignal:Signal = new Signal();


		public function StampsController()
		{
		}


		public function getCurrentDecade():String
		{
			return decadeYearsModel.currentDecade;
		}


		public function getCurrentStamp():StampDTO
		{
			return countryStamps.getCurrentStamp();
		}


		public function getCurrentStampID():uint
		{
			return countryStamps.currentStampID;
		}


		public function getCurrentStampsTypeIndex():int
		{
			return types.currentTypeIndex;
		}


		public function getCurrentStampsTypeName():String
		{
			return types.getCurrentTypeName();
		}


		public function getDecades():Array
		{
			return decadeYearsModel.decades;
		}


		public function getSeries():Vector.<SerieDTO>
		{
			return countryStamps.stampSeries;
		}


		public function getStampTypes():Vector.<TypesDTO>
		{
			return types.getStampTypes();
		}


		public function getStamps():Vector.<StampDTO>
		{
			return countryStamps.stamps;
		}


		public function init():void
		{
			db.databaseConnectedSignal.add( onDatabaseConnect );
			db.OpenDatabase();

		}


		public function loadNewCountry():void
		{
			types.getTypesForCountry( currentCountryName );
			loadStampsType();
		}


		public function loadStampsType():void
		{
			decadeYearsModel.setDecadesForCountryType( currentCountryName, types.getCurrentTypeName() );
			countryStamps.getStamps( currentCountryName, types.getCurrentTypeName() );
			checkData();
		}


		public function setCurrentTypeIndex( type:int ):void
		{
			types.currentTypeIndex = type;
		}


		private function checkData():void
		{
			if ( countryStamps.hasStamps )
			{
				_stampDataReadySignal.dispatch();
			}
			else
			{
				// TODO :: TURN THIS INTO A SIGNAL COMMAND MAP
				eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.STAMPSDATABASE_EMPTY ) );
			}
		}


		private function onDatabaseConnect():void
		{
			trace( "StampController: Database Connected" );
			countries.setCountriesList( db.getCountriesList() );
			fields.createEntriesIndexes();
			loadNewCountry();

		}


		public function get stampDataReadySignal():Signal
		{
			return _stampDataReadySignal;
		}


		public function get numberOfCountries():uint
		{
			return countries.numberOfCountries;
		}


		public function get currentCountryName():String
		{
			return countries.currentCountryName;
		}
	}
}

