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
            public var types:TypesModel;
            // properties
            public var currentSeriesStripe:SeriesStripeView;
            public var previousStripeData:StampDTO;
            // signals
            private var _stampDataReadySignal:Signal = new Signal();
            private var _stampAddedSignal:Signal = new Signal();
            private var _stampDeletedSignal:Signal = new Signal();
            private var _stampUpdatedSignal:Signal = new Signal();
            private var _databaseIsEmptySignal:Signal = new Signal();


            public function StampsController()
            {
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


            public function calculateStatistics():void
            {
                  stampsModel.calculateTotalsForOwnedStamps(currentCountryName);
            }


            // .........................................................................................................
            // on events
            // .........................................................................................................

            private function checkData():void
            {
                  if ( stampsModel.hasStamps )
                  {
                        _stampDataReadySignal.dispatch();
                  }
                  else
                  {
                        // TODO :: IMPLEMENT FUNCTIONALITY
                        _databaseIsEmptySignal.dispatch();
                  }
            }

            private function onDatabaseConnect():void
            {
                  trace( "StampController: Database Connected" );
                  var countriesList:Array = db.getCountriesList();
                  if ( countriesList )
                  {
                        countries.setCountriesList( countriesList );
                        stampsModel.createEntriesIndexes();
//                        stampsModel.init();
                        loadNewCountry();
                  } else
                  {
                        _databaseIsEmptySignal.dispatch();
                        trace( "StampController: Database Is Empty" );
                  }
            }


            private function onStampAdded( stampDetails:StampDTO ):void
            {
                  stampsModel.addStamp( stampDetails );
                  _stampAddedSignal.dispatch( stampDetails );
            }


            private function onStampDeleted( stampDetails:StampDTO ):void
            {
                  stampsModel.deleteStamp( stampDetails );
                  _stampDeletedSignal.dispatch( stampDetails );
            }


            private function onStampUpdated( stampDetails:StampDTO ):void
            {
                  stampsModel.getStamps( stampDetails.country, stampDetails.type );
                  _stampUpdatedSignal.dispatch( stampDetails )
            }


            // .........................................................................................................
            //  Getters and setters
            // .........................................................................................................

            public function get stampDataReadySignal():Signal
            {
                  return _stampDataReadySignal;
            }


            public function get stampAddedSignal():Signal
            {
                  return _stampAddedSignal;
            }


            public function get stampDeletedSignal():Signal
            {
                  return _stampDeletedSignal;
            }


            public function get stampUpdatedSignal():Signal
            {
                  return _stampUpdatedSignal;
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
      }
}

