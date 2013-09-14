package com.shinho.views {

	import org.robotlegs.mvcs.Mediator;



	public class DefaultMediator extends Mediator {



		//---- inject VIEW dependancy
		[Inject]
		public var view:Default;



		//---- inject MODEL dependancy
		[Inject]
		//public var country:CountryDatabase;



		public function DefaultMediator(){
			// Avoid doing work in your constructors!
			// Mediators are only ready to be used when onRegister gets called
		}



		override public function onRegister():void {
			trace("default now mediating");
		}


	}
}