package com.shiftf12{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.text.TextField;

	
	/**
	 * Dispatched when the input textfield has been parsed for completions.
	 * 
	 * Note that this event is dispatched regardless of the number of completions.
	 * 
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Creates a list of words or phrases that contain the most relevant matches to a dictionary of words or phrases.  When completions are 
	 * available, the user can press the TAB key and the text of the input textfield will be replaced with the most relevant completion.
	 * 
	 * @example Usage:
	 * <listing version="3.0">
	 * import com.quaver.utilities.AutoComplete;
	 * 
	 * var dictionary:Vector.&lt;String&gt; = new Vector.&lt;String&gt;();
	 * dictionary.push("This is the first test");
	 * dictionary.push("Hello!");
	 * dictionary.push("Here we have another test");
	 * dictionary.push("This is a test test test");
	 * 
	 * // instantiate class, passing it the input textfield that should be used to check for completions, 
	 * // as well as the list of words or phrases to check against.
	 * var ac:AutoComplete = new AutoComplete(input_txt, dictionary);
	 * 
	 * // add the event listener to capture the completions.
	 * ac.addEventListener(Event.CHANGE, onCompletions);
	 * 
	 * // if you want, you can specify the length of the pause (in milliseconds) from the users keystroke to when the parsing starts
	 * ac.parseDelay = 250;
	 * 
	 * // you can also specify the number of characters that must be typed before the parsing starts
	 * ac.charBuffer = 5;
	 * 
	 * function onCompletions(event:Event):void
	 * {
	 *		trace("Completions for: " + input_txt.text);
	 *  	for(var i:int = 0; i &lt; ac.completions.length; ++i)
	 *  	{
	 *  		trace(ac.completions[i]);
	 *  	}
	 *  	trace("-------------------------");
	 * }
	 * 
	 * // if you want to force a parse, you can do so by calling the parseInput() method, which will in turn dispatch the CHANGE event
	 * // with relevant completions of the current text, as long as the charBuffer has been met.
	 * ac.parseInput();
	 *  </listing>
	 *
	 * 
	 * @author Josh Brown
	 * @since 12.6.2010
	 * @langversion 3.0
	 * @playerversion Flash 9.0
	 */
	public class AutoComplete extends EventDispatcher
	{
		//========================================================
		// Private Properties
		//========================================================
		
		/**
		 * The input textfield that will be used to get matches for completions.
		 */
		private var _input:TextField;
		
		/**
		 * The list of words or phrases that should be checked against for completions.
		 */
		private var _dictionary:Vector.<String>;
		
		/**
		 * Any completions found will be placed into this Vector Array.
		 */
		private var _completions:Vector.<String>;
		
		/**
		 * Calls the #parseInput method when a key has been pressed and the delay has been met.
		 */
		private var _timer:Timer;
		
		/**
		 * The length of the pause (in milliseconds) from when the user types a word to when 
		 * the input textfield is parsed for completions.
		 */
		private var _parseDelay:Number = 300;
		
		/**
		 * The minimum number of characters that must be present in the input textfield before it is 
		 * parsed for completions.
		 */
		private var _charBuffer:int = 3;
		
		//========================================================
		// Getters / Setters
		//========================================================
		
		/**
		 * The words or phrases that contain matches for the current text in the input textfield.
		 */
		public function get completions():Vector.<String>
		{
			return _completions;
		}
		
		/**
		 * The the length of the pause (in milliseconds) from when the user presses a key and 
		 * the input text is parsed for completions.
		 * 
		 * @default 300
		 */
		public function get parseDelay():Number { return _parseDelay; }
		
		public function set parseDelay(value:Number):void 
		{
			_parseDelay = value;
			
			if (_timer)
			{
				_timer.delay = value;
				
				if (_timer.running)
				{
					_timer.reset();
					_timer.start();
				}
			}
		}
		
		/**
		 * Determines how many characters must be typed before the text is parsed for completions.
		 * 
		 * @default 3
		 */
		public function get charBuffer():int { return _charBuffer; }
		
		public function set charBuffer(value:int):void 
		{
			_charBuffer = value;
		}
		
		/**
		 * The list of words or phrases to be used for completions.
		 */
		public function get dictionary():Vector.<String> { return _dictionary; }
		
		public function set dictionary(value:Vector.<String>):void
		{
			_dictionary = value;
		}
		
		/**
		 * The input textfield that will be used to get matches for completions.
		 */
		public function get input():TextField { return _input; }
		
		public function set input(value:TextField):void
		{
			if (_input && _input.hasEventListener(FocusEvent.FOCUS_IN))
			{
				_input.removeEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
				_input.removeEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
				
				if (_input.hasEventListener(KeyboardEvent.KEY_UP))
				{
					_input.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
				}
			}
			
			if (_timer && _timer.running) _timer.reset();
			
			_input = value;
		}
		
		//========================================================
		// Constructor Function
		//========================================================
		
		/**
		 * Creates a new instance of the <code>AutoComplete</code> class.
		 * 
		 * @param	input The input textfield from which completions should be parsed.
		 * @param	dictionary A Vector array of words or phrases that will be used to parse the input text for completions.
		 */
		public function AutoComplete(input:TextField, dictionary:Vector.<String>)
		{
			_input = input;
			_dictionary = dictionary;
			
			_init();
		}
		
		//========================================================
		// Public Methods
		//========================================================
		
		/**
		 * Runs through the text in the input textfield, checking for relevant completions.  If the number of characters 
		 * in the input textfield is less than the <code>charBuffer</code> amount, nothing is parsed.  If the parse is successful, 
		 * the Event.CHANGE event is dispatched.
		 * 
		 * @see #charBuffer
		 */
		public function parseInput():void
		{
			if (_input.text.length < _charBuffer) return;
			
			var results:Array = new Array();
			var index:int = 0;
			
			for (var i:int = 0; i < _dictionary.length; ++i)
			{
				index = 0;
				
				while (index != -1)
				{
					index = _dictionary[i].toLowerCase().indexOf(_input.text.toLowerCase(), index);
					
					if (index != -1)
					{
						results.push( { i:i, match:_dictionary[i], numOccurrences:0 } );
						index += _input.text.length;
					}
				}
			}
			
			// Remove any duplicate results from the array.
			for (var j:int = 0; j < results.length; ++j)
			{
				for (var k:int = 0; k < results.length; ++k)
				{
					if (j != k)
					{
						if (results[j].i == results[k].i)
						{
							results[j].numOccurrences += 1;
							results.splice(k, 1);
						}
					}
				}
			}
			
			results.sortOn("numOccurences");
			
			_completions = new Vector.<String>();
			
			for (var l:int = 0; l < results.length; l++)
			{
				_completions.push(results[l].match);
			}
			
			if (_timer && _timer.running)
			{
				_timer.reset();
			}
			
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Removes all event listeners from the input textfield.  It also stops and removes the event listeners 
		 * from the timer, and clears all out references to the input textfield and timer, readying the instance
		 * for garbage collection.
		 */
		public function trash():void
		{
			if (_input)
			{
				_input.removeEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
				_input.removeEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
				if (_input.hasEventListener(KeyboardEvent.KEY_UP))
				{
					_input.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
				}
				
				_input = null;
			}
			
			if (_timer)
			{
				if (_timer.running) _timer.stop();
				
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer = null;
			}
		}
		
		//========================================================
		// Private Methods
		//========================================================
		
		protected function _init():void
		{
			_input.addEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
			_input.addEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
			
			_timer = new Timer(_parseDelay);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
		}
		
		//========================================================
		// Event Handlers
		//========================================================
		
		/**
		 * Calls the <code>parseInput</code> method to parse through the current input textfield.
		 * 
		 * @param	event TimerEvent.TIMER
		 * 
		 * @see parseInput
		 */
		private function _onTimer(event:TimerEvent):void
		{
			parseInput();
		}
		
		/**
		 * Adds the KeyboardEvent.KEY_UP event listener when the input textfield has gained focus.
		 * 
		 * @param	event FocuseEvent.FOCUS_IN
		 */
		private function _onFocusIn(event:FocusEvent):void
		{
			_input.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
		}
		
		/**
		 * Removes the KeyboardEvent.KEY_UP event listener when the input textfield has lost focus.
		 * @param	event
		 */
		private function _onFocusOut(event:FocusEvent):void
		{
			_input.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
		}
		
		/**
		 * When a key has been released, the charCode is first checked to see if it was the tab key.  If it was, then the _completions array is
		 * checked to see if there are currently any completions.  If there are, the text in the input textfield is replaced with the first completion, 
		 * which is the most relevant completion.  If none of these conditions are met, it simply starts the timer, resetting it if it's already running.
		 * 
		 * @param	event KeyboardEvent.KEY_UP
		 */
		protected function _onKeyUp(event:KeyboardEvent):void
		{
			if (event.charCode == Keyboard.TAB)
			{
				if (_completions && _completions.length > 0)
				{
					_input.text = _completions[0];
					_input.setSelection(_input.text.length, _input.text.length);
				}
			}
			else
			{
				if (_timer.running) _timer.reset();
				_timer.start();
			}
		}
	}
}