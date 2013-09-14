package com.shinho.models
{

	import com.shinho.models.dto.CountryDTO;

	import org.robotlegs.mvcs.Actor;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class CountriesModel extends Actor
	{

		[Inject]
		public var db:StampDatabase;
		private var _countriesList:Vector.<CountryDTO>;
		private var _currentCountryIndex:int = -1;
		private var _currentCountryName:String = "";
		private var _hasCountries:Boolean = false;
		private var _numberOfCountries:uint = 0;


		public function CountriesModel()
		{
		}


		public function init():void
		{
		}


		public function setCountriesList(country:Array):void
		{
			_countriesList = Vector.<CountryDTO>(country);
			if (_countriesList.length > 0)
			{
				if (_currentCountryIndex == -1)
				{
					_currentCountryIndex = 0;
				}
				_numberOfCountries = _countriesList.length;
				_currentCountryName = getCurrentIndex().country;
				_hasCountries = true;
			}
		}


		public function setCurrentCountry(country:CountryDTO):void
		{
			_currentCountryName = country.country;
		}


		private function getCurrentIndex():CountryDTO
		{
			var country:CountryDTO = _countriesList[_currentCountryIndex] as CountryDTO;
			return country;
		}


		public function get currentCountryName():String
		{
			return _currentCountryName;
		}


		public function get numberOfCountries():uint
		{
			return _numberOfCountries;
		}


		public function get countriesList():Vector.<CountryDTO>
		{
			return _countriesList;
		}


		public function get hasCountries():Boolean
		{
			return _hasCountries;
		}
	}

}