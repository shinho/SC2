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

import org.osflash.signals.Signal;


/**
 * ...
 * @author ...
 */
public class MessageBox extends Sprite
{
    public var board:MovieClip;
    public var page:FlexLayout;
    public static const TYPE_YES_NO:String = 'messageBoxTypeYesNo';
    public static const RESPONSE_YES:String = 'yes_selected';
    public static const RESPONSE_NO:String = 'no_selected';
    private var _backLeft:Sprite;
    private var _question:String;
    private var _title:String;
    private var _typeBox:String;

    public var responseSignal:Signal = new Signal( String );


    public function MessageBox( typeBox:String, title:String = null, question:String = null  )
    {
        _typeBox = typeBox;
        _title = title;
        _question = question;
        this.addEventListener( Event.ADDED_TO_STAGE, init );
    }


    public function destroy():void
    {
        SpriteUtils.removeAllChild( board );
        removeChild( _backLeft );
        _backLeft = null;
        board = null;
    }


    public function display():void
    {
        // creates background and animates
        _backLeft = SpriteUtils.drawQuad( 0, 0, page.wide, page.tall );
        addChild( _backLeft );
        page.add( _backLeft, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60 );
        TweenMax.to( _backLeft, 0, {tint: 0x111111, x: -page.wide} );
        TweenMax.to( _backLeft, 1.3, {x: 0, alpha: 0.90, ease: Expo.easeOut} );
        page.forceResize();
        switch ( _typeBox )
        {
            case MessageBox.TYPE_YES_NO:
                boxYesNo();
                break;
        }
    }


    public function setTitleQuestion( title:String, question:String ):void
    {
        this._title = title;
        this._question = question;
    }


    private function boxYesNo():void
    {
        // creates boards and center it on screen
        board = new MessageBox_SWC();
        addChild( board );
        page.add( board, page.CENTERX, -(board.width / 2), page.CENTERY, -(board.height / 2), page.NONE, 0,
                page.NONE, 0 );
        //pass information to the board
        board.title.text = _title + "";
        board.question.text = _question + "";
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
        responseSignal.dispatch( RESPONSE_YES );
    }


    private function selectedNo( e:MouseEvent ):void
    {
        board.btNo.removeEventListener( MouseEvent.CLICK, selectedNo );
        responseSignal.dispatch( RESPONSE_NO );
    }
}
}