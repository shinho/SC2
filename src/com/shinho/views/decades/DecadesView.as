package com.shinho.views.decades
{

      import com.greensock.TweenMax;
      import com.shinho.models.FlexLayout;
      import com.shinho.util.AppDesign;
      import com.shinho.util.SpriteUtils;

      import flash.display.Sprite;
      import flash.events.MouseEvent;

      import org.osflash.signals.Signal;

      /**
       * ...
       * @author Nelson Alexandre
       */
      public class DecadesView extends Sprite
      {
            public var page:FlexLayout;
            private var _yearsHolder:Sprite;
            private var _buttonYear:DecadeButtonYear;
            private var _decadeButtons:Array = [];
            private var _isDisplayed:Boolean = false;
            //signals
            public var decadeSelectedSignal:Signal = new Signal( String );


            public function DecadesView()
            {
            }


            public function destroyDecades():void
            {
                  _decadeButtons.length = 0;
                  _buttonYear = null;
                  _isDisplayed = false;
                  SpriteUtils.removeAllChild( _yearsHolder );
            }


            public function displayDecades( decades:Array, currentDecade:String ):void
            {
                  if ( _isDisplayed )
                  {
                        destroyDecades();
                  }

                  _yearsHolder.y = page.header;
                  for ( var i:int = 0; i < decades.length; i++ )
                  {
                        _buttonYear = new DecadeButtonYear( decades[i] );
                        _yearsHolder.addChild( _buttonYear );
                        _decadeButtons.push( _buttonYear );
                        _buttonYear.y = i * AppDesign.BUTTON_DECADE_HEIGHT;
                        _buttonYear.buttonMode = true;
                        _buttonYear.addEventListener( MouseEvent.CLICK, decadeSelected );
                  }
                  setSelectedCurrentDecade( currentDecade );
                  _isDisplayed = true;
            }


            public function init():void
            {
                  var darkArea:Sprite = new QuadSWC();
                  this.addChild( darkArea );
                  TweenMax.to( darkArea, 0, {alpha: 0.4} );
                  page.add( darkArea, page.LEFT, 0, page.NONE, page.header + 1, page.NONE, 50, page.TALL,
                          -page.header + 1 - 40 );

                  _yearsHolder = new Sprite();
                  addChild( _yearsHolder );
                  page.forceResize();
            }


            public function setSelectedCurrentDecade( currentDecade:String ):void
            {
                  for ( var i:int = 0; i < _decadeButtons.length; i++ )
                  {
                        var decade:DecadeButtonYear = _decadeButtons[i] as DecadeButtonYear;
                        if ( decade.decade == currentDecade )
                        {
                              decade.setSelected();
                        }
                        else
                        {
                              decade.setDeselected();
                        }
                  }
            }


            private function decadeSelected( event:MouseEvent ):void
            {
                  decadeSelectedSignal.dispatch( event.currentTarget.decade );
            }
      }
}