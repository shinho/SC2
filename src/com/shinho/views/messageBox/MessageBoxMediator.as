package com.shinho.views.messageBox {
	import com.shinho.models.FlexLayout;
	import com.shinho.views.messageBox.MessageBoxEvent;
	import org.robotlegs.mvcs.Mediator;
	
	
	
	public class MessageBoxMediator extends Mediator {
		//---- inject VIEW dependancy
		[Inject]
		public var view:MessageBox;
		//---- inject MODEL dependancy
		[Inject]
		public var page:FlexLayout;
		
		
		public function MessageBoxMediator(){
			// Avoid doing work in your constructors!
			// Mediators are only ready to be used when onRegister gets called
		}
		
		
		override public function onRegister():void {
			view.page = page;
			eventMap.mapListener(view, MessageBoxEvent.OPTION_SELECTED , dispatch, MessageBoxEvent);
			eventMap.mapListener(view, MessageBoxEvent.OPTION_SELECTED , closeMessageBoard);
		}
		
		
		public function closeMessageBoard(e:MessageBoxEvent):void {
			view.destroy();
			contextView.removeChild(view);
		}
	
	}
}