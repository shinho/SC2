/**
 * Created with IntelliJ IDEA.
 * User: Alexi7
 * Date: 21-01-2013
 * Time: 23:59
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.models {

import com.shinho.events.StampsDatabaseEvents;

import flash.utils.Dictionary;

import org.robotlegs.mvcs.Actor;

public class FieldEntriesModel extends Actor {

	public static const SELLER:String = "seller";
	public static const VARIETY:String = "variety";
	public static const MAIN_CATALOG:String = "main_catalog";
	public static const PRINTER:String = "printer";
	public static const TYPE:String = "type";
	public static const COUNTRY:String = "country";
	public static const SERIE:String = "serie";
	public static const PAPER:String = "paper";
	public static const COLOR:String = "color";
	public static const DESIGNER:String = "designer";
	[Inject]
	public var db:StampDatabase;
	private var _fieldsEntries:Dictionary = new Dictionary();


	public function FieldEntriesModel() {
	}



	public function getEntries(field:String):Dictionary {
		return _fieldsEntries[field];
	}


	public function createEntriesIndexes():void {
		trace("FieldEntriesModel: Loading database field entries")
		_fieldsEntries[SELLER] = db.getFieldsEntries("seller");
		_fieldsEntries[VARIETY] = db.getFieldsEntries("variety");
		_fieldsEntries[MAIN_CATALOG] = db.getFieldsEntries("main_catalog");
		_fieldsEntries[PRINTER] = db.getFieldsEntries("printer");
		_fieldsEntries[TYPE] = db.getFieldsEntries("type");
		_fieldsEntries[COUNTRY] = db.getFieldsEntries("country");
		_fieldsEntries[SERIE] = db.getFieldsEntries("serie");
		_fieldsEntries[DESIGNER] = db.getFieldsEntries("designer");
		_fieldsEntries[PAPER] = db.getFieldsEntries("paper");
		_fieldsEntries[COLOR] = db.getFieldsEntries("color");
		// TODO : TURN THIS INTO A SIGNAL OR DISABLE IF NOT NEEDED
		eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.INDEXES_UPDATED));
	}
}
}
