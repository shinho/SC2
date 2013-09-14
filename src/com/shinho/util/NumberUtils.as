package com.shinho.util {
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class NumberUtils {
		// -----------------------------------------------------------------------   STATIC VARS
		public static const RESTRICT_NUMBERS_AND_DOT : String = "0-9 \.";

		// -----------------------------------------------------------------------   CLASS INIT
		public function NumberUtils() {
			super();
		}

		// ------------------------------------------------------------------------------------- CALCULATE PERCENT
		public static function calculatePositivePercent(part:Number, total:Number):String {
			var percent:String = "";
			if (total > 0 && part > 0){
				percent = Formatter.decimals((part / (total) * 100), 2, true, ".") + "%";
			} 
			return percent;
		}

		public static function formatDecimals(number : *, maxDecimals : int = 2, forceDecimals : Boolean = false, siStyle : String = ".", milSep : String = "") : String {
			var i : int = 0;
			var inc : Number = Math.pow(10, maxDecimals);
			var str : String = String(Math.round(inc * Number(number)) / inc);
			var hasSep : Boolean = str.indexOf(".") == -1, sep : int = hasSep ? str.length : str.indexOf(".");
			var ret : String = (hasSep && !forceDecimals ? "" : siStyle) + str.substr(sep + 1);
			if (forceDecimals) {
				for (var j : int = 0; j <= maxDecimals - (str.length - (hasSep ? sep - 1 : sep)); j++)
					ret += "0";
			}
			while (i + 3 < (str.substr(0, 1) == "-" ? sep - 1 : sep))
				ret = milSep + str.substr(sep - (i += 3), 3) + ret;
			return str.substr(0, sep - i) + ret;
		}
	}
}