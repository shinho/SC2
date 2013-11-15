package com.shinho.views
{

      import com.shinho.models.FlexLayout;
      import com.shinho.models.dto.SeriesDTO;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.util.AppDesign;
      import com.shinho.util.SpriteUtils;
      import com.shinho.views.bottomMenu.BottomMenu;
      import com.shinho.views.components.CountryNameView;
      import com.shinho.views.decades.DecadesView;
      import com.shinho.views.pictureStripe.SeriesStripeView;
      import com.shinho.views.slider.VerticalSlider;
      import com.shinho.views.types.TypesMenu;

      import flash.display.MovieClip;
      import flash.display.Sprite;
      import flash.events.Event;

      /**
       * ...
       * @author Nelson Alexandre
       */
      public class ApplicationMainView extends Sprite
      {

            [Inject]
            public var page:FlexLayout;
            // public properties
            public var bar:Sprite = new MenuBarSWC();
            public var currentStamp:StampDTO;
            public var stampsDisplayed:Boolean = false;
            // private properties
            private static const MINIMUM_STRIPES:uint = 10;
            private var _allStripes:Sprite;
            private var _allStripesMask:Sprite;
            private var _verticalSlider:VerticalSlider;
            private var _logo:MovieClip = new LogotipoSWC();
            private var _selos:MovieClip = new Selos_SWC();
            private var _background:MovieClip = new BackgroundSWC();
            private var _bottomMenu:BottomMenu;
            private var _btCountry:CountryNameView = new CountryNameView();
            private var _totalStripes:int;
            private var _currentStripeIndex:int;
            private var _stripesTotalHeight:Number;
            private var _seriesStripes:Vector.<SeriesStripeView>;
            private var _numberOfStampSeries:uint = 0;
            private var _stampSeries:Vector.<SeriesDTO>;
            private var decadeYears:DecadesView = new DecadesView();
            private var typesMenu:TypesMenu = new TypesMenu();
            private var _usableHeight:Number;


            public function ApplicationMainView()
            {
                  addChild( _background );
                  addChild( _selos );
                  addChild( _logo );
                  addChild( bar );
                  changeBuild();
                  this.addEventListener( Event.ADDED_TO_STAGE, init );
            }


            // ----------------------------------------------------------------------------
            // PUBLIC methods
            // ----------------------------------------------------------------------------

            public function clearDisplay():void
            {
                  _allStripes.visible = false;
                  if ( stampsDisplayed == true )
                  {
                        for ( var i:int = 0; i < _seriesStripes.length; i++ )
                        {
                              try
                              {
                                    _seriesStripes[i].destroy();
                              }
                              catch ( e:Error )
                              {
                                    /// do nothing
                              }
                        }
                        SpriteUtils.removeAllChild( _allStripes );
                  }
                  stampsDisplayed = false;
                  _bottomMenu.stampsDisplayed = stampsDisplayed;
                  _stampSeries = null;
                  _seriesStripes = null;
                  _allStripes.visible = true;
            }


            public function displayCountryName( countryName:String ):void
            {
                  _btCountry.refreshCountryName( countryName );
                  typesMenu.x = _btCountry.x + _btCountry.width;
            }


            public function moveToDecade( decade:String ):void
            {
                  if ( stampsDisplayed )
                  {
                        var counter:uint = 0;
                        var foundStripe:Boolean = false;
                        while ( !foundStripe && counter <= _numberOfStampSeries - 1 )
                        {
                              var series:SeriesStripeView = _seriesStripes[counter];
                              if ( series.serieDecade == decade )
                              {
                                    foundStripe = true;
                              }
                              else
                              {
                                    counter++;
                              }
                        }
                        _currentStripeIndex = counter;
                        displayVisibleStripes();
                        moveStripeToTop( _seriesStripes[_currentStripeIndex] );
                  }
            }


            public function onResize():void
            {
                  if ( _verticalSlider )
                  {
                        _usableHeight = _allStripesMask.height;
                        _verticalSlider.newTrackHeight( _usableHeight );
                        var numVisibleStripes:int = (_usableHeight / AppDesign.STRIPE_HEIGTH) + 1;
                        var percent:Number = (_usableHeight / _stripesTotalHeight);
                        if ( _numberOfStampSeries > numVisibleStripes )
                        {
                              var sliderPixels:uint = int( _usableHeight * percent ) > 50 ? int( _usableHeight * percent ) : 50;
                              _verticalSlider.setHeight( sliderPixels );
                        }
                        else
                        {
                              _verticalSlider.setHeight( _usableHeight );
                        }
                        _verticalSlider.slider.x = page.wide - AppDesign.SLIDER_WIDTH;
                        _verticalSlider.slider.y = page.header;
                  }
            }


            public function prepareSeriesStripes( stampList:Vector.<StampDTO> ):void
            {
                  stampsDisplayed = false;
                  _bottomMenu.stampsDisplayed = stampsDisplayed;
                  _seriesStripes = Vector.<SeriesStripeView>( [] );
                  /// then sort every stripe using PictureStripe Class
                  _currentStripeIndex = 0;
                  for ( var i:int = 0; i < _numberOfStampSeries; i++ )
                  {
                        var _stripe:SeriesStripeView = new SeriesStripeView( _stampSeries[i].serieName,
                                _stampSeries[i].serieYear, i );
                        _allStripes.addChild( _stripe );
                        SpriteUtils.setPosition( _stripe, AppDesign.BUTTON_YEAR_DISPLACE,
                                (i * AppDesign.STRIPE_HEIGTH) + page.header );
                        _seriesStripes[i] = _stripe;
                  }
                  displayVisibleStripes();

                  _stripesTotalHeight = _numberOfStampSeries * AppDesign.STRIPE_HEIGTH;
                  _verticalSlider.contentHeight = _stripesTotalHeight;
                  onResize();
                  page.forceResize();
            }


            public function seriesChanged( newSeries:Vector.<SeriesDTO>, selectedSerieName:SeriesStripeView, previousSeries:StampDTO ):void
            {
                  trace( "newSerie: " + selectedSerieName + " | " + previousSeries );
                  var diff:int = newSeries.length - _seriesStripes.length;

                  for ( var i:int = 0; i < newSeries.length; i++ )
                  {
                        var added:Boolean = false;
                        var newSerie:SeriesDTO = newSeries[i];

                        try
                        {
                              var stripe:SeriesStripeView = _seriesStripes[i];
                              if ( stripe.serieName != newSerie.serieName || stripe.serieYear != newSerie.serieYear && stripe.serieName != null )
                              {
                                    trace( "different stripes: " + diff );
                                    if ( diff >= 1 )
                                    {
                                          trace( "insert stripe" );
                                          insertNewStripe( newSerie, i );
                                          added = true;
                                    }
                                    if ( diff <= -1 )
                                    {
                                          trace( "delete stripe" );
                                          deleteSerie( i )
                                    }
                                    ;
                                    if ( diff == 0 && i < newSeries.length - 1 )
                                    {
                                          trace( "same number of stripes" );
                                          // --------------  check to insert
                                          if ( stripe.serieName == newSeries[i + 1].serieName && stripe.serieYear == newSeries[i + 1].serieYear )
                                          {
                                                trace( "insert new stripe" );
                                                insertNewStripe( newSerie, i );
                                                added = true;
                                                diff = -1;
                                          }
                                          // --------------  check to delete
                                          if ( i + 1 <= _seriesStripes.length )
                                          {

                                                var pointer:uint = i + 1;
                                                if ( _seriesStripes[pointer].serieName == newSerie.serieName && _seriesStripes[pointer].serieYear == newSerie.serieYear )
                                                {
                                                      trace( "delete stripe" );
                                                      deleteSerie( i );
                                                      diff = 1;
                                                }
                                          }
                                    }
                              }
                              // --------------  check to update previous stripe
                              if ( (stripe.serieName == previousSeries.serie && stripe.serieYear == previousSeries.year) || (stripe.serieName == selectedSerieName.serieName && stripe.serieYear == selectedSerieName.serieYear) )
                              {
                                    if ( !added )
                                    {
                                          trace( "update previous stripe" );
                                          _seriesStripes[i].refreshStripe( newSerie.serieStamps, i.toString() );
                                          added = false;
                                    }
                              }
                        }
                        catch ( e:Error )
                        {
                              /// if new series is bigger it's a new element at the end of existing stripes
                              if ( diff == 1 )
                              {
                                    trace( "add last stripe" );
                                    insertNewStripe( newSerie, i );
                                    added = true;
                              }
                        }
                  }
                  while ( _seriesStripes.length > newSeries.length )
                  {
                        deleteSerie( _seriesStripes.length - 1 );
                  }
                  _totalStripes = newSeries.length;
                  trace("*******************************************************************************")
            }


            public function setStampSeries( value:Vector.<SeriesDTO> ):void
            {
                  _stampSeries = value;
                  _numberOfStampSeries = _stampSeries.length;
            }


            public function wheelMovement( delta:Number ):void
            {
                  if ( delta < 0 && _verticalSlider.slider.y + _verticalSlider.slider.height <= page.footer )
                  {
                        delta = delta < -3 ? -3 : delta;
                        _verticalSlider.slider.y = (_verticalSlider.slider.y - delta + _verticalSlider.slider.height < page.footer ? _verticalSlider.slider.y - delta : page.footer - _verticalSlider.slider.height);
                  }
                  if ( delta > 0 && _verticalSlider.slider.y >= page.header )
                  {
                        delta = delta > 3 ? 3 : delta;
                        _verticalSlider.slider.y = (_verticalSlider.slider.y - delta > page.header ? _verticalSlider.slider.y - delta : page.header);
                  }
            }


            // .........................................................................................................
            // Private Methods
            // .........................................................................................................

            private function init( e:Event ):void
            {
                  this.removeEventListener( Event.ADDED_TO_STAGE, init );

                  _allStripes = new Sprite();
                  _allStripesMask = SpriteUtils.drawQuad( 0, 0, page.wide, page.tall );
                  _allStripes.mask = _allStripesMask;

                  _bottomMenu = new BottomMenu();
                  _bottomMenu.stampsDisplayed = stampsDisplayed;

                  decadeYears.decadeSelectedSignal.add( moveToDecade )

                  _verticalSlider = new VerticalSlider();
                  _verticalSlider.page = page;
                  _verticalSlider.display();
                  _verticalSlider.addEventListener( Event.ENTER_FRAME, scrollStripes, false, 0, false );

                  addChild( _bottomMenu );
                  addChild( _allStripes );
                  addChild( _allStripesMask );
                  addChild( _btCountry );
                  addChild( typesMenu );
                  addChild( decadeYears );
                  addChild( _verticalSlider );

                  page.add( _background, page.NONE, 0, page.NONE, 0, page.WIDE, 0, page.TALL, 0 );
                  page.add( _selos, page.WIDE, 0, page.NONE, 0, page.NONE, 0, page.NONE, 0 );
                  page.add( _allStripesMask, page.LEFT, 0, page.NONE, page.header + 1, page.WIDE, -AppDesign.SLIDER_WIDTH,
                          page.TALL, -page.header - (page.tall - page.footer) );

                  onResize();
                  page.forceResize();
            }


            private function displayVisibleStripes():void
            {
                  // TODO : Changing a serie name and year dont update stripe correctly. Review stripes update
                  var initDisplay:int = _currentStripeIndex - (MINIMUM_STRIPES / 2) > 0 ? _currentStripeIndex - (MINIMUM_STRIPES / 2) : 0;
                  var endDisplay:int = _currentStripeIndex + MINIMUM_STRIPES > _numberOfStampSeries ? _numberOfStampSeries : _currentStripeIndex + MINIMUM_STRIPES;
                  for ( var i:int = initDisplay; i < endDisplay; i++ )
                  {
                        var stripeView:SeriesStripeView = _seriesStripes[i] as SeriesStripeView;
                        if ( !stripeView.isDisplayed )
                        {
                              stripeView.setData( _stampSeries[i].serieStamps );
                              _verticalSlider.visible = true;
                              stampsDisplayed = true;
                              _bottomMenu.stampsDisplayed = stampsDisplayed;
                        }
                  }
            }


            private function insertInStripePointer( index:int ):void
            {
                  _seriesStripes.splice( index, 0, null );
            }


            private function moveStripeToTop( series:SeriesStripeView ):void
            {
                  if ( _verticalSlider.slider.height < _allStripesMask.height )
                  {
                        var stripeY:Number = 0;
                        for ( var i:int = 0; i < _seriesStripes.length; i++ )
                        {
                              if ( _seriesStripes[i].serieIndex == series.serieIndex )
                              {
                                    stripeY = _seriesStripes[i].y;
                              }
                        }
                        var middlePart:int = _allStripesMask.height;
                        var step:Number = _stripesTotalHeight / (middlePart - _verticalSlider.slider.height);
                        var distance:Number = stripeY - page.header;
                        _verticalSlider.slider.y = (distance / step) + page.header;
                        if ( _verticalSlider.slider.y + _verticalSlider.slider.height > page.footer )
                        {
                              _verticalSlider.slider.y = page.footer - _verticalSlider.slider.height;
                        }
                        if ( _verticalSlider.slider.y < page.header )
                        {
                              _verticalSlider.slider.y = page.header;
                        }
                  }
            }


            private function changeBuild():void
            {
                  _logo.build.text = AppDesign.BUILD;
                  _logo.build.width = 120;
            }


            private function deleteSerie( foundIndex:int ):void
            {
                  _allStripes.removeChild( _seriesStripes[foundIndex] );
                  displaceStripesUp( foundIndex + 1 );
                  _seriesStripes.splice( foundIndex, 1 );
            }


            private function displaceStripesDown( initIndex:int ):void
            {
                  while ( initIndex <= _seriesStripes.length - 1 )
                  {
                        _seriesStripes[initIndex].serieIndex = _seriesStripes[initIndex].serieIndex + 1;
                        _seriesStripes[initIndex].y = _seriesStripes[initIndex].y + AppDesign.STRIPE_HEIGTH;
                        initIndex++;
                  }
            }


            private function displaceStripesUp( initIndex:int ):void
            {
                  while ( initIndex <= _seriesStripes.length - 1 )
                  {
                        _seriesStripes[initIndex].serieIndex = _seriesStripes[initIndex].serieIndex - 1;
                        _seriesStripes[initIndex].y = _seriesStripes[initIndex].y - AppDesign.STRIPE_HEIGTH;
                        initIndex++;
                  }
            }


            private function insertNewSerie( serieStamps:Vector.<StampDTO>, index:int, serieName:String, year:String ):void
            {
                  var _stripe:SeriesStripeView = new SeriesStripeView( serieName, year, index );
                  _allStripes.addChild( _stripe );
                  SpriteUtils.setPosition( _stripe, AppDesign.BUTTON_YEAR_DISPLACE,
                          (index * AppDesign.STRIPE_HEIGTH) + page.header );
                  _seriesStripes[index] = _stripe;
                  _seriesStripes[index].setData( serieStamps );
//                  _seriesStripes[index].displayStripe();
            }


            private function insertNewStripe( newSeries:SeriesDTO, foundIndex:int ):void
            {
                  displaceStripesDown( foundIndex );
                  insertInStripePointer( foundIndex );
                  insertNewSerie( newSeries.serieStamps, foundIndex, newSeries.serieName, newSeries.serieYear );
            }


            private function scrollStripes( e:Event ):void
            {
                  if ( _allStripes )
                  {
                        var middlepart:int = _allStripesMask.height;
                        var step:Number = (_stripesTotalHeight / (middlepart - _verticalSlider.slider.height));
                        var yDisplace:Number = int( step * (_verticalSlider.slider.y - page.header) );
                        if ( yDisplace > _stripesTotalHeight - AppDesign.STRIPE_HEIGTH )
                        {
                              yDisplace = _stripesTotalHeight - AppDesign.STRIPE_HEIGTH;
                        }
                        _allStripes.y = -yDisplace;
                        if ( _currentStripeIndex != (yDisplace / AppDesign.STRIPE_HEIGTH) )
                        {
                              _currentStripeIndex = yDisplace / AppDesign.STRIPE_HEIGTH;
                              displayVisibleStripes();
                              decadeYears.setSelectedCurrentDecade( _seriesStripes[_currentStripeIndex].serieDecade );
                        }
                  }
            }
      }
}