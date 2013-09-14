package com.shinho.views.pictureStripe.thumb
{
	import com.shinho.events.StampsDatabaseEvents;
	import com.shinho.models.dto.StampDTO;

	import org.robotlegs.mvcs.Mediator;


	public class ThumbMediator extends Mediator
	{
		//---- inject VIEW dependancy
		[Inject]
		public var view:Thumb;


		public function ThumbMediator():void
		{
			/// Avoid doing work in your constructors!
			/// Mediators are only ready to be used when onRegister gets called
		}


		override public function onRegister():void
		{
			addContextListener( StampsDatabaseEvents.STAMPINFO_UPDATED, onStampInfoUpdated );
		}


		private function onStampInfoUpdated( e:StampsDatabaseEvents ):void
		{
			var stampData:StampDTO = e.body as StampDTO;
			view.stamp = stampData;
		}
	}
}