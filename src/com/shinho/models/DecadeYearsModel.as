/**
 * Created with IntelliJ IDEA.
 * User: Alexi7
 * Date: 02-02-2013
 * Time: 18:40
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.models
{

	import com.shinho.models.dto.DecadesDTO;

	import org.robotlegs.mvcs.Actor;


	public class DecadeYearsModel extends Actor
	{

		[Inject]
		public var db:StampDatabase;
		private var _decades:Array;
		private var _currentDecade:String;


		public function DecadeYearsModel()
		{
		}


		public function setDecadesForCountryType(countryName:String, type:String):void
		{
			var years:Vector.<DecadesDTO> = Vector.<DecadesDTO>(db.getDecadesForCountryAndType(countryName, type));
			var exists:Boolean = false;
			var decadeStr:String = "";
			_decades = [];

			if (years != null)
			{
				var value:DecadesDTO;
				for each (value in years)
				{
					exists = false;
					decadeStr = value.year.substr(0, 3);
					for (var i:int = 0; i < _decades.length; i++)
					{
						if (decadeStr == _decades[i].substr(0, 3))
						{
							exists = true;
						}
					}
					if (!exists)
					{
						_decades.push(decadeStr + "0");
					}
				}
				_currentDecade = _decades[0];
			}
			else
			{
				trace("Decades Model :: OOOPS NO YEARS FOR THAT TYPES");
			}
		}


		public function get decades():Array
		{
			return _decades;
		}


		public function get currentDecade():String
		{
			return _currentDecade;
		}


		public function set currentDecade(value:String):void
		{
			_currentDecade = value;
		}
	}
}
