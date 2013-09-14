package com.shinho.commands {
	//Robotlegs import command
	import org.robotlegs.mvcs.Command;
	import com.shinho.views.countrySelector.CountrySelectorView;



	/**
	 * @author Nelson Alexandre
	 */
	public class CountrySelectorLoad extends Command {

		override public function execute():void {
			trace("LoadCountrySelector executed");
			contextView.addChild(new CountrySelectorView());
			///addContextListener(ApplicationEvent.COUNTRY_SELECTOR_CLOSE, closeCountrySelector);
		}

	}
}

