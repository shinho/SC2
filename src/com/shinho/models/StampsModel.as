/**
 * Created with IntelliJ IDEA.
 * User: Alexi7
 * Date: 03-02-2013
 * Time: 10:45
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.models
{

      import com.shinho.models.dto.SeriesDTO;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.util.StringUtils;

      import org.robotlegs.mvcs.Actor;

      public class StampsModel extends Actor
      {

            [Inject]
            public var db:StampDatabase;

            public var _currentStamp:StampDTO;

            private var _currentStampID:uint = 0;
            private var _hasStamps:Boolean = false;
            private var _numberOfStamps:uint = 0;
            private var _stampSeries:Vector.<SeriesDTO>;
            private var _stamps:Vector.<StampDTO>;
            private var _decades:Vector.<String>;
            private var _stampsOwned:uint;
            private var _totalCost:Number;
            private var _totalValue:Number;

            public var currentDecade:String;


            public function StampsModel()
            {
            }


            // .........................................................................................................
            // Public Methods
            // .........................................................................................................

            public function calculateTotalsForOwnedStamps():void
            {
                  _stampsOwned = 0;
                  _totalCost = 0;
                  _totalValue = 0;
                  for ( var i:int = 0; i < _stamps.length; i++ )
                  {
                        var stamp:StampDTO = _stamps[i] as StampDTO;
                        if ( stamp.owned )
                        {
                              _stampsOwned++;
                              _totalCost += stamp.cost;
                              _totalValue += stamp.current_value;
                        }
                  }
            }


            public function getBiggerStampNumber():int
            {
                  var lastNumber:String = _stamps[stamps.length - 1].number;
                  var biggerStamp:String = StringUtils.stripZeros( lastNumber );
                  if ( int( biggerStamp ) == NaN )
                  {
                        biggerStamp = biggerStamp.substring( 0, biggerStamp.length - 1 );
                  }
                  return int( biggerStamp );
            }


            public function getCurrentStamp():StampDTO
            {
                  return stamps[currentStampID];
            }


            public function getStamps( countryName:String, stampType:String ):void
            {
                  _stamps = Vector.<StampDTO>( db.getStampsForCountryAndType( countryName, stampType ) );
                  if ( _stamps.length > 0 )
                  {
                        _hasStamps = true;
                        _stamps = StringUtils.paddedNumberedArray( _stamps );
                        _stamps.sort( stampsOrderCriteria );
                        _stamps = StringUtils.stripPaddedArray( stamps );
                        _numberOfStamps = _stamps.length;
                        _stampSeries = getSeries();
                        distributeInSeries();
                  }
                  calculateTotalsForOwnedStamps();
            }


            public function addStamp( stampData:StampDTO ):void
            {
                  _stamps.push( stampData );
                  refreshCollection();
            }


            public function deleteStamp( stampDetails:StampDTO ):void
            {
                  var foundIndex:int = -1;
                  for ( var i:int = 0; i < _stamps.length; i++ )
                  {
                        var stampDTO:StampDTO = _stamps[i];
                        if ( stampDTO.country == stampDetails.country && stampDTO.type == stampDetails.type && stampDTO.number == stampDetails.number )
                        {
                              trace( "found" );
                              foundIndex = i;
                        }
                  }
                  if ( foundIndex >= 0 )
                  {
                        _stamps.splice( foundIndex, 1 );
                  }
                  refreshCollection();
            }


            // .........................................................................................................
            // Private Methods
            // .........................................................................................................

            private static function stampsOrderCriteria( a:StampDTO, b:StampDTO ):Number
            {
                  if ( a.number < b.number )
                  {
                        return -1;
                  }
                  else if ( a.number == b.number )
                  {
                        return 0;
                  }
                  {
                        return 1;
                  }
            }


            private function refreshCollection():void
            {
                  _stamps = StringUtils.paddedNumberedArray( _stamps );
                  _stamps.sort( stampsOrderCriteria );
                  _stamps = StringUtils.stripPaddedArray( stamps );
                  _numberOfStamps = _stamps.length;
                  _stampSeries = getSeries();
                  distributeInSeries();
            }


            private function getSeries():Vector.<SeriesDTO>
            {
                  var serieNames:Vector.<SeriesDTO> = Vector.<SeriesDTO>( [] );
                  for ( var i:int = 0; i < _numberOfStamps; i++ )
                  {
                        var found:Boolean = false;
                        if ( serieNames.length > 0 )
                        {
                              for ( var s:int = 0; s < serieNames.length; s++ )
                              {
                                    if ( _stamps[i].serie == serieNames[s].serieName && _stamps[i].year == serieNames[s].serieYear )
                                    {
                                          found = true;
                                    }
                              }
                        }
                        if ( !found )
                        {
                              var serie:SeriesDTO = new SeriesDTO();
                              serie.serieName = _stamps[i].serie;
                              serie.serieYear = _stamps[i].year;
                              serieNames.push( serie );
                        }
                  }
                  return serieNames;
            }


            private function distributeInSeries():void
            {
                  _decades = new Vector.<String>();
                  for ( var u:int = 0; u < _stamps.length; u++ )
                  {
                        var stamp:StampDTO = _stamps[u];
                        for ( var i:int = 0; i < _stampSeries.length; i++ )
                        {
                              // distribute in series
                              var series:SeriesDTO = _stampSeries[i];
                              if ( stamp.serie == series.serieName && stamp.year == series.serieYear )
                              {
                                    series.serieStamps.push( stamp );
                              }
                        }
                        addYearToDecade( stamp.year );
                  }
            }


            private function addYearToDecade( year:String ):void
            {
                  var decade:String = year.substr( 0, 3 ) + "0";
                  var exists:Boolean = false;
                  for ( var i:int = 0; i < _decades.length; i++ )
                  {
                        if ( decade == _decades[i] )
                        {
                              exists = true;
                        }
                  }
                  if ( !exists )
                  {
                        _decades.push( decade );
                  }
            }


            // .........................................................................................................
            // Getters and Setters
            // .........................................................................................................

            public function get hasStamps():Boolean
            {
                  return _hasStamps;
            }


            public function get stamps():Vector.<StampDTO>
            {
                  return _stamps.concat();
            }


            public function get stampSeries():Vector.<SeriesDTO>
            {
                  return _stampSeries;
            }


            public function get currentStampID():uint
            {
                  return _currentStampID;
            }


            public function set currentStampID( value:uint ):void
            {
                  _currentStampID = value;
            }


            public function get stampsOwned():uint
            {
                  return _stampsOwned;
            }


            public function get totalCost():Number
            {
                  return _totalCost;
            }


            public function get currentStamp():StampDTO
            {
                  return _currentStamp;
            }


            public function set currentStamp( value:StampDTO ):void
            {
                  _currentStamp = value;
            }


            public function get totalValue():Number
            {
                  return _totalValue;
            }


            public function getDecades(  ):Vector.<String>
            {
                 return _decades;
            }

      }
}
