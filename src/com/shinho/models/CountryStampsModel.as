/**
 * Created with IntelliJ IDEA.
 * User: Alexi7
 * Date: 03-02-2013
 * Time: 10:45
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.models
{

	import com.shinho.models.dto.SerieDTO;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.util.StringUtils;

	import org.robotlegs.mvcs.Actor;


	public class CountryStampsModel extends Actor
	{

		public var currentStamp:StampDTO;
		[Inject]
		public var db:StampDatabase;
		private var _currentStampID:uint = 0;
		private var _hasStamps:Boolean = false;
		private var _numberOfStamps:uint = 0;
		private var _stampSeries:Vector.<SerieDTO>;
		private var _stamps:Vector.<StampDTO>;
		private var _stampsOwned:uint;
		private var _totalCost:Number;
		private var _totalValue:Number;


		public function CountryStampsModel()
		{
		}


		public function calculateTotalsForOwnedStamps():void
		{
			var nStart:Number = new Date().time;
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
			var nMillisElapsed:Number = new Date().time - nStart;
			trace( "getting owned stamps:", nMillisElapsed );
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
				serializeStamps();
			}
			calculateTotalsForOwnedStamps();
		}


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


		private function getSeries():Vector.<SerieDTO>
		{
			var serieNames:Vector.<SerieDTO> = Vector.<SerieDTO>( [] );
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
					var serie:SerieDTO = new SerieDTO();
					serie.serieName = _stamps[i].serie;
					serie.serieYear = _stamps[i].year;
					serieNames.push( serie );
				}
			}
			return serieNames;
		}


		private function onStampUpdated( stamp:StampDTO ):void
		{

		}


		private function serializeStamps():void
		{
			for ( var u:int = 0; u < _stamps.length; u++ )
			{
				var stamp:StampDTO = _stamps[u];
				for ( var i:int = 0; i < _stampSeries.length; i++ )
				{
					var serieDTO:SerieDTO = _stampSeries[i];
					if ( stamp.serie == serieDTO.serieName && stamp.year == serieDTO.serieYear )
					{
						serieDTO.serieStamps.push( stamp );
					}
				}
			}
		}


		public function get hasStamps():Boolean
		{
			return _hasStamps;
		}


		public function get stamps():Vector.<StampDTO>
		{
			return _stamps;
		}


		public function get stampSeries():Vector.<SerieDTO>
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


		public function get totalValue():Number
		{
			return _totalValue;
		}
	}
}
