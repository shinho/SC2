package com.shinho.views.countrySelector
{

	import com.shinho.controllers.StampsController;
	import com.shinho.models.CountriesModel;
	import com.shinho.models.FlexLayout;
	import com.shinho.models.LanguageModel;
	import com.shinho.models.dto.CountryDTO;

	import flash.events.MouseEvent;

	import org.robotlegs.mvcs.Mediator;


	public class CountrySelectorMediator extends Mediator
	{
		[Inject]
		public var controller:StampsController;
		[Inject]
		public var countries:CountriesModel;
		[Inject]
		public var lang:LanguageModel;
		[Inject]
		public var page:FlexLayout;
		[Inject]
		public var view:CountrySelectorView;


		override public function onRegister():void
		{
			view.page = page;
			view.countries = countries.countriesList;
			eventMap.mapListener(view.countrySelectorBoard.btClose, MouseEvent.CLICK, closeBoard);
			view.countrySelectedSignal.add(countrySelected) ;
			view.changeLabels(lang.labels);
		}


		public function CountrySelectMediator():void
		{
			// Avoid doing work in your constructors!
			// Mediators are only ready to be used when onRegister gets called
		}


		private function countrySelected(country:CountryDTO):void
		{
			view.countrySelectedSignal.removeAll();

			countries.setCurrentCountry(country);
			contextView.removeChild(view);
			controller.loadNewCountry();
		}


		private function closeBoard(e:MouseEvent):void
		{
			view.closeBoard();
			contextView.removeChild(view);
		}
	}
}