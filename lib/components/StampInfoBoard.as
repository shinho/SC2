package
{

	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	public class StampInfoBoard extends StampInfoBoardSWC
	{

//		public var country:TextField;
//		public var color:TextField;
//		public var type:TextField;
//		public var id:TextField;
//		public var designer:TextField;
//		public var history:TextField;
//		public var inscription:TextField;
//		public var paper:TextField;
//		public var serie:TextField;
//		public var printer:TextField;
//		public var seller:TextField;
//		public var perforation:TextField;
//		public var variety:TextField;
//		public var watermark:TextField;
//		public var catalog:TextField;
//		public var comments:TextField;
//		public var cancel:TextField;
//		public var faults:TextField;
//		public var denomination:TextField;
//		public var currentValue:TextField;
//		public var cost:TextField;


		public static const RESTRICT_NUMBERS_AND_DOT:String = "0-9 \.";


		public function StampInfoBoard()
		{
			// constructor code
			trace( "StampInfoBoardSWC initiated ---------------------------------------------------" );
			country.restrict = "^'";
			color.restrict = "^'";
			type.restrict = "^'";
			id.restrict = "a-z0-9";
			designer.restrict = "^'";
			history.restrict = "^'";
			inscription.restrict = "^'";
			paper.restrict = "^'";
			serie.restrict = "^'";
			printer.restrict = "^'";
			seller.restrict = "^'";
			perforation.restrict = "^'";
			variety.restrict = "^'";
			watermark.restrict = "^'";
			catalog.restrict = "^'";
			comments.restrict = "^'";
			cancel.restrict = "^'";
			faults.restrict = "^'";
			denomination.restrict = "^'";
			currentValue.restrict = RESTRICT_NUMBERS_AND_DOT;
			cost.restrict = RESTRICT_NUMBERS_AND_DOT;

			id.addEventListener( KeyboardEvent.KEY_UP, preventMoreLetters );

			denomination.addEventListener( FocusEvent.FOCUS_IN, zero2Empty );
			currentValue.addEventListener( FocusEvent.FOCUS_IN, zero2Empty );
			cost.addEventListener( FocusEvent.FOCUS_IN, zero2Empty );

			currentValue.addEventListener( KeyboardEvent.KEY_DOWN, preventAnotherDecimalPoint );
			cost.addEventListener( KeyboardEvent.KEY_DOWN, preventAnotherDecimalPoint );

		}


		private function preventMoreLetters( e:KeyboardEvent ):void
		{
			var searchLetters:RegExp = (/\w+/);
			var checkStr:String = e.target.text.match( searchLetters );
			if ( isNaN( Number( checkStr ) ) )
			{
				e.target.restrict = "";
			}
			else
			{
				e.target.restrict = "a-z0-9";
			}
//                  enableButton( board.btSave );
		}


		private function zero2Empty( e:FocusEvent ):void
		{
			if ( e.target.text == "0" || e.target.text == "0.00" || e.target.text == "0.000" )
			{
				e.target.text = "";
			}
		}


		private function preventAnotherDecimalPoint( e:KeyboardEvent ):void
		{
			var temp:String = e.target.text;
			var existsDecimal:Boolean = false;
			for ( var i:int = 0; i < temp.length; i++ )
			{
				if ( temp.charAt( i ) == "." )
				{
					existsDecimal = true;
				}
			}
			if ( existsDecimal && (e.keyCode == 110 || e.keyCode == 190) )
			{
				e.preventDefault();
			}
		}


	}

}
