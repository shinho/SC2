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
      import com.shinho.util.FileHelper;
      import com.shinho.views.messageBox.MessageBox;
      import com.shinho.views.pictureStripe.PictureStripeEvents;

      import flash.filesystem.File;

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
            private var stampData:StampDTO;


            public function StampInfoViewMediator()
            {
                  super();
            }


            override public function onRegister():void
            {
                  view.page = page;
                  updateIndexes();
                  addContextListener( PictureStripeEvents.SHOW_STAMP, displayStamp );
                  view.closeBoardSignal.add( closeBoard );
                  view.editStampSignal.add( editStampInfo );
                  view.saveStampSignal.add( updateStampInfo );
                  view.addStampClickedSignal.add( onAddNewStamp );
                  view.deleteStampClickedSignal.add( deleteStampMessage );
                  controller.stampUpdatedSignal.add( onStampUpdated );
                  controller.stampAddedSignal.add( onStampUpdated );
                  controller.stampDataReadySignal.add( onStampsReady );
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
                  updateIndexes();
                  view.displayBoard( stamps.currentStamp );
            }


            private function updateIndexes():void
            {
                  view.sellerEntries = stamps.getFieldEntries( StampsModel.SELLER );
                  view.varietyEntries = stamps.getFieldEntries( StampsModel.VARIETY );
                  view.catalogsEntries = stamps.getFieldEntries( StampsModel.MAIN_CATALOG );
                  view.printersEntries = stamps.getFieldEntries( StampsModel.PRINTER );
                  view.typesEntries = stamps.getFieldEntries( StampsModel.TYPE );
                  view.countriesEntries = stamps.getFieldEntries( StampsModel.COUNTRY );
                  view.seriesEntries = stamps.getFieldEntries( StampsModel.SERIE );
                  view.designersEntries = stamps.getFieldEntries( StampsModel.DESIGNER );
                  view.papersEntries = stamps.getFieldEntries( StampsModel.PAPER );
                  view.colorsEntries = stamps.getFieldEntries( StampsModel.COLOR );
            }


            private function closeBoard():void
            {
                  view.hideStampBoard();
                  addedFromMain = false;
                  eventDispatcher.dispatchEvent( new ApplicationEvent( ApplicationEvent.UNLOCK_WHEEL ) );
            }


            private function onStampsReady():void
            {
                  updateIndexes();
            }


            private function editStampInfo():void
            {
                  controller.previousStripeData = view.keepOriginalData();
                  view.editStampInfo();
                  isEditing = true;
                  isAdding = false;
            }


            private function updateStampInfo():void
            {
                  trace( "Stamp Info View Mediator : update stamp in database" );
                  stampData = view.getStampData();
                  if ( view.checkNonOptionalData() )
                  {
                        var _stampInfoChangedState = view.checkDataChanges();
                        if ( isEditing )
                        {
                              var stampExists:Boolean = db.checkStampID( stampData.country, stampData.number, stampData.type );
                              if ( stampExists )
                              {
                                    overwriteStampMessage();
                                    // TODO : Changing a serie name and year dont update stripe correctly
                              } else
                              {
                                    if ( checkChanges( _stampInfoChangedState, StampDatabase.NUMBER_CHANGED ) )
                                    {
                                          db.updateWithPreviousStampNumber( stampData, controller.previousStripeData );
                                          var imageOrigin:File = FileHelper.getFile( controller.previousStripeData.country, controller.previousStripeData.type, controller.previousStripeData.number );
                                          var imageDestination:File = FileHelper.getFile( stampData.country, stampData.type, stampData.number );
                                          imageOrigin.moveTo( imageDestination, true );
                                    } else
                                    {
                                          db.updateSelectedStamp( stampData );
                                    }

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


            private function overwriteStampMessage():void
            {
                  var title:String = "Overwrite Stamp?";
                  var question:String = "This will replace stamp information into database and no recovery is possible. Are you sure you want to do this?";
                  var msgBox:MessageBox = new MessageBox( MessageBox.TYPE_YES_NO, title, question );
                  contextView.addChild( msgBox );
                  msgBox.responseSignal.add( onOverwriteResponse );
                  msgBox.display();
            }


            private function onOverwriteResponse( response:String ):void
            {
                  if ( response == MessageBox.RESPONSE_YES )
                  {
                        db.updateWithPreviousStampNumber( stampData, controller.previousStripeData );
                        var imageOrigin:File = FileHelper.getFile( controller.previousStripeData.country, controller.previousStripeData.type, controller.previousStripeData.number );
                        var imageDestination:File = FileHelper.getFile( stampData.country, stampData.type, stampData.number );
                        imageOrigin.moveTo( imageDestination, true );
                        closeBoard();
                  }
            }


            private function deleteStampMessage():void
            {
                  var title:String = "Delete Stamp?";
                  var question:String = "This will delete stamp information from database and no recovery is possible. Are you sure you want to do this?";
                  var msgBox:MessageBox = new MessageBox( MessageBox.TYPE_YES_NO, title, question );
                  contextView.addChild( msgBox );
                  msgBox.responseSignal.add( onDeleteResponse );
                  msgBox.display();
            }


            private function onDeleteResponse( response:String ):void
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

      }
}