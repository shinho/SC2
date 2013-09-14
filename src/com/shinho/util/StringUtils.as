package com.shinho.util
{

	import com.shinho.models.dto.StampDTO;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class StringUtils
	{

		public static const RESTRICT_NUMBERS_AND_DOT:String = "0-9 \.";


		public function StringUtils()
		{
			super();
		}


		public static function stripZeros(zeroString:String):String
		{
			while (zeroString.charAt(0) == "0")
			{
				zeroString = zeroString.substring(1, zeroString.length);
			}
			return zeroString;
		}


		// thanks to TharosTheDragon

		public static function padString(string:String, padChar:String, finalLength:int, padLeft:Boolean = true):String
		{
			while (string.length < finalLength)
			{
				string = padLeft ? padChar + string : string + padChar;
			}
			return string;
		}


		public static function stringToBoolean(state:String):Boolean
		{
			var bool:Boolean = false;
			if (state == "true")
			{
				bool = true;
			}
			return bool;
		}


		public static function stringToInt(value:String):int
		{
			var convertedInt:int = 0;
			if (value != null && value != "")
			{
				convertedInt = int(value);
			}
			return convertedInt;
		}


		public static function stringToNumber(value:String):Number
		{
			var convertedInt:Number = 0;
			if (value != null)
			{
				convertedInt = Number(value);
			}
			return convertedInt;
		}


		public static function isNull(string2Check:String):String
		{
			var checkedString:String;
			if (string2Check === null)
			{
				checkedString = "";
			}
			else
			{
				checkedString = string2Check;
			}
			return checkedString;
		}


		public static function paddedNumberedArray(numberedArray:Vector.<StampDTO>,
		                                           totalDigits:uint = 8):Vector.<StampDTO>
		{
			/// sort array based on denomination and then number
			for (var i:int = 0; i < numberedArray.length; i++)
			{
				var strNumber:String = numberedArray[i].number;
				var count:int = strNumber.length;
				var letter:String = "!";
				if (strNumber.charAt(count - 1) > "9")
				{
					letter = strNumber.charAt(count - 1);
					strNumber = strNumber.substring(0, count - 1);
				}
				numberedArray[i].number = padString(strNumber + letter, "0", totalDigits);
			}
			return numberedArray;
		}


		public static function stripPaddedArray(paddedArray:Vector.<StampDTO>):Vector.<StampDTO>
		{
			for (var i:int = 0; i < paddedArray.length; i++)
			{
				var strNumber:String = paddedArray[i].number;
				var count:int = strNumber.length;
				if (strNumber.charAt(count - 1) == "!")
				{
					strNumber = strNumber.substring(0, count - 1);
				}
				paddedArray[i].number = stripZeros(strNumber);
			}
			return paddedArray;
		}


		// ------------------------------------------------------------------------------------- PREVENT MORE LETTERS
		/*		public static function preventMoreLetters(e:KeyboardEvent):void
		 {
		 var searchLetters:RegExp = (/\w+/);
		 var checkStr:String = e.target.text.match(searchLetters);
		 if (isNaN(Number(checkStr)))
		 {
		 e.target.restrict = "";
		 }
		 else
		 {
		 e.target.restrict = "a-z0-9";
		 }
		 enableButton(board.btSave);
		 }*/
	}
}