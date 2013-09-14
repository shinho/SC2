package com.shinho.commands
{
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.CountriesModel;
	import com.shinho.models.CountryStampsModel;
	import com.shinho.models.DecadeYearsModel;
	import com.shinho.models.StampDatabase;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.views.messageBox.MessageBox;
	import com.shinho.views.messageBox.MessageBoxEvent;

	import org.robotlegs.mvcs.Command;



	public class AddStampCommand extends Command
	{
		[Inject]
		public var countries:CountriesModel;
		[Inject]
		public var decades:DecadeYearsModel;
		[Inject]
		public var stamps:CountryStampsModel;
		[Inject]
		public var db:StampDatabase;
		[Inject]
		public var event:StampsDatabaseEvents;



		override public function execute():void {
			trace("AddStampCommand command executed");
			var stampData:StampDTO = event.body as StampDTO;
			var stampExist = db.checkStampID(stampData.country, stampData.number as String, stampData.type);
			if (stampExist)
			{
				//ask confirmation from user for replacement
				var title:String = "Overwrite Stamp Information?";
				var question:String = "A stamp with that number already exists. Do you want to overwrite stamp data?";
				eventDispatcher.dispatchEvent( new MessageBoxEvent( MessageBoxEvent.LOAD_BOARD, MessageBox.YES_NO,
				                                                    title,
				                                                    question ) );
//				eventMap.mapListener( eventDispatcher, MessageBoxEvent.OPTION_SELECTED, overwriteOnAdd );
			}
		}



	}
}

//public function addStamp(stampData:StampDTO):void
//{
//	this.stampdata = stampData;
//	stampExists = checkStampID(stampdata.country, stampdata.number, stampdata.type);
//	if (stampExists)
//	{
//		//ask confirmation from user for replacement
//		var title:String = "Overwrite Stamp Information?";
//		var question:String = "A stamp with that number already exists. Do you want to overwrite stamp data?";
//		eventDispatcher.dispatchEvent(new MessageBoxEvent(MessageBoxEvent.LOAD_BOARD, MessageBox.YES_NO, title,
//		                                                  question));
//		eventMap.mapListener(eventDispatcher, MessageBoxEvent.OPTION_SELECTED, overwriteOnAdd);
//	}
//	else
//	{
//		insertStampData();
//	}
//}



//private function insertStampData():void
//{
//	var tempDecade:String = String(stampdata.year);
//	tempDecade = tempDecade.substr(0, 3) + "0";
//	currentDecade = int(tempDecade);
//	currentSerieName = stampdata.serie;
//	currentStampID = stampdata.number;
//	currentYear = stampdata.year;
//	// check to see if current type is a new one
//	var newOne:Boolean = true;
//	for (var i:int = 0; i < types.length; i++)
//	{
//		var typename:String = types[i];
//		if (stampdata.type == typename)
//		{
//			newOne = false;
//		}
//	}
//	if (newOne == true)
//	{
//		types.push(stampdata.type);
//		currentType = types.length - 1;
//	}
//	// check to see if current country is a new one
//	newOne = true;
//	for (var j:int = 0; j < oldCountries.length; j++)
//	{
//		var countryname:String = oldCountries[j];
//		if (stampdata.country == countryname)
//		{
//			newOne = false;
//		}
//	}
//	if (newOne == true)
//	{
//		oldCountries.push(stampdata.country);
//		currentCountry = oldCountries.length - 1;
//	}
//	insertStampInDatabase(stampdata);
//	// TODO : loadIndexes();
////			stampArray = getStampsForCountryAndType("", "");
////			if (stampArray.length > 1)
////			{
//	/// if country already exists
////				eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.STAMPINFO_UPDATED));
//	eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.STAMP_ADDED));
////			}
////			else
////			{
//	/// else country is new
////				eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.STAMPINFO_UPDATED));
////				changeCountry();
//	//TODO : loadIndexes();
////			}
//	var checkStatesFlag:uint = StampDatabase.COUNTRY_CHANGED | StampDatabase.TYPE_CHANGED;
//	if (checkChanges(StampInfoChangedState, checkStatesFlag))
//	{
//		createCountryImageDir();
//	}
//}