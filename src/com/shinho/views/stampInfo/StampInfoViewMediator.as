package com.shinho.views.stampInfo
{

      import com.shinho.controllers.StampsController;
      import com.shinho.events.ApplicationEvent;
      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.CountriesModel;
      import com.shinho.models.StampsModel;
      import com.shinho.models.FlexLayout;
      import com.shinho.models.LanguageModel;
      import com.shinho.models.StampDatabase;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.views.messageBox.MessageBox;
      import com.shinho.views.pictureStripe.PictureStripeEvents;

      import org.robotlegs.mvcs.Mediator;

      public class StampInfoViewMediator extends Mediator
      {
            [Inject]
            public var stamps:StampsModel;
            [Inject]
            public var lang:LanguageModel;
            [Inject]
            public var page:FlexLayout;
            [Inject]
            public var db:StampDatabase;
            [Inject]
            public var view:StampInfoView;
            [Inject]
            public var countries:CountriesModel;
            [Inject]
            public var controller:StampsController;

            private var currentBoardMessage:String;
            private var isAdding:Boolean = false;
            private var isEditing:Boolean = false;

            private var addedFromMain:Boolean = false;

            private var messageColor:uint;

            private var _stampInfoChangedState:uint;
            private var _stampInfoUpdateState:String;


            public function StampInfoViewMediator()
            {
                  /* Avoid doing work in your constructors!
                   // Mediators are only ready to be used when onRegister gets called */
                  super();
            }


            override public function onRegister():void
            {
                  view.page = page;
                  updateIndexes( null );
                  addContextListener( PictureStripeEvents.SHOW_STAMP, displayStamp );
                  view.closeBoardSignal.add( closeBoard );
                  addViewListener( StampBoardEvent.EDIT_CLICKED, editStampInfo );
                  addViewListener( StampBoardEvent.SAVE_CLICKED, updateStampInfo );
                  view.addStampClickedSignal.add( onAddNewStamp );
                  view.deleteStampClickedSignal.add( deleteStamp );
                  addViewListener( StampBoardEvent.PASTE_CLICKED, pasteImage );
                  addViewListener( StampBoardEvent.COPY_CLICKED, copyImage );
                  addViewListener( StampBoardEvent.CLEAR_IMAGE, clearImage );
                  db.stampUpdatedSignal.add( onStampUpdated );
                  db.stampAddedSignal.add( onStampUpdated );
                  addContextListener( StampsDatabaseEvents.INDEXES_UPDATED, updateIndexes );
                  addContextListener( StampsDatabaseEvents.SHOW_BOARD_MESSAGE, showBoardMessage );
                  addContextListener( ApplicationEvent.ADD_STAMP, addStampFromMainView );
            }


            private function boardMessage( msg:String, color:uint ):void
            {
                  currentBoardMessage = msg;
                  messageColor = color;
            }


            private function displayStamp( e:PictureStripeEvents ):void
            {
                  view.displayBoard( stamps.currentStamp );
            }


            private function updateIndexes( e:StampsDatabaseEvents ):void
            {
                  view.seller = db.sellers;
                  view.printType = db.printTypes;
                  view.catalogs = db.catalogs;
                  view.printers = db.printers;
                  view.stamptypes = db.stamptypes;
                  view.countries = db.allCountries;
                  view.allseries = db.allSeries;
                  view.alldesigners = db.allDesigners;
                  view.allpapers = db.allPapers;
                  view.allcolors = db.allColors;
            }


            private function closeBoard():void
            {
                  view.hideStampBoard();
                  addedFromMain = false;
                  eventDispatcher.dispatchEvent( new ApplicationEvent( ApplicationEvent.UNLOCK_WHEEL ) );
            }


            private function editStampInfo( e:StampBoardEvent ):void
            {
                  controller.previousStripeData = view.keepOriginalData();
                  view.editStampInfo();
                  isEditing = true;
                  isAdding = false;
            }


            private function pasteImage( e:StampBoardEvent ):void
            {
                  view.pasteImage();
            }


            private function copyImage( e:StampBoardEvent ):void
            {
                  view.copyImage();
            }


            private function clearImage( e:StampBoardEvent ):void
            {
                  view.deleteImage();
            }


            private function updateStampInfo( e:StampBoardEvent ):void
            {
                  trace( "Stamp Info View Mediator : update stamp in database" );
                  var stampData:StampDTO = view.getStampData();
                  if ( view.checkNonOptionalData() )
                  {
                        _stampInfoChangedState = view.checkDataChanges();
                        defineUpdateState();
                        if ( isEditing )
                        {
                              var stampExists:Boolean = db.checkStampID( stampData.country, stampData.number, stampData.type );
                              if ( stampExists || checkChanges( _stampInfoChangedState, StampDatabase.NUMBER_CHANGED ) )
                              {
                                    db.updateWithPreviousStampNumber( stampData, controller.previousStripeData );
                              } else
                              {
                                    db.updateSelectedStamp( stampData );
                              }
                              boardMessage( "Stamp Info Updated...", 0x25cdea );
                        }
                        if ( isAdding )
                        {
                              var countryIsNew:Boolean = true;
                              var typeIsNew:Boolean = true;
                              if ( addedFromMain )
                              {
                                    countryIsNew = countries.isCountryNew( stampData.country );
                                    var types:Array = db.types;
                                    for ( var i:int = 0; i < types.length; i++ )
                                    {
                                          if ( types[i] == stampData[StampDatabase.type] )
                                          {
                                                typeIsNew = false;
                                          }
                                    }
                                    addedFromMain = !countryIsNew && !typeIsNew;
                              }
                              if ( !addedFromMain )
                              {
                                    eventDispatcher.dispatchEvent( new StampsDatabaseEvents( StampsDatabaseEvents.ADD_STAMP, stampData ) );
                                    boardMessage( "Saving stamp info...", 0x25cdea );
                              }
                              else
                              {
                                    view.displayErrorMessage( "This is not a new Country or a new Type. Cannot save!" );
                                    view.editStampInfo();
                              }
                        }
                  }
                  else
                  {
                        view.displayErrorMessage( "Serie name and Number cannot be blank. Information not saved!" );
                  }
            }


            private function onStampUpdated( stampData:StampDTO ):void
            {
                  view.lockFields();
            }


            private function checkChanges( flags:uint, testFlag:uint ):Boolean
            {
                  return (flags & testFlag) == testFlag;
            }


            private function onAddNewStamp():void
            {
                  controller.previousStripeData = view.keepOriginalData();
                  view.clearFields();
                  view.editStampInfo();
                  isEditing = false;
                  isAdding = true;
            }


            private function addStampFromMainView( e:ApplicationEvent ):void
            {
                  view.displayBoard( new StampDTO(), true );
                  isAdding = true;
                  isEditing = false;
                  addedFromMain = true;
            }


            //  -----------------------------------------------------------------------   BOARD MESSAGE

            private function deleteStamp():void
            {
                  var title:String = "Delete Stamp?";
                  var question:String = "This will delete stamp information from database and no recovery is possible. Are you sure you want to do this?";
                  var msgBox:MessageBox = new MessageBox( MessageBox.TYPE_YES_NO, title, question );
                  contextView.addChild( msgBox );
                  msgBox.responseSignal.add( onResponse );
                  msgBox.display();
            }


            private function onResponse( response:String ):void
            {
                  if ( response == MessageBox.RESPONSE_YES )
                  {
                        db.deleteOnConfirmation( view.getStampData() );
                        closeBoard();
                  }
            }


            private function showBoardMessage( e:StampsDatabaseEvents ):void
            {
                  view.displayErrorMessage( currentBoardMessage, messageColor );
            }


            private function defineUpdateState():void
            {
                  _stampInfoUpdateState = StampDatabase.NONE_UPDATED;
                  if ( checkChanges( _stampInfoChangedState, StampDatabase.NUMBER_CHANGED ) )
                  {
                        _stampInfoUpdateState = StampDatabase.NUMBER_UPDATED;
                  }
                  if ( checkChanges( _stampInfoChangedState, StampDatabase.SERIE_CHANGED ) )
                  {
                        _stampInfoUpdateState = StampDatabase.SERIE_UPDATED;
                  }
                  if ( checkChanges( _stampInfoChangedState, StampDatabase.YEAR_CHANGED ) )
                  {
                        _stampInfoUpdateState = StampDatabase.DECADE_UPDATED;
                  }
                  if ( checkChanges( _stampInfoChangedState, StampDatabase.TYPE_CHANGED ) )
                  {
                        _stampInfoUpdateState = StampDatabase.TYPE_UPDATED;
                  }
                  if ( checkChanges( _stampInfoChangedState, StampDatabase.COUNTRY_CHANGED ) )
                  {
                        _stampInfoUpdateState = StampDatabase.COUNTRY_UPDATED;
                  }
            }
      }
}