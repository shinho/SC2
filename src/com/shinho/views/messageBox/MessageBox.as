package com.shinho.views.messageBox
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.shinho.models.FlexLayout;
	import com.shinho.util.SpriteUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * ...
	 * @author ...
	 */
	public class MessageBox extends Sprite
	{
		public var board:MovieClip;
		public var page:FlexLayout;
		public static const YES_NO:String = 'messageBoxTypeYesNo';
		private var backLeft:Sprite;
		private var question:String;
		private var title:String;
		private var typeBox:String;


		public function MessageBox( typeBox:String )
		{
			this.typeBox = typeBox;
			this.addEventListener( Event.ADDED_TO_STAGE, init );
		}


		public function destroy():void
		{
			///board.btYes.removeEventListener(MouseEvent.CLICK, selectedYes);
			///board.btNo.removeEventListener(MouseEvent.CLICK, selectedNo);
			SpriteUtils.removeAllChild( board );
			removeChild( backLeft );
			backLeft = null;
			board = null;
		}


		public function display():void
		{
			// cretes background and animates
			backLeft = SpriteUtils.drawQuad( 0, 0, page.wide, page.tall );
			addChild( backLeft );
			page.add( backLeft, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60 );
			TweenMax.to( backLeft, 0, {tint: 0x111111, x: -page.wide} );
			TweenMax.to( backLeft, 1.3, {x: 0, alpha: 0.90, ease: Expo.easeOut} );
			page.forceResize();
			switch ( typeBox )
			{
				case MessageBox.YES_NO:
					boxYesNo();
					break;
			}
		}


		public function setTitleQuestion( title:String, question:String ):void
		{
			this.title = title;
			this.question = question;
		}


		private function boxYesNo():void
		{
			// cretes boards and center it on screen
			board = new MessageBox_SWC();
			addChild( board );
			page.add( board, page.CENTERX, -(board.width / 2), page.CENTERY, -(board.height / 2), page.NONE, 0,
			          page.NONE, 0 );
			//pass information to the board
			board.title.text = title;
			board.question.text = question;
			//refresh display
			page.forceResize();
			board.btYes.addEventListener( MouseEvent.CLICK, selectedYes, false, 0, true );
			board.btNo.addEventListener( MouseEvent.CLICK, selectedNo, false, 0, true );
		}


		private function init( e:Event ):void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, init );
		}


		private function selectedYes( e:MouseEvent ):void
		{
			board.btYes.removeEventListener( MouseEvent.CLICK, selectedYes );
			dispatchEvent( new MessageBoxEvent( MessageBoxEvent.OPTION_SELECTED, MessageBoxEvent.YES ) );
		}


		private function selectedNo( e:MouseEvent ):void
		{
			board.btNo.removeEventListener( MouseEvent.CLICK, selectedNo );
			dispatchEvent( new MessageBoxEvent( MessageBoxEvent.OPTION_SELECTED, MessageBoxEvent.NO ) );
		}
	}
}