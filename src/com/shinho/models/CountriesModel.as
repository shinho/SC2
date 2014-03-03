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


            public function setCountriesList( country:Array ):void
            {
                  _countriesList = Vector.<CountryDTO>( country );
                  if ( _countriesList.length > 0 )
                  {
                        if ( _currentCountryIndex == -1 )
                        {
                              _currentCountryIndex = 0;
                              _currentCountryName = _countriesList[_currentCountryIndex].country;
                        }
                        _numberOfCountries = _countriesList.length;
                        setCurrentCountryByName(_currentCountryName);
                        _hasCountries = true;
                  }
            }


            public function setCurrentCountry( country:CountryDTO ):void
            {
                  _currentCountryName = country.country;
                  setCurrentCountryByName( _currentCountryName );
            }


            public function setCurrentCountryByName( countryName:String ):void
            {
                  for ( var i:int = 0; i < _countriesList.length; i++ )
                  {
                        if ( _countriesList[i].country == countryName )
                        {
                              _currentCountryIndex = i;
                        }
                  }
            }


            public function setCurrentCountryName( name:String ):void
            {
                  _currentCountryName = name;
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


            public function isCountryNew( country2Check:String ):Boolean
            {
                  var found:Boolean = false;
                  for ( var i:int = 0; i < _countriesList.length; i++ )
                  {
                        var countryName:Object = _countriesList[i];
                        if ( countryName == country2Check )
                        {
                              found = true;
                        }
                  }
                  return !found;
            }
      }

}