package com.shinho.controllers
{

      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.*;
      import com.shinho.models.dto.SerieDTO;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.models.dto.TypesDTO;
      import com.shinho.views.pictureStripe.SeriesStripeView;

      import org.osflash.signals.Signal;
      import org.robotlegs.mvcs.Actor;

      public class StampsController extends Actor
      {

            [Inject]
            public var countries:CountriesModel;
            [Inject]
            public var stamps:StampsModel;
            [Inject]
            public var db:StampDatabase;
            [Inject]
            public var decadeYearsModel:DecadeYearsModel;
            [Inject]
            public var fields:FieldEntriesModel;
            [Inject]
            public var types:TypesModel;
            // properties
            public var selectedSeriesStripe:SeriesStripeView;
            // signals
            private var _stampDataReadySignal:Signal = new Signal();
            private var _databaseIsEmptySignal:Signal = new Signal();


            public function StampsController()
            {
            }


            public function getCurrentDecade():String
            {
                  return decadeYearsModel.currentDecade;
            }


            public function getCurrentStamp():StampDTO
            {
                  return stamps.getCurrentStamp();
            }


            public function getCurrentStampID():uint
            {
                  return stamps.currentStampID;
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
                  return stamps.stampSeries;
            }


            public function getStampTypes():Vector.<TypesDTO>
            {
                  return types.getStampTypes();
            }


            public function getStamps():Vector.<StampDTO>
            {
                  return stamps.stamps;
            }


            public function init():void
            {
                  db.databaseConnectedSignal.add( onDatabaseConnect );
                  db.OpenDatabase();
                  db.stampAddedSignal.add(onStampAdded);
            }


            public function loadNewCountry():void
            {
                  types.getTypesForCountry( currentCountryName );
                  loadStampsType();
            }


            public function loadStampsType():void
            {
                  decadeYearsModel.setDecadesForCountryType( currentCountryName, types.getCurrentTypeName() );
                  stamps.getStamps( currentCountryName, types.getCurrentTypeName() );
                  checkData();
            }


            public function setCurrentTypeIndex( type:int ):void
            {
                  types.currentTypeIndex = type;
            }


            private function checkData():void
            {
                  if ( stamps.hasStamps )
                  {
                        _stampDataReadySignal.dispatch();
                  }
                  else
                  {
                        // TODO :: TURN THIS INTO A SIGNAL COMMAND MAP
                        eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.STAMPSDATABASE_EMPTY ) );
                  }
            }


            // .........................................................................................................
            // on events
            // .........................................................................................................

            private function onDatabaseConnect():void
            {
                  trace( "StampController: Database Connected" );
                  var countriesList:Array = db.getCountriesList();
                  if ( countriesList )
                  {
                        countries.setCountriesList( countriesList );
                        fields.createEntriesIndexes();
                        loadNewCountry();
                  } else
                  {
                        dbIsEmptySignal.dispatch();
                        trace( "StampController: Database Is Empty" );
                  }
            }


            private function onStampAdded( stampData:StampDTO ):void
            {
                 stamps.addStamp(stampData);
            }


            // .........................................................................................................
            //  Getters and setters
            // .........................................................................................................

            public function get stampDataReadySignal():Signal
            {
                  return _stampDataReadySignal;
            }


            public function get dbIsEmptySignal():Signal
            {
                  return _databaseIsEmptySignal;
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

