package com.shinho.views.pictureStripe {
	import flash.events.Event;

	public class PictureStripeEvents extends Event {
		// events
		public static const SHOW_STAMP:String = 'PictureStripeEvents_show_stamp';
		public static const STAMPS_STRIPE_READY:String = 'PictureStripeEvents_stamps_stripe_ready';
		public static const STAMP_SELECTED:String = 'PictureStripeEvents_stamp_selected';
		private var _body:*;


		public function PictureStripeEvents(type:String, body:* = null){
			super(type);
			_body = body;
		}


		public function get body():* {
			return _body;
		}


		override public function clone():Event {
			return new PictureStripeEvents(type, body);
		}

	}
}
