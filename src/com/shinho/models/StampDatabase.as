package com.shinho.models
{
      /**
       * ...
       * @author Nelson Alexandre (c)2013
       */

      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.dto.CountryDTO;
      import com.shinho.models.dto.DecadesDTO;
      import com.shinho.models.dto.IndexesDTO;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.models.dto.TypesDTO;
      import com.shinho.util.SQLhelper;
      import com.shinho.util.StringUtils;
      import com.shinho.views.messageBox.MessageBox;
      import com.shinho.views.messageBox.MessageBoxEvent;

      import flash.data.SQLConnection;
      import flash.data.SQLStatement;
      import flash.display.MovieClip;
      import flash.errors.SQLError;
      import flash.events.SQLErrorEvent;
      import flash.events.SQLEvent;
      import flash.filesystem.File;

      import org.osflash.signals.Signal;
      import org.robotlegs.mvcs.Actor;

      public class StampDatabase extends Actor
      {

            public static const id:int = 0;
            // ------------------------------------------------------------------------------------- SQL
            public static const number:int = 1;
            public static const year:int = 2;
            // ------------------------------------------------------------------------------------- BOOLEAN
            public static const serie:int = 3;
            public static const inscription:int = 4;
            public static const perforation:int = 5;
            public static const printer:int = 6;
            public static const paper:int = 7;
            public static const designer:int = 8;
            public static const history:int = 9;
            public static const color:int = 10;
            public static const country:int = 11;
            public static const denomination:int = 12;
            public static const variety:int = 14;
            public static const watermark:int = 15;
            public static const main_catalog:int = 16;
            public static const issue_date:int = 17;
            public static const circulation:int = 18;
            public static const amount:int = 19;
            public static const owned:int = 20;
            public static const format:int = 21;
            public static const condition:int = 22;
            public static const spares:int = 23;
            public static const current_value:int = 24;
            public static const date_purchased:int = 25;
            public static const seller:int = 26;
            public static const cost:int = 27;
            public static const hinged:int = 28;
            public static const centering:int = 29;
            public static const gum:int = 30;
            public static const cancel:int = 31;
            public static const grade:int = 32;
            public static const comments:int = 33;
            public static const used:int = 34;
            public static const condition_value:int = 35;
            public static const hinged_value:int = 36;
            public static const centering_value:int = 37;
            public static const gum_value:int = 38;
            public static const faults:int = 39;
            public static const type:int = 40;
            public static const purchase_year:int = 41;
            public static const FULL_IMPORT:int = 1;
            public static const STAMPDATA_IMPORT:int = 2;
            public static const STAMPS_CHECKED:String = 'stamps_checked';
            public static const DECADE_UPDATED:String = 'decade_updated';
            public static const STRIPE_UPDATED:String = 'Stripe_updated';
            public static const SERIE_UPDATED:String = 'Serie_updated';
            public static const NUMBER_UPDATED:String = 'number_updated';
            public static const TYPE_UPDATED:String = 'type_updated';
            public static const COUNTRY_UPDATED:String = 'country_updated';
            public static const NONE_UPDATED:String = 'none_updated';
            public static const DIR_HOME:String = "StampCrawler";
            public static const DATABASE_NAME:String = "stampsDatabase.db";
            public static const DIR_IMAGES:String = DIR_HOME + File.separator + "Images";
            public static const DIR_EXPORT:String = DIR_HOME + File.separator + "Export";
            public static const DIR_IMPORT:String = DIR_HOME + File.separator + "Import";
            public static const NONE_CHANGED:uint = 0;
            public static const NUMBER_CHANGED:uint = 1;
            public static const SERIE_CHANGED:uint = 2;
            public static const YEAR_CHANGED:uint = 4;
            public static const TYPE_CHANGED:uint = 8;
            public static const COUNTRY_CHANGED:uint = 16;
            public var StampInfoChangedState:uint;
            public var StampInfoUpdateState:String;
            public var allColors:Array = [];
            public var allCountries:Array = [];
            public var allDesigners:Array = [];
            public var allPapers:Array = [];
            public var allSeries:Array = [];
            public var catalogs:Array = [];
            public var currentCountry:int = -1;
            public var currentDecade:int = 0;
            public var currentSerieName:String;
            public var currentStampID:String;
            public var currentStripe:MovieClip;
            public var currentType:int = 0;
            public var currentYear:String;
            public var databaseConnectedSignal:Signal = new Signal();
            public var decades:Array = [];
            public var doAllCalculations:Boolean = false;
            public var importMethod:uint;
            public var oldCountries:Array = [];
            public var ownedStamps:int;
            public var printTypes:Array = [];
            public var printers:Array = [];
            public var sellers:Array = [];
            public var stampArray:Array = [];
            public var stampInfoChanged:Boolean;
            public var stampUpdatedSignal:Signal = new Signal( StampDTO );
            public var stampAddedSignal:Signal = new Signal();
            public var stampsInCurrentSerie:int;
            public var stamptypes:Array = [];
            public var totalCost:Number;
            public var totalStamps:int;
            public var totalValue:Number;
            public var types:Array = [];
            private var SQLConn:SQLConnection = new SQLConnection();
            private var dbFile:File;
            private var forwardDelete:Boolean = false;
            private var stampExists:Boolean = false;
            private var stampData:StampDTO;
            private var statement:SQLStatement = new SQLStatement();


            public function StampDatabase()
            {
            }


            public function OpenDatabase():void
            {
                  SQLConn.addEventListener( SQLEvent.OPEN, dbConnected );
                  SQLConn.addEventListener( SQLErrorEvent.ERROR, getSQLError );
                  dbFile = File.documentsDirectory.resolvePath( DIR_HOME );
                  if ( !dbFile.exists )
                  {
                        dbFile.createDirectory();
                  }
                  dbFile = File.documentsDirectory.resolvePath( DIR_IMAGES );
                  if ( !dbFile.exists )
                  {
                        dbFile.createDirectory();
                  }
                  dbFile = File.documentsDirectory.resolvePath( DIR_IMPORT );
                  if ( !dbFile.exists )
                  {
                        dbFile.createDirectory();
                  }
                  dbFile = File.documentsDirectory.resolvePath( DIR_EXPORT );
                  if ( !dbFile.exists )
                  {
                        dbFile.createDirectory();
                  }
                  dbFile = File.documentsDirectory.resolvePath( DIR_HOME + File.separator + DATABASE_NAME );
                  SQLConn.open( dbFile );
            }


            //refactored

            public function addImportedStamp( stamp:Array ):void
            {
            }


            //refactored

            public function changeCountry():void
            {
                  types = getStampTypesForCountry( "" );
//		decades = getDecades("");
                  existsCurrentDecade();
                  stampArray = getStampsForCountryAndType( "", "" );
                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.DECADE_READY ) );
            }


            //refactored

            public function changeDecade( newDecade:String ):void
            {
                  currentDecade = int( newDecade );
                  stampArray = getStampsForCountryAndType( "", "" );
                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.DECADE_READY ) );
            }


            //refactored

            public function changeType( newType:int ):void
            {
                  currentType = newType;
//		decades = getDecades("");
                  existsCurrentDecade();
                  stampArray = getStampsForCountryAndType( "", "" );
                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.DECADE_READY ) );
            }


            public function checkStampID( countryName:String, stampNumber:String, typeOf:String ):Boolean
            {
                  var checked:Boolean = false;
                  statement.text = "SELECT * FROM stampDatabase WHERE country='" + countryName + "' and number='" + stampNumber + "' and type='" + typeOf + "' ORDER BY country asc";
                  statement.execute();
                  var data:Array = statement.getResult().data;
                  if ( data != null && data.length > 0 )
                  {
                        checked = true;
                  }
                  return checked;
            }


            public function defineUpdateState():void
            {
                  StampInfoUpdateState = StampDatabase.NONE_UPDATED;
                  if ( checkChanges( StampInfoChangedState, StampDatabase.NUMBER_CHANGED ) )
                  {
                        StampInfoUpdateState = StampDatabase.NUMBER_UPDATED;
                  }
                  if ( checkChanges( StampInfoChangedState, StampDatabase.SERIE_CHANGED ) )
                  {
                        StampInfoUpdateState = StampDatabase.SERIE_UPDATED;
                  }
                  if ( checkChanges( StampInfoChangedState, StampDatabase.YEAR_CHANGED ) )
                  {
                        StampInfoUpdateState = StampDatabase.DECADE_UPDATED;
                  }
                  if ( checkChanges( StampInfoChangedState, StampDatabase.TYPE_CHANGED ) )
                  {
                        StampInfoUpdateState = StampDatabase.TYPE_UPDATED;
                  }
                  if ( checkChanges( StampInfoChangedState, StampDatabase.COUNTRY_CHANGED ) )
                  {
                        StampInfoUpdateState = StampDatabase.COUNTRY_UPDATED;
                  }
            }


            public function deleteStamp( stampData:StampDTO, askConfirmation:Boolean = false ):void
            {
                  this.stampData = stampData;
                  currentSerieName = stampData.serie;
                  currentYear = stampData.year;
                  if ( askConfirmation )
                  {
                        var title:String = "Delete Stamp?";
                        var question:String = "This will delete stamp information from database and no recovery is possible. Are you sure you want to do this?";
                        eventDispatcher.dispatchEvent( new MessageBoxEvent( MessageBoxEvent.LOAD_BOARD,
                            MessageBox.TYPE_YES_NO, title,
                            question ) );
                        eventMap.mapListener( eventDispatcher, MessageBoxEvent.OPTION_SELECTED, deleteAnswer );
                  }
                  else
                  {
                        deleteStep2();
                  }
            }


            public function getAllStampsFromCountry( currentCountryName:String, countryName:String = "" ):Array
            {
                  if ( countryName == "" )
                  {
                        countryName = currentCountryName;
                  }
                  statement.text = "SELECT * FROM stampDatabase WHERE country='" + countryName + "'" + " ORDER BY type,year, number, serie asc";
                  statement.execute();
                  var data:Array = statement.getResult().data;
                  var temp:Array = [];
                  if ( data != null )
                  {
                        var item:Object;
                        for each ( item in data )
                        {
                              temp.push( item );
                        }
                  }
                  else
                  {
                        trace( "StampDatabase :: OOOPS NO STAMPS!!! - current country is " + currentCountry + " name is " + currentCountryName );
                        currentDecade = 0;
                  }
                  return temp;
            }


            //---------------------------------------------------------------   GET STAMPS TO DISPLAY

            public function getCountriesList():Array
            {
                  statement.text = "SELECT DISTINCT country FROM stampDatabase ORDER BY country asc";
                  statement.itemClass = CountryDTO;
                  statement.execute();
                  return statement.getResult().data;
            }


            public function getDecadesForCountryAndType( currentCountryName:String, stampType:String ):Array
            {
                  statement.text = "SELECT DISTINCT year FROM stampDatabase WHERE country='" + currentCountryName + "' and type='" + stampType + "' ORDER BY year asc";
                  statement.itemClass = DecadesDTO;
                  statement.execute();
                  return statement.getResult().data;
            }


            public function getFieldsEntries( field:String ):Array
            {
                  statement.sqlConnection = SQLConn;
                  statement.text = "SELECT DISTINCT " + field + " AS entry FROM stampDatabase ORDER BY " + field + " asc";
                  statement.itemClass = IndexesDTO;
                  statement.execute();
                  return statement.getResult().data;
            }


            public function getFullID():Object
            {
                  var item:Object = {number: currentStampID, country: oldCountries[currentCountry], type: types[currentType]};
                  return item;
            }


            public function getID( $number:String, checkArray:Array = null ):int
            {
                  if ( checkArray == null )
                  {
                        checkArray = stampArray;
                  }
                  var found:int = -1;
                  for ( var i:int = 0; i < checkArray.length; i++ )
                  {
                        if ( checkArray[i].number == $number )
                        {
                              found = i;
                        }
                  }
                  return found;
            }


            public function getStampData():Object
            {
                  var index:int = getID( currentStampID );
                  return stampArray[index];
            }


            public function getStampTypesForCountry( currentCountryName:String ):Array
            {
                  statement.text = "SELECT DISTINCT type FROM stampDatabase WHERE country='" + currentCountryName + "' ORDER BY type asc";
                  statement.itemClass = TypesDTO;
                  statement.execute();
                  return statement.getResult().data;
            }


            public function getStampsForCountryAndType( currentCountryName:String, stampType:String ):Array
            {
                  statement.text = "SELECT * FROM stampDatabase WHERE country='" + currentCountryName + "' and type='" + stampType + "' ORDER BY year, number, serie asc";
                  statement.itemClass = StampDTO;
                  statement.execute();
                  return statement.getResult().data;
            }


            public function getStampsOfSerie( serieName:String, year:String ):Array
            {
                  ///debugStampArray();
                  var temp:Array = [];
                  for ( var i:int = 0; i < stampArray.length; i++ )
                  {
                        if ( stampArray[i].serie == serieName && stampArray[i].year == year )
                        {
                              temp.push( stampArray[i] );
                        }
                  }
                  return temp;
            }


            public function importNewStamps( stampslist:XMLList, index:uint ):void
            {
                  var added:Boolean = false;
                  var countryStamps:Array = getAllStampsFromCountry( stampslist[index].@country );
                  if ( countryStamps.length > 0 )
                  {
                        if ( countryStamps[0].main_catalog == stampslist[index].@main_catalog )
                        {
                              // ------------------------------------------------------  same catalog ok to add
                              added = addXMLitem( stampslist[index] );
                              eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.XML_ITEM_ADDED,
                                  added ) );
                        }
                        else
                        {
                              added = addXMLitem( stampslist[index] );
                              eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.XML_ITEM_ADDED,
                                  added ) );
                        }
                  }
                  else
                  {
                        // ------------------------------------------------------  full import
                        added = addXMLitem( stampslist[index] );
                        eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.XML_ITEM_ADDED,
                            added ) );
                  }
                  if ( added )
                  {
                        getCountriesList();
                        for ( var j:int = 0; j < oldCountries.length; j++ )
                        {
                              if ( oldCountries[j] == stampslist[index].@country )
                              {
                                    currentCountry = j;
                              }
                        }
                        StampInfoUpdateState = StampDatabase.COUNTRY_UPDATED;
                        // TODO: loadIndexes();
                  }
            }


            public function init():void
            {
                  OpenDatabase();
            }


            public function insertStampData( stampDetails:StampDTO ):void
            {
                  var tempDecade:String = String( stampDetails.year );
                  tempDecade = tempDecade.substr( 0, 3 ) + "0";
                  currentDecade = int( tempDecade );
                  currentSerieName = stampDetails.serie;
                  currentStampID = stampDetails.number;
                  currentYear = stampDetails.year;
                  // check to see if current type is a new one
                  var newOne:Boolean = true;
                  for ( var i:int = 0; i < types.length; i++ )
                  {
                        var typeName:String = types[i];
                        if ( stampDetails.type == typeName )
                        {
                              newOne = false;
                        }
                  }
                  if ( newOne == true )
                  {
                        types.push( stampDetails.type );
                        currentType = types.length - 1;
                  }
                  // check to see if current country is a new one
                  newOne = true;
                  for ( var j:int = 0; j < oldCountries.length; j++ )
                  {
                        var countryName:String = oldCountries[j];
                        if ( stampDetails.country == countryName )
                        {
                              newOne = false;
                        }
                  }
                  if ( newOne == true )
                  {
                        oldCountries.push( stampDetails.country );
                        currentCountry = oldCountries.length - 1;
                  }
                  insertStampInDatabase( stampDetails );

                  stampAddedSignal.dispatch(stampDetails);

                  var checkStatesFlag:uint = StampDatabase.COUNTRY_CHANGED | StampDatabase.TYPE_CHANGED;
                  if ( checkChanges( StampInfoChangedState, checkStatesFlag ) )
                  {
                        createCountryImageDir();
                  }
            }


            public function loadStampInfo():void
            {
//		types = getStampTypesForCountry("");
//		decades = getDecades("");
                  stampArray = getStampsForCountryAndType( "", "" );
                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.DECADE_READY ) );
            }


            public function refreshStamps():void
            {
                  stampArray = getStampsForCountryAndType( "", "" );
                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.DECADE_READY ) );
            }


            public function startUpdateProcess( stampData:StampDTO ):void
            {
                  trace( "startUpdateProcess" );
                  this.stampData = stampData;
                  if ( StampInfoUpdateState != StampDatabase.NONE_UPDATED )
                  {
                        stampExists = checkStampID( stampData.country, stampData.number, types.currentType );
                        if ( stampExists )
                        {
                              //ask confirmation from user for replacement
                              if ( !checkChanges( StampInfoChangedState, StampDatabase.NUMBER_CHANGED ) )
                              {
                                    updateOriginalStamp( stampData );
                              }
                              else
                              {
                                    var title:String = "Overwrite Stamp Information?";
                                    var question:String = "A stamp with that number already exists. Do you want to overwrite stamp data?";
                                    eventDispatcher.dispatchEvent( new MessageBoxEvent( MessageBoxEvent.LOAD_BOARD,
                                        MessageBox.TYPE_YES_NO,
                                        title, question ) );
                                    eventMap.mapListener( eventDispatcher, MessageBoxEvent.OPTION_SELECTED,
                                        overwriteAnswer );
                              }
                        }
                        else
                        {
                              updateOriginalStamp( stampData );
                        }
                  }
                  else
                  {
                        updateOriginalStamp( stampData );
                  }
            }


            public function updateOriginalStamp( stampDetails:StampDTO ):void
            {
                  trace( "updateOriginalStamp" );
                  stampInfoChanged = true;
                  var sql:String = SQLhelper.UpdateStampSQL(stampDetails);
                  var tempDecade:String = String( stampDetails.year );
                  tempDecade = tempDecade.substr( 0, 3 ) + "0";
                  currentDecade = int( tempDecade );
                  currentStampID = stampDetails.number;
                  currentSerieName = stampDetails.serie;
                  currentYear = stampDetails.year;
                  statement.text = sql;
                  statement.itemClass = null;
                  statement.execute();
                  stampUpdatedSignal.dispatch(stampDetails);
//                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.STAMPINFO_UPDATED,
//                      stampDetails ) );
            }


            private function addXMLitem( item:XML ):Boolean
            {
                  var added:Boolean = false;
                  var stampDef:StampDTO = new StampDTO();
                  if ( !checkStampID( item.@country, item.@number, item.@type ) )
                  {
                        stampDef.country = item.@country;
                        stampDef.type = item.@type;
                        stampDef.number = item.@number;
                        stampDef.color = item.@color;
                        stampDef.denomination = item.@denomination;
                        stampDef.designer = item.@designer;
                        stampDef.inscription = item.@inscription;
                        stampDef.history = item.@history;
                        stampDef.paper = item.@paper;
                        stampDef.serie = item.@serie;
                        stampDef.printer = item.@printer;
                        stampDef.perforation = item.@perforation;
                        stampDef.variety = item.@variety;
                        stampDef.watermark = item.@watermark;
                        stampDef.year = item.@year;
                        stampDef.main_catalog = item.@main_catalog;
                        switch ( importMethod )
                        {
                              case FULL_IMPORT:
                                    stampDef.current_value = StringUtils.stringToNumber( item.@current_value );
                                    stampDef.cost = StringUtils.stringToNumber( item.@cost );
                                    stampDef.seller = item.@seller;
                                    stampDef.purchase_year = StringUtils.stringToInt( item.@purchase_year );
                                    stampDef.comments = item.@comments;
                                    stampDef.cancel = item.@cancel;
                                    stampDef.grade = item.@grade.value;
                                    stampDef.spares = item.@spares.value;
                                    stampDef.owned = StringUtils.stringToBoolean( item.@owned );
                                    stampDef.used = StringUtils.stringToBoolean( item.@used );
                                    stampDef.condition_value = StringUtils.stringToInt( item.@condition_value );
                                    stampDef.hinged_value = StringUtils.stringToInt( item.@hinged_value );
                                    stampDef.centering_value = StringUtils.stringToInt( item.@centering_value );
                                    stampDef.gum_value = StringUtils.stringToInt( item.@gum_value );
                                    stampDef.gum_value = StringUtils.stringToInt( item.@gum_value );
                                    stampDef.faults = item.@faults;
                                    break;
                              case STAMPDATA_IMPORT:
                                    stampDef.current_value = 0;
                                    stampDef.cost = 0;
                                    stampDef.seller = "";
                                    stampDef.purchase_year = 0;
                                    stampDef.comments = "";
                                    stampDef.cancel = "";
                                    stampDef.grade = "";
                                    stampDef.spares = 0;
                                    stampDef.owned = false;
                                    stampDef.used = false;
                                    stampDef.condition_value = 0;
                                    stampDef.hinged_value = 0;
                                    stampDef.centering_value = 0;
                                    stampDef.gum_value = 0;
                                    stampDef.gum_value = 0;
                                    stampDef.faults = "";
                                    break;
                              default:
                                    stampDef.current_value = 0;
                                    stampDef.cost = 0;
                                    stampDef.seller = "";
                                    stampDef.purchase_year = 0;
                                    stampDef.comments = "";
                                    stampDef.cancel = "";
                                    stampDef.grade = "";
                                    stampDef.spares = 0;
                                    stampDef.owned = false;
                                    stampDef.used = false;
                                    stampDef.condition_value = 0;
                                    stampDef.hinged_value = 0;
                                    stampDef.centering_value = 0;
                                    stampDef.gum_value = 0;
                                    stampDef.gum_value = 0;
                                    stampDef.faults = "";
                        }
                        insertStampInDatabase( stampDef );
                        added = true;
                  }
                  return added;
            }


            private function checkChanges( flags:uint, testFlag:uint ):Boolean
            {
                  return (flags & testFlag) == testFlag;
            }


            private function createCountryImageDir():void
            {
                  var fs:String = File.separator;
                  var dir:File = File.applicationStorageDirectory.resolvePath( "images" + fs + stampData.country + fs + stampData.type );
                  if ( !dir.exists )
                  {
                        dir.createDirectory();
                  }
            }


            private function deleteStep2():void
            {
                  var sql:String = "DELETE FROM stampDatabase WHERE ";
                  sql = sql + "country='" + stampData[country] + "' AND type='" + types[currentType] + "'";
                  sql = sql + " AND number='" + stampData[number] + "'";
                  statement.text = sql;
                  statement.execute();
                  if ( forwardDelete )
                  {
                        stampData[number] = stampData[id];
                        updateOriginalStamp( stampData );
                        forwardDelete = false;
                  }
                  else
                  {
                        /// decide what kind of update we will need
                        stampArray = getStampsForCountryAndType( "", "" );
                        var stampsInCurrentCountry:int = stampArray.length;
                        if ( stampsInCurrentCountry > 0 )
                        {
                              /// ---------- if some stamps still exist, just delete stamp
                              StampInfoUpdateState = DECADE_UPDATED;
                              trace( "just delete stamp" );
                        }
                        else
                        {
                              /// ---------- no stamps exist check another type
                              types = getStampTypesForCountry( "" );
                              var numberTypes:int = types.length;
                              currentType = 0;
                              stampArray = getStampsForCountryAndType( "", "" );
                              if ( stampArray.length > 0 )
                              {
                                    trace( "we need to update type" );
                                    StampInfoUpdateState = TYPE_UPDATED;
                                    eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.DECADE_READY ) );
                              }
                              else
                              {
                                    trace( "we need to update country" );
                                    StampInfoUpdateState = COUNTRY_UPDATED;
                                    getCountriesList();
                                    currentCountry = 0;
                                    currentType = 0;
                                    currentDecade = 0;
                                    loadStampInfo();
                              }
                              ///eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.DECADE_READY));
                        }
                  }
                  eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.STAMP_DELETED ) );
            }


            private function existsCurrentDecade():void
            {
                  var existence:Boolean = false;
                  for ( var i:int = 0; i < decades.length; i++ )
                  {
                        if ( int( decades[i] + "0" ) == currentDecade )
                        {
                              existence = true;
                        }
                  }
                  if ( !existence )
                  {
                        currentDecade = 0;
                  }
            }


            private function getSQLError( error:SQLError ):void
            {
                  trace( "StampDatabase :: oooops wasn't counting on this!" );
                  trace( "-------> THIS IS AN ERROR    ::    " + error.errorID + "  :  " + error.details + "  :  " + error.operation );
            }


            private function insertStampInDatabase( stampDef:StampDTO ):void
            {
                  var sql:String = "INSERT INTO stampDatabase ";
                  sql = sql + "(id, number, country, color, denomination, designer, inscription, paper, serie, printer, perforation, variety, watermark, year, type, history, current_value, cost, seller, comments, cancel, grade, owned, spares, used, condition_value, hinged_value, centering_value, gum_value, faults, purchase_year, main_catalog) VALUES (NULL, ";
                  sql = sql + "'" + stampDef.number + "', ";
                  sql = sql + "'" + stampDef.country + "', ";
                  sql = sql + "'" + stampDef.color + "', ";
                  sql = sql + "'" + stampDef.denomination + "', ";
                  sql = sql + "'" + stampDef.designer + "', ";
                  sql = sql + "'" + stampDef.inscription + "', ";
                  sql = sql + "'" + stampDef.paper + "', ";
                  sql = sql + "'" + stampDef.serie + "', ";
                  sql = sql + "'" + stampDef.printer + "', ";
                  sql = sql + "'" + stampDef.perforation + "', ";
                  sql = sql + "'" + stampDef.variety + "', ";
                  sql = sql + "'" + stampDef.watermark + "', ";
                  sql = sql + "'" + stampDef.year + "', ";
                  sql = sql + "'" + stampDef.type + "', ";
                  sql = sql + "'" + stampDef.history + "', ";
                  sql = sql + "'" + stampDef.current_value + "', ";
                  sql = sql + "'" + stampDef.cost + "', ";
                  sql = sql + "'" + stampDef.seller + "', ";
                  sql = sql + "'" + stampDef.comments + "', ";
                  sql = sql + "'" + stampDef.cancel + "', ";
                  sql = sql + "'" + stampDef.grade + "', ";
                  sql = sql + stampDef.owned + ", ";
                  sql = sql + stampDef.spares + ", ";
                  sql = sql + stampDef.used + ", ";
                  sql = sql + stampDef.condition_value + ", ";
                  sql = sql + stampDef.hinged_value + ", ";
                  sql = sql + stampDef.centering_value + ", ";
                  sql = sql + stampDef.gum_value + ", ";
                  sql = sql + "'" + stampDef.faults + "', ";
                  sql = sql + stampDef.purchase_year + ", ";
                  sql = sql + "'" + stampDef.main_catalog + "' ";
                  sql = sql + ")";
                  statement.text = sql;
                  statement.execute();
            }


            private function swapIDs():void
            {
                  var tempValue:String = stampData[id];
                  stampData[id] = stampData[number];
                  stampData[number] = tempValue;
            }


            private function dbConnected( event:SQLEvent ):void
            {
                  statement.sqlConnection = SQLConn;
                  statement.text = "CREATE TABLE IF NOT EXISTS stampDatabase (id INTEGER PRIMARY KEY, number VARCHAR(15), main_catalog VARCHAR(20), type VARCHAR(70), country VARCHAR(80), year VARCHAR(4), issue_date DATE, serie VARCHAR(256), variety VARCHAR(100), perforation VARCHAR(20), printer VARCHAR(100), designer VARCHAR(150), circulation VARCHAR(50), amount VARCHAR(30), paper VARCHAR(30), denomination VARCHAR(20), color VARCHAR(30), watermark VARCHAR(15), inscription VARCHAR(150), history TEXT, format VARCHAR(40), condition VARCHAR(20), spares INTEGER, current_value FLOAT, date_purchased DATE, purchase_year INTEGER, seller VARCHAR(100), cost FLOAT, hinged VARCHAR(35), centering VARCHAR(35), gum VARCHAR(35), cancel VARCHAR(80), owned BOOLEAN, grade VARCHAR(100), comments TEXT, used BOOL, condition_value INTEGER, hinged_value INTEGER, centering_value INTEGER, gum_value INTEGER, faults VARCHAR(100))";
                  statement.execute();
                  databaseConnectedSignal.dispatch();

//		if (_countries.numberOfCountries > 0) {
//			// TODO : loadIndexes();
//			loadStampInfo();
//		}
            }


            private function overwriteAnswer( e:MessageBoxEvent ):void
            {
                  eventMap.unmapListener( eventDispatcher, MessageBoxEvent.OPTION_SELECTED, overwriteAnswer );
                  switch ( e.typeBox )
                  {
                        case MessageBoxEvent.YES:
                              swapIDs();
                              forwardDelete = true;
                              deleteStamp( stampData );
                              break;
                  }
            }


//    public function overwriteOnAdd():void
//    {
//        stampData[id] = stampData[number];
//        updateOriginalStamp();
//    }

            private function deleteAnswer( e:MessageBoxEvent ):void
            {
                  eventMap.unmapListener( eventDispatcher, MessageBoxEvent.OPTION_SELECTED, overwriteAnswer );
                  switch ( e.typeBox )
                  {
                        case MessageBoxEvent.YES:
                              forwardDelete = false;
                              deleteStep2();
                              break;
                        case MessageBoxEvent.NO:
                              ///eventDispatcher.dispatchEvent(new StampBoardEvent(StampBoardEvent.CLOSE_BOARD));
                              break;
                  }
            }
      }
}