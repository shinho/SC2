/**
 * Created with IntelliJ IDEA.
 * User: Alexeef
 * Date: 21-04-2013
 * Time: 20:08
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.views.components
{
	import com.shinho.views.stampInfo.StampInfoView;

	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Timer;


	public class InfoTextField
	{
		private static var timer:Timer = new Timer(300);
		private var _existingWords:Array = [];
		private var _textField:TextField;


		public function InfoTextField(tf:TextField, stampInfoView:StampInfoView, existingWords:Array = null)
		{
			_textField = tf;
			_textField.restrict = "^'";
			if (existingWords != null)
			{
				_existingWords = existingWords;
			}
			_textField.addEventListener(KeyboardEvent.KEY_UP, suggestWord);
			stampInfoView.lockFieldsSignal.add(lockField);
			stampInfoView.unlockFieldsSignal.add(unlockField);
			timer.addEventListener(TimerEvent.TIMER, suggestOnTimer);
		}


		public function lockField():void
		{
			_textField.type = TextFieldType.DYNAMIC;
		}


		public function reset():void
		{
			_textField.text = "";
		}


		public function setAlphanumericOnly():void
		{
			_textField.restrict = "a-z0-9";
		}


		public function setText(text:String):void
		{
			_textField.text = text;
		}


		public function unlockField():void
		{
			_textField.type = TextFieldType.INPUT;
		}


		private static function suggestWord(e:KeyboardEvent):void
		{
			if (!e.shiftKey && !e.ctrlKey)
			{
				if (e.keyCode != 8 && e.keyCode != 46)
				{
					if (timer.running)
					{
						timer.reset();
					}
					timer.start();
				}
			}
		}


		private function suggestOnTimer(e:TimerEvent):void
		{
			var temp:Array = [];
			var initialString:String = _textField.text;
			var num:uint = initialString.length;
			var suggestedWord:String = "";
			for (var i:int = 0; i < _existingWords.length; i++)
			{
				suggestedWord = _existingWords[i].name;
				if (suggestedWord != null)
				{
					if (suggestedWord.substring(0, num).toLowerCase() == initialString.toLowerCase())
					{
						temp.push(suggestedWord);
					}
				}
			}
			if (temp.length > 0)
			{
				var str:String = temp[0];
				_textField.text = initialString.substring(0, num) + str.substring(num, str.length);
				_textField.setSelection(num, str.length);
			}
			if (timer.running)
			{
				timer.stop();
			}
		}
	}
}
