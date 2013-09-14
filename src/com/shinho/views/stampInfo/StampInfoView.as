package com.shinho.views.stampInfo
{
	import cmodule.jpegencoder.CLibInit;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.StampDatabase;
	import com.shinho.models.dto.StampDTO;
	import com.shinho.util.DateUtils;
	import com.shinho.util.Formatter;
	import com.shinho.util.NumberUtils;
	import com.shinho.util.SpriteUtils;
	import com.shinho.util.StringUtils;
	import com.shinho.views.components.BlackCheckBoxGroup;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	import org.osflash.signals.Signal;


	/**
	 * @author Nelson Alexandre
	 */
	public final class StampInfoView extends MovieClip
	{

		public var allcolors:Array;
		public var alldesigners:Array;
		public var allpapers:Array;
		public var allseries:Array;
		public var board:MovieClip;
		public var catalogs:Array;
		public var countries:Array;
		public var page:FlexLayout;
		public var printType:Array;
		public var printers:Array;
		public var seller:Array;
		public var stamptypes:Array;
		public static const DISPLAY_ALL:int = 1;
		public static const COLOR_BLUE:Number = 0x25cdea;
		public static const COLOR_RED:Number = 0xff1111;
		private static var backLeft:Sprite;
		private static var image:Bitmap;
		private static var boardWidth:int = 950;
		private static var boardHeight:int = 450;
		private static var stampFrame:int = 5;
		private static var bigStampFrame:int = 60;
		private static var topFrame:int = 60;
		private static var conditionGroup:BlackCheckBoxGroup;
		private static var conditionLegends:Array = new Array("poor", "average", "fine", "very fine", "extra fine");
		private static var hingedGroup:BlackCheckBoxGroup;
		private static var hingedLegends:Array = new Array("no hinge", "remnant", "light", "hinged", "heavy");
		private static var centeringGroup:BlackCheckBoxGroup;
		private static var centeringLegends:Array = new Array("average", "fine", "fine-vf", "very fine", "extra fine",
		                                                      "superb");
		private static var gumGroup:BlackCheckBoxGroup;
		private static var gumLegends:Array = new Array("original", "regummed", "no gum");
		private static var ownedCheckBox:BlackCheckBoxGroup;
		private static var mintCheckBox:BlackCheckBoxGroup;
		private static var timer:Timer = new Timer(300);
		private static var cli:CLibInit;
		private static var loader:Loader = new Loader();
		private static var fs:FileStream = new FileStream();
		private static var clip:BitmapData
		private var _stamp:StampDTO;
		private var _bigStampIsDisplayed:Boolean = false;
		private var _delay:Number = 0.6;
		private var _imageHolder:Sprite;
		private var _isLocked:Boolean;
		private var _isNewStamp:Boolean;
		private var _jpegEncoder:Object;
		private var _originalCountry:String;
		private var _originalID:String;
		private var _originalSerieName:String;
		private var _originalType:String;
		private var _originalYear:int;
		private var _stampHasImage:Boolean;
		private var _stampHeight:int = (boardHeight - topFrame) - stampFrame * 2;
		private var _stampWidth:int = (boardWidth / 2) - stampFrame * 2;
		private var _stampX:int = 0;
		private var _stampY:int = -(boardHeight / 2) + topFrame;
		private var _suggestionsArray:Array;
		private var _sugTextField:TextField;
		private var _tempData:Object;
		private var _tempHeight:Number;
		private var _tempHeightBig:Number;
		private var _tempWidth:Number;
		private var _tempWidthBig:Number;
		private var _tempX:Number;
		private var _tempXBig:Number;
		private var _tempY:Number;
		private var _tempYBig:Number;
		public var lockFieldsSignal:Signal = new Signal();
		public var unlockFieldsSignal:Signal = new Signal();
		public var resetFieldsSignal:Signal = new Signal();


		public function StampInfoView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}


		public function changeLabels(item:XMLList):void
		{
			/*			board.title.text = item[20].@label;
			 board.labelCountry.text = item[21].@label;
			 board.labelFilename.text = item[22].@label;
			 board.labelProgress.text = item[23].@label;
			 MSG_save = item[24].@label;
			 MSG_select = item[25].@label;*/
		}


		public function checkDataChanges():uint
		{
			var changes:uint = StampDatabase.NONE_CHANGED;
			if (_originalID != board.id.text)
			{
				changes = changes | StampDatabase.NUMBER_CHANGED;
			}
			if (_originalSerieName != board.serie.text)
			{
				changes = changes | StampDatabase.SERIE_CHANGED;
			}
			if (_originalYear != board.ano.value)
			{
				changes = changes | StampDatabase.YEAR_CHANGED;
			}
			if (_originalType != board.type.text)
			{
				changes = changes | StampDatabase.TYPE_CHANGED;
			}
			if (_originalCountry != board.country.text)
			{
				changes = changes | StampDatabase.COUNTRY_CHANGED;
			}
			return changes;
		}


		public function clearFields():void
		{
			resetFieldsSignal.dispatch();
			board.id.text = "";
			board.denomination.text = "";
			clearPhoto(null);
			ownedCheckBox.setSelected(0);
			mintCheckBox.setSelected(0);
			conditionGroup.setSelected(0);
			hingedGroup.setSelected(0);
			centeringGroup.setSelected(0);
			gumGroup.setSelected(0);
			board.faults.text = "";
			board.cancel.text = "";
			board.grade.value = 0;
			board.spares.value = 0;
			board.currentvalue.text = "0";
			board.purchaseYear.value = DateUtils.getCurrentYear();
			board.cost.text = "0";
			board.color.text = "";
			board.comments.text = "";
			board.seller.text = "";
			board.cost.restrict = StringUtils.RESTRICT_NUMBERS_AND_DOT;
			board.perc.text = NumberUtils.calculatePositivePercent(Number(board.cost.text),
			                                                       Number(board.currentvalue.text));
		}


		public function copyImage():void
		{
			Clipboard.generalClipboard.clearData(ClipboardFormats.BITMAP_FORMAT);
			Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, image.bitmapData);
			displayErrorMessage("Image copied to clipboard...", COLOR_BLUE);
		}


		public function deleteImage():void
		{
			if (!_isLocked)
			{
				if (_stampHasImage)
				{
					var slash:String = File.separator;
					var imageFile:File = File.documentsDirectory.resolvePath(StampDatabase.DIR_IMAGES + slash + board.country.text + slash + board.type.text + slash + board.id.text + ".jpg");
					if (imageFile.exists)
					{
						clearPhoto(null);
						imageFile.deleteFile();
						_stampHasImage = false;
						displayErrorMessage("Stamp Image Deleted...", COLOR_RED);
					}
				}
			}
		}


		public function displayBoard(stamp:StampDTO, isNew:Boolean = false):void
		{
			_stamp = stamp;
			_tempData = stamp;
			clearFields();
			backLeft.visible = true;
			board.visible = true;
			_isNewStamp = isNew;
			_imageHolder.alpha = 1;
			TweenMax.to(backLeft, .2, {x: 0, alpha: 0.95, ease: Expo.easeOut});
			TweenMax.to(board, 0.4, {scaleX: 1, scaleY: 1, alpha: 1, ease: Quint.easeOut, onComplete: passData});
		}


		public function displayErrorMessage(errorMessage:String, color:Number = 0xff0000):void
		{
			board.errorMsg.text = "";
			board.errorMsg.alpha = 1;
			board.errorMsg.textColor = color;
			board.errorMsg.text = errorMessage + " ";
			TweenMax.to(board.errorMsg, 3, {delay: 1.5, alpha: 0});
		}


		public function editStampInfo(editType:int = 0):void
		{
			if (editType == DISPLAY_ALL)
			{
				board.type.type = TextFieldType.INPUT;
				board.country.type = TextFieldType.INPUT;
			}
			TweenMax.to(board.backFields, 0.2, {alpha: 1});
			unlockFieldsSignal.dispatch();
			board.id.type = TextFieldType.INPUT;
			board.color.type = TextFieldType.INPUT;
			board.denomination.type = TextFieldType.INPUT;
			board.designer.type = TextFieldType.INPUT;
			board.history.type = TextFieldType.INPUT;
			board.inscription.type = TextFieldType.INPUT;
			board.paper.type = TextFieldType.INPUT;
			board.serie.type = TextFieldType.INPUT;
			board.printer.type = TextFieldType.INPUT;
			board.perforation.type = TextFieldType.INPUT;
			board.variety.type = TextFieldType.INPUT;
			board.watermark.type = TextFieldType.INPUT;
			board.watermark.type = TextFieldType.INPUT;
			board.catalog.type = TextFieldType.INPUT;
			board.currentvalue.type = TextFieldType.INPUT;
			board.cost.type = TextFieldType.INPUT;
			board.seller.type = TextFieldType.INPUT;
			board.comments.type = TextFieldType.INPUT;
			board.cancel.type = TextFieldType.INPUT;
			board.faults.type = TextFieldType.INPUT;
			board.ano.enabled = true;
			board.purchaseYear.enabled = true;
			board.grade.enabled = true;
			board.spares.enabled = true;
			enableButton(board.btSave);
			disableButton(board.btDelete);
			disableButton(board.btAdd);
			disableButton(board.btEdit);
			enableButton(board.btPaste);
			enableButton(board.btClearImage);
			centeringGroup.enable();
			conditionGroup.enable();
			gumGroup.enable();
			hingedGroup.enable();
			ownedCheckBox.enable();
			mintCheckBox.enable();
			_isLocked = false;
		}


		public function getStampData():StampDTO
		{
			this.stage.focus = board.comments;
			var editedStamp:StampDTO = new StampDTO();
			editedStamp.id = _stamp.id;
			editedStamp.number = board.id.text;
			editedStamp.country = board.country.text;
			editedStamp.type = board.type.text;
			editedStamp.color = board.color.text;
			editedStamp.denomination = StringUtils.isNull(board.denomination.text);
			editedStamp.designer = board.designer.text;
			editedStamp.inscription = board.inscription.text;
			editedStamp.history = board.history.text;
			editedStamp.paper = board.paper.text;
			editedStamp.serie = board.serie.text;
			editedStamp.printer = board.printer.text;
			editedStamp.perforation = board.perforation.text;
			editedStamp.variety = board.variety.text;
			editedStamp.watermark = board.watermark.text;
			editedStamp.year = board.ano.value;
			editedStamp.main_catalog = board.catalog.text;
			editedStamp.current_value = board.currentvalue.text;
			editedStamp.cost = board.cost.text;
			editedStamp.seller = board.seller.text;
			editedStamp.purchase_year = StringUtils.stringToInt(board.purchaseYear.value);
			editedStamp.comments = board.comments.text;
			editedStamp.cancel = board.cancel.text;
			editedStamp.grade = board.grade.value;
			editedStamp.spares = board.spares.value;
			editedStamp.owned = ownedCheckBox.selected == 1;
			editedStamp.used = mintCheckBox.selected == 1;
			editedStamp.condition_value = conditionGroup.selected;
			editedStamp.hinged_value = hingedGroup.selected;
			editedStamp.centering_value = centeringGroup.selected;
			editedStamp.gum_value = gumGroup.selected;
			editedStamp.faults = board.faults.text;
			editedStamp.originalID = _originalID;
			return editedStamp;
		}


		public function hideStampBoard():void
		{
			if (_bigStampIsDisplayed)
			{
				_delay = 0;
				shrinkStamp(null);
			}
			/// when animation is completed remove the stamp board and the background
			TweenMax.to(_imageHolder, 0.1, {alpha: 0});
			TweenMax.to(board, 0.2, {scaleX: 0, scaleY: 0, alpha: 0, ease: Quint.easeIn, onComplete: removeStampBoard});
			TweenMax.to(backLeft, 0.3, {x: -page.wide, alpha: 0, ease: Expo.easeOut});
		}


		public function isOkToSave():Boolean
		{
			var nullFields:Boolean = true;
			if (board.id.text == "" || board.serie.text == "")
			{
				nullFields = false;
			}
			return nullFields;
		}


		public function keepOriginalData():void
		{
			_originalID = StringUtils.isNull(board.id.text);
			_originalSerieName = StringUtils.isNull(board.serie.text);
			_originalYear = board.ano.value;
			_originalType = StringUtils.isNull(board.type.text);
			_originalCountry = StringUtils.isNull(board.country.text);
			var originalData:Array = new Array({id: _originalID, seriename: _originalSerieName, year: _originalYear, type: _originalType, country: _originalCountry});
			dispatchEvent(new StampBoardEvent(StampBoardEvent.KEEP_ORIGINAL_DATA, originalData));
		}


		public function lockFields():void
		{
			board.backFields.alpha = 0.3;
			lockFieldsSignal.dispatch();
			board.country.type = TextFieldType.DYNAMIC;
			board.type.type = TextFieldType.DYNAMIC;
			board.id.type = TextFieldType.DYNAMIC;
			board.color.type = TextFieldType.DYNAMIC;
			board.denomination.type = TextFieldType.DYNAMIC;
			board.designer.type = TextFieldType.DYNAMIC;
			board.history.type = TextFieldType.DYNAMIC;
			board.inscription.type = TextFieldType.DYNAMIC;
			board.paper.type = TextFieldType.DYNAMIC;
			board.serie.type = TextFieldType.DYNAMIC;
			board.printer.type = TextFieldType.DYNAMIC;
			board.perforation.type = TextFieldType.DYNAMIC;
			board.variety.type = TextFieldType.DYNAMIC;
			board.watermark.type = TextFieldType.DYNAMIC;
			board.catalog.type = TextFieldType.DYNAMIC;
			board.currentvalue.type = TextFieldType.DYNAMIC;
			board.cost.type = TextFieldType.DYNAMIC;
			board.seller.type = TextFieldType.DYNAMIC;
			board.comments.type = TextFieldType.DYNAMIC;
			board.cancel.type = TextFieldType.DYNAMIC;
			board.faults.type = TextFieldType.DYNAMIC;
			board.ano.enabled = false;
			board.purchaseYear.enabled = false;
			board.grade.enabled = false;
			board.spares.enabled = false;
			resetButtons();
			centeringGroup.disable();
			conditionGroup.disable();
			gumGroup.disable();
			ownedCheckBox.disable();
			hingedGroup.disable();
			_isLocked = true;
		}


		public function pasteImage():void
		{
			if (!_isLocked)
			{
				disableButton(board.btPaste);
				this.stage.focus = board.comments;
				clearPhoto(null);
				var clipImage:Bitmap = new Bitmap(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData);
				if (clipImage.width > 0 && clipImage.height > 0)
				{
					clip = clipImage.bitmapData;
					var baout:ByteArray = new ByteArray();
					var ba:ByteArray = clip.getPixels(clip.rect);
					ba.position = 0;
					var count:uint = 0;
					var stop:Boolean = false;
					while (count <= 3)
					{
						count++;
						try
						{
							_jpegEncoder.encode(ba, baout, clip.width, clip.height, 90);
							trace("trying to encode numbered : " + count);
						}
						catch (e:Error)
						{
							displayErrorMessage("Error Encoding", COLOR_RED);
							stop = true;
							enableButton(board.btPaste);
						}
						if (!stop)
						{
							count = 4;
						}
					}
					if (!stop)
					{
						var slash:String = File.separator;
						var savepath:File = File.documentsDirectory.resolvePath(StampDatabase.DIR_IMAGES + slash + board.country.text + slash + board.type.text + slash + board.id.text + ".jpg");
						fs = new FileStream();
						fs.addEventListener(Event.CLOSE, fileSaved);
						try
						{
							trace("saving image to disk file:");
							fs.openAsync(savepath, FileMode.WRITE);
							fs.writeBytes(baout);
							fs.addEventListener(Event.CLOSE, fileSaved);
							fs.close();
						}
						catch (e:Error)
						{
							displayErrorMessage(e.errorID + ":" + e.message, COLOR_RED);
						}
					}
				}
				else
				{
					displayErrorMessage("Clipboard is not an image, or its empty", COLOR_RED);
					enableButton(board.btPaste);
				}
			}
		}


		public function preventSave():void
		{
			disableButton(board.btSave);
		}


		public function removeStampBoard():void
		{
			_imageHolder.removeEventListener(MouseEvent.CLICK, enlargeStamp);
			if (_stampHasImage)
			{
				image.bitmapData.dispose();
				image = null;
				SpriteUtils.removeAllChild(_imageHolder);
				_stampHasImage = false;
			}
			board.visible = false;
			backLeft.visible = false;
		}


		public function resetButtons():void
		{
			enableButton(board.btDelete);
			disableButton(board.btSave);
			enableButton(board.btAdd);
			enableButton(board.btEdit);
			disableButton(board.btPaste);
			disableButton(board.btClearImage);
		}


		private function disableButton(bt:Object):void
		{
			bt.enabled = false;
			bt.alpha = 0.15;
		}


		private function displayStampImage():void
		{
			if (!_isNewStamp)
			{
				loadPhoto(_stamp);
				lockFields();
			}
			else
			{
				editStampInfo(DISPLAY_ALL);
			}
		}


		private function enableButton(bt:Object):void
		{
			bt.enabled = true;
			bt.alpha = 1;
		}


		private function loadPhoto(data:Object):void
		{
			if (_imageHolder.numChildren > 0)
			{
				SpriteUtils.removeAllChild(_imageHolder);
				image = null;
			}
			var slash:String = File.separator;
			var path:File = File.documentsDirectory.resolvePath(StampDatabase.DIR_IMAGES + slash + data.country + slash + data.type + slash + data.number + ".jpg");
			trace(path.url);
			var pathUrl:String = path.url;
			///loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(pathUrl);
			loader.load(urlRequest);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}


		private function passData():void
		{
			board.country.text = StringUtils.isNull(_stamp.country);
			board.type.text = StringUtils.isNull(_stamp.type);
			board.id.text = StringUtils.isNull(_stamp.number);
			board.color.text = StringUtils.isNull(_stamp.color);
			board.designer.text = StringUtils.isNull(_stamp.designer);
			board.history.text = StringUtils.isNull(_stamp.history);
			board.inscription.text = StringUtils.isNull(_stamp.inscription);
			board.paper.text = StringUtils.isNull(_stamp.paper);
			board.serie.text = StringUtils.isNull(_stamp.serie);
			board.printer.text = StringUtils.isNull(_stamp.printer);
			board.seller.text = StringUtils.isNull(_stamp.seller);
			board.perforation.text = StringUtils.isNull(_stamp.perforation);
			board.variety.text = StringUtils.isNull(_stamp.variety);
			board.watermark.text = StringUtils.isNull(_stamp.watermark);
			board.catalog.text = StringUtils.isNull(_stamp.main_catalog);
			board.ano.value = _stamp.year;
			board.spares.value = _stamp.spares;
			board.purchaseYear.value = _stamp.purchase_year;
			board.comments.text = StringUtils.isNull(_stamp.comments);
			board.cancel.text = StringUtils.isNull(_stamp.cancel);
			board.grade.value = StringUtils.isNull(_stamp.grade);
			board.faults.text = StringUtils.isNull(_stamp.faults);
			board.denomination.text = StringUtils.isNull(_stamp.denomination);
			board.currentvalue.text = _stamp.current_value == 0 ? "0.00" : Formatter.decimals(_stamp.current_value,
			                                                                                     2, true, ".");
			board.cost.text = _stamp.cost == 0 ? "0.000" : Formatter.decimals(_stamp.cost, 3, true, ".");

			var ownedValue:int = _stamp.owned == true ? 1 : 0;
			ownedCheckBox.setSelected(ownedValue);
			var mintValue:int = _stamp.used == true ? 1 : 0;
			mintCheckBox.setSelected(mintValue);
			conditionGroup.setSelected(_stamp.condition_value);
			hingedGroup.setSelected(_stamp.hinged_value);
			centeringGroup.setSelected(_stamp.centering_value);
			gumGroup.setSelected(_stamp.gum_value);

			keepOriginalData();

			board.perc.text = NumberUtils.calculatePositivePercent(Number(board.cost.text),
			                                                       Number(board.currentvalue.text));
			displayStampImage();
			timer.addEventListener(TimerEvent.TIMER, suggestOnTimer);
		}


		private function relinkHolder():void
		{
			board.addChild(_imageHolder);
			_imageHolder.x = _tempX;
			_imageHolder.y = _tempY;
			_imageHolder.width = _tempWidth;
			_imageHolder.height = _tempHeight;
			_imageHolder.addEventListener(MouseEvent.CLICK, enlargeStamp);
		}


		public function preventAnotherDecimalPoint(e:KeyboardEvent):void
		{
			var temp:String = e.target.text;
			var existsDecimal:Boolean = false;
			for (var i:int = 0; i < temp.length; i++)
			{
				if (temp.charAt(i) == ".")
				{
					existsDecimal = true;
				}
			}
			if (existsDecimal && (e.keyCode == 110 || e.keyCode == 190))
			{
				e.preventDefault();
			}
		}


		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			backLeft = SpriteUtils.drawQuad(0, 0, 1, 1);
			addChild(backLeft);

			page.add(backLeft, page.LEFT, 0, page.NONE, 60, page.WIDE, 0, page.TALL, -60);
			TweenMax.to(backLeft, 0, {tint: 0x111111, x: -page.wide});
			backLeft.visible = false;

			board = new StampInfoBoardSWC();
			addChild(board);
			page.add(board, page.CENTERX, 0, page.CENTERY, 0, page.NONE, 0, page.NONE, 0);
			page.forceResize();
			backLeft.x = -page.wide;
			backLeft.doubleClickEnabled = true;
			backLeft.addEventListener(MouseEvent.DOUBLE_CLICK, unlockFields);
			board.btClose.addEventListener(MouseEvent.CLICK, btCloseClicked);
			backLeft.addEventListener(MouseEvent.CLICK, btCloseClicked);
			board.btEdit.addEventListener(MouseEvent.CLICK, btEditClicked);
			board.btAdd.addEventListener(MouseEvent.CLICK, btAddClicked);
			board.btSave.addEventListener(MouseEvent.CLICK, btSaveClicked);
			board.btDelete.addEventListener(MouseEvent.CLICK, btDeleteClicked);
			board.btPaste.addEventListener(MouseEvent.CLICK, btPasteClicked);
			board.btCopy.addEventListener(MouseEvent.CLICK, btCopyClicked);
			board.btClearImage.addEventListener(MouseEvent.CLICK, btClearImageClicked);

			board.country.restrict = "^'";
			board.country.addEventListener(FocusEvent.FOCUS_OUT, newPhoto);
			board.country.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.type.restrict = "^'";
			board.type.addEventListener(FocusEvent.FOCUS_OUT, newPhoto);
			board.type.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.id.restrict = "a-z0-9";
			board.id.addEventListener(FocusEvent.FOCUS_IN, clearPhoto);
			board.id.addEventListener(FocusEvent.FOCUS_OUT, newPhoto);
			board.id.addEventListener(KeyboardEvent.KEY_UP, preventMoreLetters);

			board.color.restrict = "^'";
			board.color.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.designer.restrict = "^'";
			board.designer.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.history.restrict = "^'";

			board.inscription.restrict = "^'";

			board.paper.restrict = "^'";
			board.paper.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.serie.restrict = "^'";
			board.serie.addEventListener(KeyboardEvent.KEY_UP, suggestions);
			board.paper.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.printer.restrict = "^'";
			board.printer.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.seller.restrict = "^'";
			board.seller.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.perforation.restrict = "^'";

			board.variety.restrict = "^'";
			board.variety.addEventListener(KeyboardEvent.KEY_UP, suggestions);

			board.watermark.restrict = "^'";

			board.catalog.addEventListener(KeyboardEvent.KEY_UP, suggestions);
			board.catalog.restrict = "^'";

			board.purchaseYear.addEventListener(FocusEvent.FOCUS_IN, zero2CurrentDate);

			board.comments.restrict = "^'";

			board.cancel.restrict = "^'";

			board.faults.restrict = "^'";

			board.denomination.restrict = "^'";
			board.denomination.addEventListener(FocusEvent.FOCUS_IN, zero2Empty);

			board.currentvalue.restrict = StringUtils.RESTRICT_NUMBERS_AND_DOT;
			board.currentvalue.addEventListener(KeyboardEvent.KEY_DOWN, preventAnotherDecimalPoint);
			board.currentvalue.addEventListener(FocusEvent.FOCUS_OUT, preventNullNumber);
			board.currentvalue.addEventListener(FocusEvent.FOCUS_IN, zero2Empty);

			board.cost.restrict = StringUtils.RESTRICT_NUMBERS_AND_DOT;
			board.cost.addEventListener(KeyboardEvent.KEY_DOWN, preventAnotherDecimalPoint);
			board.cost.addEventListener(FocusEvent.FOCUS_OUT, preventNullNumber);
			board.cost.addEventListener(FocusEvent.FOCUS_IN, zero2Empty);

			board.btClose.buttonMode = true;
			board.btClose.addEventListener(MouseEvent.MOUSE_OVER, btCloseOnOver);
			board.btClose.addEventListener(MouseEvent.MOUSE_OUT, btCloseOnOut);

			ownedCheckBox = new BlackCheckBoxGroup(new Array(board.owned), false);

			mintCheckBox = new BlackCheckBoxGroup(new Array(board.mint), false);

			var conditionButtons:Array = new Array(board.condPoor, board.condAVG, board.condF, board.condVF,
			                                       board.condXF);
			conditionGroup = new BlackCheckBoxGroup(conditionButtons, false);
			conditionGroup.setLegends(conditionLegends);

			var hingedButtons:Array = new Array(board.hgNH, board.hgRM, board.hgLH, board.hgH, board.hgHH);
			hingedGroup = new BlackCheckBoxGroup(hingedButtons, false);
			hingedGroup.setLegends(hingedLegends);

			var centeringButtons:Array = new Array(board.centAVG, board.centFine, board.centFVF, board.centVF,
			                                       board.centXF, board.centS);
			centeringGroup = new BlackCheckBoxGroup(centeringButtons, false);
			centeringGroup.setLegends(centeringLegends);

			var gumButtons:Array = new Array(board.gumOG, board.gumRG, board.gumNG);
			gumGroup = new BlackCheckBoxGroup(gumButtons, false);
			gumGroup.setLegends(gumLegends);

			lockFields();
			board.visible = false;
			TweenMax.to(board, 0, {scaleX: 0, scaleY: 0, alpha: 0});
			_imageHolder = new Sprite();
			board.addChild(_imageHolder);

			_stampHasImage = false;
			cli = new CLibInit();
			_jpegEncoder = cli.init();
		}


		private function preventNullNumber(e:FocusEvent):void
		{
			var temp:Object = e.target;
			var decimals:int = temp.name == "cost" ? 3 : 2;
			if (temp.text == "")
			{
				temp.text = "0";
			}
			if (temp.text.charAt(0) == ".")
			{
				temp.text = "0" + temp.text;
			}
			temp.text = Formatter.decimals(Number(temp.text), decimals, true, ".");
			board.perc.text = NumberUtils.calculatePositivePercent(Number(board.cost.text),
			                                                       Number(board.currentvalue.text));
		}


		private function zero2Empty(e:FocusEvent):void
		{
			if (e.target.text == "0" || e.target.text == "0.00" || e.target.text == "0.000")
			{
				e.target.text = "";
			}
		}




		private function zero2CurrentDate(e:FocusEvent):void
		{
			if (e.currentTarget.value == 0)
			{
				e.currentTarget.value = DateUtils.getCurrentYear();
			}
		}



		private function preventMoreLetters(e:KeyboardEvent):void
		{
			var searchLetters:RegExp = (/\w+/);
			var checkStr:String = e.target.text.match(searchLetters);
			if (isNaN(Number(checkStr)))
			{
				e.target.restrict = "";
			}
			else
			{
				e.target.restrict = "a-z0-9";
			}
			enableButton(board.btSave);
		}


		private function unlockFields(e:MouseEvent):void
		{
			trace("double clicked");
			editStampInfo();
		}



		private function btCloseOnOver(e:MouseEvent):void
		{
			e.currentTarget.filters = [new GlowFilter(0x32ebfb, .75, 5, 5, 2, 3, false, false)];
		}


		// ---------------------------------------------------------------    lock fields

		private function btCloseOnOut(e:MouseEvent):void
		{
			e.currentTarget.filters = [];
		}


		private function btCloseClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.CLOSE_BOARD));
		}


		private function btEditClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.EDIT_CLICKED));
		}


		private function btAddClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.ADD_CLICKED));
		}


		private function btSaveClicked(e:MouseEvent):void
		{
			if (!_isLocked)
			{
				this.stage.focus = board.comments;
				board.btSave.enabled = false;
				board.btSave.alpha = 0.15;
				dispatchEvent(new StampBoardEvent(StampBoardEvent.SAVE_CLICKED));
			}
		}


		private function btDeleteClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.DELETE_CLICKED));
		}


		private function btPasteClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.PASTE_CLICKED));
		}


		private function btClearImageClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.CLEAR_IMAGE));
		}


		private function btCopyClicked(e:MouseEvent):void
		{
			dispatchEvent(new StampBoardEvent(StampBoardEvent.COPY_CLICKED));
		}


		private function onIOError(e:IOErrorEvent):void
		{
			trace("image not found");
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_stampHasImage = false;
		}


		private function imageLoaded(e:Event):void
		{
			_imageHolder.alpha = 0;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
			image = (Bitmap)(e.target.content);
			_imageHolder.addChild(image);
			var ratio:Number = 1;
			if (image.width > image.height)
			{ ///horizontal
				ratio = image.width / _stampWidth;
				_imageHolder.height = image.height / ratio;
				_imageHolder.width = _stampWidth;
			}
			else
			{
				ratio = image.height / _stampHeight;
				_imageHolder.width = image.width / ratio;
				_imageHolder.height = _stampHeight;
			}
			var difX:Number = _stampWidth - _imageHolder.width;
			var difY:Number = _stampHeight - _imageHolder.height;
			_imageHolder.x = _stampX + (difX / 2);
			_imageHolder.y = _stampY + (difY / 2);
			TweenMax.to(_imageHolder, 0.3, {alpha: 1});
			_imageHolder.addEventListener(MouseEvent.CLICK, enlargeStamp);
			_imageHolder.buttonMode = true;
			if (!_isLocked)
			{
				enableButton(board.btPaste);
			}
			_stampHasImage = true;
		}


		private function enlargeStamp(e:MouseEvent):void
		{

			_imageHolder.removeEventListener(MouseEvent.CLICK, enlargeStamp);

			_tempX = _imageHolder.x;
			_tempY = _imageHolder.y;
			_tempWidth = _imageHolder.width;
			_tempHeight = _imageHolder.height;

			this.addChild(_imageHolder);

			var difX:Number = _stampWidth - _imageHolder.width;
			var difY:Number = _stampHeight - _imageHolder.height;
			_imageHolder.x = board.x + _stampX + (difX / 2);
			_imageHolder.y = board.y + _stampY + (difY / 2);

			_tempXBig = _imageHolder.x;
			_tempYBig = _imageHolder.y;
			_tempWidthBig = _imageHolder.width;
			_tempHeightBig = _imageHolder.height;

			var ratio:Number = _imageHolder.height / _imageHolder.width;
			var maxHeight:Number = page.tall - bigStampFrame;
			var expandX:Number = page.wide - bigStampFrame;
			var expandY:Number = maxHeight * ratio;
			if (expandY > maxHeight)
			{
				expandY = maxHeight;
				expandX = maxHeight / ratio;
			}
			difX = page.wide - expandX;
			difY = page.tall - expandY;

			TweenMax.to(_imageHolder, 0.6,
			            {width: expandX, height: expandY, x: difX / 2, y: difY / 2, ease: Expo.easeOut});

			_delay = 0.6;
			_imageHolder.addEventListener(MouseEvent.CLICK, shrinkStamp);
			_bigStampIsDisplayed = true;
		}


		private function shrinkStamp(e:MouseEvent):void
		{
			_imageHolder.removeEventListener(MouseEvent.CLICK, shrinkStamp);
			TweenMax.to(_imageHolder, _delay,
			            {width: _tempWidthBig, height: _tempHeightBig, x: _tempXBig, y: _tempYBig, ease: Expo.easeOut, onComplete: relinkHolder});
		}


		private function newPhoto(e:FocusEvent):void
		{
			_tempData.number = board.id.text;
			_tempData.country = board.country.text;
			_tempData.type = board.type.text;
			loadPhoto(_tempData);
			_tempData.number = _originalID;
		}


		private function fileSaved(e:Event):void
		{
			fs.removeEventListener(Event.CLOSE, fileSaved);
			trace("image saved...destroying temp image");
			clip.dispose();
			displayErrorMessage("Stamp Image Pasted and Saved", COLOR_BLUE);
			newPhoto(null);
			enableButton(board.btPaste);
		}


		private function clearPhoto(e:FocusEvent):void
		{
			if ((_stampHasImage || _imageHolder.numChildren > 0) && _isLocked == false)
			{
				image.bitmapData.dispose();
				image = null;
				SpriteUtils.removeAllChild(_imageHolder);
				_stampHasImage = false;
			}
		}


		private function suggestions(e:KeyboardEvent):void
		{

			if (!e.shiftKey && !e.ctrlKey)
			{
				var field:String = e.target.name;
				_sugTextField = TextField(e.target);
				if (e.keyCode != 8 && e.keyCode != 46)
				{
					switch (field)
					{
						case "country":
							_suggestionsArray = countries;
							break;
						case "serie":
							_suggestionsArray = allseries;
							break;
						case "type":
							_suggestionsArray = stamptypes;
							break;
						case "catalog":
							_suggestionsArray = catalogs;
							break;
						case "variety":
							_suggestionsArray = printType;
							break;
						case "printer":
							_suggestionsArray = printers;
							break;
						case "color":
							_suggestionsArray = allcolors;
							break;
						case "designer":
							_suggestionsArray = alldesigners;
							break;
						case "paper":
							_suggestionsArray = allpapers;
							break;
						case "seller":
							_suggestionsArray = seller;
							break;
					}

					if (timer.running)
					{
						timer.reset();
					}
					timer.start();
				}
			}
			else
			{
				///e.preventDefault();
			}
		}


		private function suggestOnTimer(e:TimerEvent):void
		{
			var temp:Array = new Array();
			var initstr:String = _sugTextField.text;
			var num:uint = initstr.length;
			var sug:String = "";
			for (var i:int = 0; i < _suggestionsArray.length; i++)
			{
				sug = _suggestionsArray[i].name;
				if (sug != null)
				{
					var suglow:String = sug.substring(0, num);
					if (suglow.toLowerCase() == initstr.toLowerCase())
					{
						temp.push(sug);
					}
				}
			}
			if (temp.length > 0)
			{
				var str:String = temp[0];
				_sugTextField.text = initstr.substring(0, num) + str.substring(num, str.length);
				_sugTextField.setSelection(num, str.length);
			}
			if (timer)
			{
				if (timer.running)
				{
					timer.stop();
				}
			}
		}


	}
}