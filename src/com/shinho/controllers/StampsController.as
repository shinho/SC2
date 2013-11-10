package com.shinho.controllers
{

      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.*;
      import com.shinho.models.dto.SeriesDTO;
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
            public var stampsModel:StampsModel;
            [Inject]
            public var db:StampDatabase;
            [Inject]
            public var fieldsModel:FieldEntriesModel;
            [Inject]
            public var types:TypesModel;
            // properties
            public var selectedSeriesStripe:SeriesStripeView;
            public var previousStripeData:StampDTO;
            // signals
            private var _stampDataReadySignal:Signal = new Signal();
            private var _databaseIsEmptySignal:Signal = new Signal();


            public function StampsController()
            {
            }


            public function getCurrentDecade():String
            {
                  return stampsModel.currentDecade;
            }

            public function setCurrentDecade( newDecade:String ):void
            {
                  stampsModel.currentDecade = newDecade;
            }


            public function getCurrentStamp():StampDTO
            {
                  return stampsModel.getCurrentStamp();
            }


            public function getCurrentStampID():uint
            {
                  return stampsModel.currentStampID;
            }


            public function getCurrentStampsTypeIndex():int
            {
                  return types.currentTypeIndex;
            }


            public function getCurrentStampsTypeName():String
            {
                  return types.getCurrentTypeName();
            }


            public function getDecades():Vector.<String>
            {
                  return stampsModel.getDecades();
            }


            public function getSeries():Vector.<SeriesDTO>
            {
                  return stampsModel.stampSeries;
            }


            public function getStampTypes():Vector.<TypesDTO>
            {
                  return types.getStampTypes();
            }


            public function getStamps():Vector.<StampDTO>
            {
                  return stampsModel.stamps.concat();
            }


            public function init():void
            {
                  db.databaseConnectedSignal.add( onDatabaseConnect );
                  db.OpenDatabase();
                  db.stampAddedSignal.add( onStampAdded );
                  db.stampDeletedSignal.add( onStampDeleted );
                  db.stampUpdatedSignal.add( onStampUpdated );
            }


            public function loadNewCountry():void
            {
                  types.getTypesForCountry( currentCountryName );
                  loadStampsType();
            }


            public function loadStampsType():void
            {
//                  decadeYearsModel.setDecadesForCountryType( currentCountryName, types.getCurrentTypeName() );
                  stampsModel.getStamps( currentCountryName, types.getCurrentTypeName() );
                  checkData();
            }


            public function setCurrentTypeIndex( type:int ):void
            {
                  types.currentTypeIndex = type;
            }


            private function checkData():void
            {
                  if ( stampsModel.hasStamps )
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
                        fieldsModel.createEntriesIndexes();
                        loadNewCountry();
                  } else
                  {
                        dbIsEmptySignal.dispatch();
                        trace( "StampController: Database Is Empty" );
                  }
            }


            private function onStampAdded( stampDetails:StampDTO ):void
            {
                  stampsModel.addStamp( stampDetails );
                  _stampDataReadySignal.dispatch();
            }


            private function onStampDeleted( stampDetails:StampDTO ):void
            {
                  stampsModel.deleteStamp( stampDetails ) ;
                  _stampDataReadySignal.dispatch();
            }


            private function onStampUpdated( stampDetails:StampDTO ):void
            {
                  stampsModel.getStamps( stampDetails.country, stampDetails.type );
                  _stampDataReadySignal.dispatch();
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

