package com.shinho.views.types
{
	import com.shinho.controllers.StampsController;

	import org.robotlegs.mvcs.Mediator;


	public class TypesMenuMediator extends Mediator
	{
		[Inject]
		public var controller:StampsController;
		[Inject]
		public var view:TypesMenu;


		public function TypesMenuMediator()
		{
		}


		override public function onRegister():void
		{
			trace("types menu now mediating");
			controller.stampDataReadySignal.add(display);
		}


		private function display():void
		{
			view.display(controller.getStampTypes(), controller.getCurrentStampsTypeIndex());
			view.typeSelectedSignal.add(typeSelected);
		}


		private function typeSelected(newType:int):void
		{
			view.typeSelectedSignal.removeAll();
			controller.setCurrentTypeIndex(newType);
			controller.loadStampsType();
		}
	}
}