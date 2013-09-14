/**
 * Created with IntelliJ IDEA.
 * User: Alexi7
 * Date: 02-02-2013
 * Time: 18:03
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.models {

import com.shinho.models.dto.TypesDTO;

import org.robotlegs.mvcs.Actor;


public class TypesModel extends Actor {

	[Inject]
	public var db:StampDatabase;
	private var _currentTypeIndex:uint = 0;
	private var _currentTypeName:String = "";
	private var _hasTypes:Boolean = false;
	private var _types:Vector.<TypesDTO>;


	public function TypesModel()
	{
	}


	public function getTypesForCountry(countryName:String):void
	{
		trace("TypesModel: get types for country", countryName);
		_types = Vector.<TypesDTO>(db.getStampTypesForCountry(countryName));
		if (_types.length > 0) {
			_hasTypes = true;
		}
	}


	public function getCurrentTypeName():String
	{
		return _types[_currentTypeIndex].type;
	}


	public function getStampTypes():Vector.<TypesDTO>
	{
		return _types;
	}


	public function get currentTypeIndex():uint
	{
		return _currentTypeIndex;
	}


	public function get hasTypes():Boolean
	{
		return _hasTypes;
	}


	public function set currentTypeIndex(value:uint):void
	{
		_currentTypeIndex = value;
	}
}
}
