package com.shinho.util
{

	import flash.utils.ByteArray;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class ArrayUtils
	{

		public function ArrayUtils()
		{
			super();
		}


		public static function clone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return (myBA.readObject());
		}
	}
}