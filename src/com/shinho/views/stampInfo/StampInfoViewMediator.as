package com.shinho.views.stampInfo
{
	import com.shinho.events.ApplicationEvent;
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.CountryStampsModel;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.LanguageModel;
	import com.shinho.models.StampDatabase;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.views.pictureStripe.PictureStripeEvents;

	import flash.events.Event;

	import org.robotlegs.mvcs.Mediator;


	public class StampInfoViewMediator extends Mediator
	{
		//  -----------------------------------------------------------------------   VIEW dependancy
		[Inject]
		public var countryStamps:CountryStampsModel;
		//  -----------------------------------------------------------------------   MODEL dependancy
		[Inject]
		public var lang:LanguageModel;
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var stamps:StampDatabase;
		[Inject]
		public var view:StampInfoView;
		//  -----------------------------------------------------------------------   PROPERTIES
		//  -----------------------------------------------------------------------  	
		///  -----------------------------------   BOOLEAN
		private var currentBoardMessage:String;
		private var isAdding:Boolean = false;
		private var isEditing:Boolean = false;
		///  -----------------------------------   STRING
		private var isNew:Boolean = false;
		///  -----------------------------------   UINT 
		private var messageColor:uint;

		//  -----------------------------------------------------------------------   PUBLIC PROPERTIES
		//  -----------------------------------------------------------------------   *****************

		public function StampInfoViewMediator()
		{
			/* Avoid doing work in your constructors!
			 // Mediators are only ready to be used when onRegister gets called */
			super();
		}


		//  -----------------------------------------------------------------------   ON REGISTER

		override public function onRegister():void
		{
			view.page = page;
			updateIndexes( null );
			addContextListener( PictureStripeEvents.SHOW_STAMP, displayStamp );
			addViewListener( StampBoardEvent.CLOSE_BOARD, closeBoard );
			addViewListener( StampBoardEvent.EDIT_CLICKED, editStampInfo );
			addViewListener( StampBoardEvent.SAVE_CLICKED, updateStampInfo );
			addViewListener( StampBoardEvent.ADD_CLICKED, addNewStamp );
			addViewListener( StampBoardEvent.DELETE_CLICKED, deleteStamp );
			addViewListener( StampBoardEvent.PASTE_CLICKED, pasteImage );
			addViewListener( StampBoardEvent.COPY_CLICKED, copyImage );
			addViewListener( StampBoardEvent.CLEAR_IMAGE, clearImage );
			addViewListener( StampBoardEvent.KEEP_ORIGINAL_DATA, saveOriginalData );
			addContextListener( StampsDatabaseEvents.STAMPINFO_UPDATED, lockFields );
			addContextListener( StampsDatabaseEvents.STAMP_ADDED, lockFields );
			addContextListener( StampsDatabaseEvents.STAMP_DELETED, stampDeleted );
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
//			var stampData:Object = stamps.getStampData();
			view.displayBoard( countryStamps.currentStamp );
		}


		private function updateIndexes( e:StampsDatabaseEvents ):void
		{
			view.seller = stamps.sellers;
			view.printType = stamps.printTypes;
			view.catalogs = stamps.catalogs;
			view.printers = stamps.printers;
			view.stamptypes = stamps.stamptypes;
			view.countries = stamps.allcountries;
			view.allseries = stamps.allseries;
			view.alldesigners = stamps.alldesigners;
			view.allpapers = stamps.allpapers;
			view.allcolors = stamps.allcolors;
		}


		private function saveOriginalData( e:StampBoardEvent ):void
		{
//			stamps.originalData = e.body;
//			stamps.originalSerieName = e.body[0].seriename;
//			stamps.originalYear = e.body[0].year;
		}


		private function closeBoard( e:StampBoardEvent ):void
		{
			trace( "close board" );
			view.hideStampBoard();
			isNew = false;
			eventDispatcher.dispatchEvent( new ApplicationEvent( ApplicationEvent.UNLOCK_WHEEL ) );
		}


		private function editStampInfo( e:StampBoardEvent ):void
		{
			view.keepOriginalData();
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
			trace( "update stamp in database" );
			///view.lockFields();
			///view.resetButtons();
			var stampdata:StampDTO = view.getStampData();
			if ( view.isOkToSave() )
			{
				stamps.StampInfoChangedState = view.checkDataChanges();
				stamps.defineUpdateState();
				if ( isEditing )
				{
					stamps.startUpdateProcess( stampdata );
					boardMessage( "Stamp Info Updated...", 0x25cdea );
				}
				if ( isAdding )
				{
					var countryIsNew:Boolean = true;
					var typeIsNew:Boolean = true;
					if ( isNew )
					{
						var countries:Array = stamps.oldCountries;
						for ( var i:int = 0; i < countries.length; i++ )
						{
							if ( countries[i] == stampdata[StampDatabase.country] )
							{
								countryIsNew = false;
							}
						}
						var types:Array = stamps.types;
						for ( i = 0; i < types.length; i++ )
						{
							if ( types[i] == stampdata[StampDatabase.type] )
							{
								typeIsNew = false;
							}
						}
						isNew = !countryIsNew && !typeIsNew;
//						if (!countryIsNew && !typeIsNew){
//							isNew = true;
//						} else {
//							isNew = false;
//						}
					}
					if ( !isNew )
					{
						//stamps.addStamp( stampdata );
						_eventDispatcher.dispatchEvent(new StampsDatabaseEvents(StampsDatabaseEvents.ADD_STAMP, stampdata));
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


		private function lockFields( e:StampsDatabaseEvents ):void
		{
			view.lockFields();
		}


		private function addNewStamp( e:Event ):void
		{
			view.keepOriginalData();
			view.clearFields();
			view.editStampInfo();
			isEditing = false;
			isAdding = true;
		}


		private function addStampFromMainView( e:ApplicationEvent ):void
		{
//			var item:Object = { number: "", country: "", color: "", denomination: "", designer: "", inscription: "", paper: "", serie: "", printer: "", perforation: "", variety: "", watermark: "", year: "", type: "", history: "", current_value: 0, cost: 0, seller: "", date_purchased: "", comments: "", cancel: "", grade: 0, owned: 0, used: 0, condition_value: 0, hinged_value: 0, centering_value: 0, gum_value: 0, faults: "", purchase_year: "" };
			view.displayBoard( new StampDTO(), true );
			isAdding = true;
			isEditing = false;
			isNew = true;
		}


		//  -----------------------------------------------------------------------   BOARD MESSAGE

		private function deleteStamp( e:StampBoardEvent ):void
		{
			stamps.deleteStamp( view.getStampData(), true );
		}


		private function showBoardMessage( e:StampsDatabaseEvents ):void
		{
			view.displayErrorMessage( currentBoardMessage, messageColor );
		}


		//  -----------------------------------------------------------------------   OVERWRITE STAMP

		private function stampDeleted( e:StampsDatabaseEvents ):void
		{
			closeBoard( null );
		}
	}
}