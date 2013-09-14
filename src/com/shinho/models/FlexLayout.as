package com.shinho.models
{
	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	// Robotlegs
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;

	import org.robotlegs.mvcs.Actor;


	public class FlexLayout extends Actor
	{
		//private properties
		public var actualHeight:int = 0;
		public var actualWidth:int = 0;
		public const NONE:String = "none";
		public const TOP:String = "top";
		public const BOTTOM:String = "bottom";
		public const LEFT:String = "left";
		public const RIGHT:String = "right";
		public const WIDE:String = "string";
		public const TALL:String = "tall";
		public const MARGIN_RIGHT:String = "margin_right";
		//public properties
		public const MARGIN_LEFT:String = "margin_left";
		public const HEADER:String = "headerline";
		public const FOOTER:String = "footerline";
		public const CENTERX:String = "centerx";
		public const CENTERY:String = "centery";
		public const BODY:String = "body";
		public const PERCENT:String = "percent";
		public const RATIO:String = "ratio";
		private static var isDefined:Boolean = false;
		private static var _header:Number;
		private static var _footer:Number;
		private static var _marginLeft:Number;
		private static var _marginRight:Number;
		private static var _minWidth:Number;
		private static var _minHeight:Number;
		private static var _delay:Number = 0;
		private static var _wait:Number = 0;
		private static var elements:Array = new Array;


		public function FlexLayout()
		{
			super();
		}


		public function add( clipName:Object, xx:String, offset_x:Number, yy:String, offset_y:Number, ww:String,
		                     offset_w:Number, hh:String, offset_h:Number ):void
		{
			var pass:Array = new Array( clipName, xx, offset_x, yy, offset_y, ww, offset_w, hh, offset_h );
			elements.push( pass );
		}


		public function defineStage( header:Number, footer:Number, marginLeft:Number, marginRight:Number,
		                             minWidth:Number, minHeight:Number ):void
		{
			_header = header;
			_footer = footer;
			_marginLeft = marginLeft;
			_marginRight = marginRight;
			_minWidth = minWidth;
			_minHeight = minHeight;
			isDefined = true;
		}


		//  ----------------------------------                         GETTERS AND SETTERS

		public function forceResize():void
		{
			onResize();
		}


		public function ok():void
		{
			trace( "flexlayout accessible" );
		}


		public function setActualStage( width:int, height:int ):void
		{
			actualWidth = width;
			actualHeight = height;
		}


		private function getStrenghtLine( eval:String ):Number
		{
			var retVal:Number = 0;
			switch ( eval )
			{
				case CENTERX:
					retVal = centerX;
					break;
				case CENTERY:
					retVal = centerY;
					break;
				case WIDE:
					retVal = wide;
					break;
				case RIGHT:
					retVal = wide;
					break;
				case TALL:
					retVal = tall;
					break;
				case HEADER:
					retVal = header;
					break;
				case FOOTER:
					retVal = footer;
					break;
				case BODY:
					retVal = body;
					break;
				case TOP:
					retVal = top;
					break;
				case BOTTOM:
					retVal = bottom;
					break;
				case LEFT:
					retVal = 0;
					break;
				case MARGIN_LEFT:
					retVal = _marginLeft;
					break;
				case MARGIN_RIGHT:
					retVal = wide - _marginRight;
					break;
				case NONE:
					retVal = -1;
					break;
			}
			return retVal;
		}


		private function onResize():void
		{
			for ( var i:int = 0; i <= elements.length - 1; i++ )
			{
				var clip:Object = elements[i][0];
				var strenghtLineX:String = elements[i][1];
				var offsetX:Number = elements[i][2];
				var strenghtLineY:String = elements[i][3];
				var offsetY:Number = elements[i][4];
				var strenghtLineW:String = elements[i][5];
				var offsetW:Number = elements[i][6];
				var strenghtLineH:String = elements[i][7];
				var offsetH:Number = elements[i][8];
				var x_value:Number = 0;
				var y_value:Number = 0;
				var w_value:Number = 0;
				var h_value:Number = 0;
				if ( strenghtLineX == PERCENT )
				{
					x_value = wide * (offsetX / 100);
				}
				else
				{
					x_value = getStrenghtLine( strenghtLineX ) + offsetX;
				}
				if ( strenghtLineY == PERCENT )
				{
					y_value = tall * (offsetY / 100);
				}
				else
				{
					y_value = getStrenghtLine( strenghtLineY ) + offsetY;
				}
				if ( strenghtLineH == PERCENT )
				{
					h_value = tall * (offsetH / 100);
				}
				else
				{
					h_value = getStrenghtLine( strenghtLineH ) + offsetH;
				}
				if ( strenghtLineW == RATIO )
				{
					w_value = h_value * offsetW;
				}
				else
				{
					if ( strenghtLineW == PERCENT )
					{
						w_value = wide * (offsetW / 100);
					}
					else
					{
						w_value = getStrenghtLine( strenghtLineW ) + offsetW;
					}
				}
				position( clip, x_value, y_value, w_value, h_value );
			}
		}


		private function position( obj:Object, xx:Number, yy:Number, ww:Number, hh:Number ):void
		{
			var tempX:Number = obj.x;
			if ( xx >= 0 )
			{
				tempX = xx;
			}
			var tempY:Number = obj.y;
			if ( yy >= 0 )
			{
				tempY = yy;
			}
			var tempW:Number = obj.width;
			if ( ww >= 0 )
			{
				tempW = ww;
			}
			var tempH:Number = obj.height;
			if ( hh >= 0 )
			{
				tempH = hh;
			}
			TweenMax.to( obj, _delay,
			             {x: tempX, y: tempY, width: tempW, height: tempH, delay: _wait, ease: Quint.easeOut} );
		}


		public function get top():Number
		{
			return 0;
		}


		public function get bottom():Number
		{
			return tall;
		}


		public function get tall():Number
		{
			var actualHeight:Number = actualHeight;
			if ( actualHeight < _minHeight )
			{
				return _minHeight;
			}
			else
			{
				return actualHeight;
			}
		}


		public function get wide():Number
		{
			var actualWidth:Number = actualWidth;
			if ( actualWidth < _minWidth )
			{
				return _minWidth;
			}
			else
			{
				return actualWidth;
			}
		}


		public function get centerX():Number
		{
			return wide / 2;
		}


		public function get centerY():Number
		{
			return tall / 2;
		}


		public function get header():Number
		{
			return _header;
		}


		public function get footer():Number
		{
			return tall - _footer;
		}


		public function get ratio():Number
		{
			return tall / wide;
		}


		public function get body():Number
		{
			return tall - _footer - _header;
		}


		public function get marginLeft():Number
		{
			return _marginLeft;
		}


		public function get marginRight():Number
		{
			return _marginRight;
		}


		public function set repositionDelay( d:Number ):void
		{
			_delay = d;
		}
	}
}