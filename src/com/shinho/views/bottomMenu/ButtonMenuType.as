package com.shinho.views.bottomMenu
{

      import flash.display.MovieClip;
      import flash.events.MouseEvent;

      import com.greensock.TweenMax;

      /**
       * ...
       * @author Nelson Alexandre
       */
      public class ButtonMenuType extends MovieClip
      {

            public static var ADD_FIRST:int = 1;
            public static var CHANGE_COUNTRY:int = 2;
            public static var STATISTICS:int = 3;
            private var _button:MovieClip;


            public function ButtonMenuType( type:int )
            {
                  super();

                  switch ( type )
                  {
                        case 1 :
                              _button = new btAddFirstSWC();
                              break;
                        case 2:
                              _button = new btChangeCountrytSWC();
                              break;
                        case 3:
                              _button = new btStatisticSWC();
                              break;
                        default :
                              break;
                  }
                  addChild( _button );
                  _button.buttonMode = true;
                  _button.addEventListener( MouseEvent.MOUSE_OVER, onOver );
                  _button.addEventListener( MouseEvent.MOUSE_OUT, onOut );
            }


            private function onOver( e:MouseEvent ):void
            {
                  TweenMax.to( _button.iconOver, 0.4, { alpha: 1 } );
                  TweenMax.to( _button.legend, 0.4, { tint: 0xffffff } );

            }


            private function onOut( e:MouseEvent ):void
            {
                  TweenMax.to( _button.iconOver, 0.4, { alpha: 0 } );
                  TweenMax.to( _button.legend, 0.4, { tint: 0x999999 } );
            }


            public function changeLabel( label:String ):void
            {
                  _button.legend.text = label;
            }
      }
}