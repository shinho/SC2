package com.shinho.views.pictureStripe.thumb
{
	import com.greensock.TweenMax;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.util.Color;
	import com.shinho.util.Shapes;
	import com.shinho.util.SpriteUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import org.osflash.signals.Signal;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class Thumb extends Sprite
	{
		public var enlargedThumb:Bitmap;
		public var number:String;
		public var thumbID:ThumbID;
		public var thumbLoadedSignal:Signal = new Signal( Thumb );
		private static const THUMB_HEIGHT:uint = 60;
		private var _hasImage:Boolean;
		private var _imageHolder:Sprite;
		private var _noPic:Sprite;
		private var _path:String;
		private var _reScaledThumb:Bitmap;
		private var _stamp:StampDTO;
		private var _thumbIsEnlarged:Boolean = false;
		private var enlargedThumbHolder:Sprite;


		public function Thumb( stamp:StampDTO, path:String )
		{
			_stamp = stamp;
			_path = path;
			addEventListener( Event.ADDED_TO_STAGE, startDisplay );
		}


		public function destroy():void
		{
			if ( _hasImage )
			{
				_reScaledThumb.bitmapData.dispose();
			}
			else
			{
				SpriteUtils.removeAllChild( thumbID );
				removeChild( thumbID );
				thumbID = null;
			}

			_reScaledThumb = null;
			_imageHolder = null;
			thumbID = null;

			removeEventListener( MouseEvent.MOUSE_OVER, onOver );
			removeEventListener( MouseEvent.MOUSE_OUT, onOut );
		}


		public function loadThumbImage( path:String ):void
		{
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest( path + ".jpg" );
			loader.load( urlRequest );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, imageLoaded, false, 0, false );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError, false, 0, false );
		}


		private static function reScaleImage( bitmap:Bitmap, scaleWidth:Number, scaleHeight:Number, newWidth:int,
		                                      newHeight:int ):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.scale( scaleWidth, scaleHeight );
			var bitmapData:BitmapData = new BitmapData( newWidth, newHeight, false );
			bitmapData.draw( bitmap, matrix, null, null, null, true );
			return bitmapData;
		}


		private static function moveToTop( clip:DisplayObject ):void
		{
			clip.parent.setChildIndex( clip, clip.parent.numChildren - 1 );
		}


		private function createThumbId():void
		{
			thumbID = new ThumbID();
			thumbID.ID.text = _stamp.number;
			addChild( thumbID );
			thumbID.barratop.buttonMode = true;
			thumbID.y = THUMB_HEIGHT;

			thumbID.ID.textColor = _stamp.owned ? Color.WHITE : Color.DARK_GREY;

			thumbID.addEventListener( MouseEvent.MOUSE_OVER, enlargeThumb );
			thumbID.addEventListener( MouseEvent.MOUSE_OUT, reduceThumb );
		}


		private function reScaleWidths():void
		{
			thumbID.barra.width = _imageHolder.width;
			thumbID.barratop.width = _imageHolder.width;
			thumbID.ID.width = _imageHolder.width;
		}


		public function onOut( e:MouseEvent ):void
		{
			TweenMax.to( thumbID.barra, 0.3, { tint: Color.BLACK } );
		}


		public function onOver( e:MouseEvent ):void
		{
			TweenMax.to( thumbID.barra, 0.3, { tint: Color.BRIGHT_BLUE } );
		}


		private function reduceThumb( e:Event ):void
		{
			if ( _thumbIsEnlarged && _hasImage )
			{
				SpriteUtils.removeAllChild( enlargedThumbHolder );
				removeChild( enlargedThumbHolder );
				_thumbIsEnlarged = false;
			}
		}


		private function startDisplay( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, startDisplay );

			addEventListener( MouseEvent.MOUSE_OVER, onOver );
			addEventListener( MouseEvent.MOUSE_OUT, onOut );

			buttonMode = true;
			_hasImage = false;

			_imageHolder = new Sprite();
			addChild( _imageHolder );

			_noPic = new NoPicSWC();
			_imageHolder.addChild( _noPic );

			createThumbId();

			loadThumbImage( _path );
		}


		private function enlargeThumb( e:Event ):void
		{
			var margin:int = 4;
			if ( !_thumbIsEnlarged && _hasImage )
			{
				enlargedThumbHolder = Shapes.drawRoundBox( 0, 0, enlargedThumb.width + margin * 2,
				                                           enlargedThumb.height + margin * 2, 5, 1, Color.DARK_GREY,
				                                           Color.BLACK );
				addChild( enlargedThumbHolder );
				enlargedThumbHolder.y = THUMB_HEIGHT + thumbID.height + 5;
				enlargedThumbHolder.addChild( enlargedThumb );
				enlargedThumb.alpha = 0;
				enlargedThumb.x = enlargedThumb.y = margin;

				moveToTop( enlargedThumbHolder );
				_thumbIsEnlarged = true;
				TweenMax.to( enlargedThumb, .6, { alpha: 1 } );
			}
		}


		private function imageLoaded( e:Event ):void
		{
			var loadedBitmap:Bitmap = (Bitmap)( e.target.content );
			_imageHolder.removeChild( _noPic );
			var ratio:Number = loadedBitmap.width / loadedBitmap.height;

			var thumbWidth:int = int( THUMB_HEIGHT * ratio );

			// -------- calculating smalll bitmap
			var reScaledBitmap:BitmapData = reScaleImage( loadedBitmap, thumbWidth / loadedBitmap.width,
			                                              THUMB_HEIGHT / loadedBitmap.height, thumbWidth,
			                                              THUMB_HEIGHT );
			_reScaledThumb = new Bitmap( reScaledBitmap );
			_imageHolder.addChild( _reScaledThumb );
			// -------- calculating amplified thumb
			var amplification:Number = 3;
			var amplifiedBitmap:BitmapData = reScaleImage( loadedBitmap,
			                                               thumbWidth / loadedBitmap.width * amplification,
			                                               THUMB_HEIGHT / loadedBitmap.height * amplification,
			                                               thumbWidth * amplification, THUMB_HEIGHT * amplification );
			enlargedThumb = new Bitmap( amplifiedBitmap );

			if ( !_stamp.owned )
			{
				_reScaledThumb.alpha = 0.15;
			}

			_hasImage = true;

			reScaleWidths();

			thumbLoadedSignal.dispatch( this );
		}


		private function onIOError( e:IOErrorEvent ):void
		{
			_hasImage = false;
			thumbLoadedSignal.dispatch( this );
		}


		public function get stamp():StampDTO
		{
			return _stamp;
		}


		public function set stamp( newStampData:StampDTO ):void
		{
			if (newStampData.id == _stamp.id )
			{
				_stamp = newStampData;
			}
		}
	}
}