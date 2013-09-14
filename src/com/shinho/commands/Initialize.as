package com.shinho.commands {
//Robotlegs import command
import com.shinho.controllers.StampsController;

import org.robotlegs.mvcs.Command;

/**
 * @author Nelson Alexandre
 */
public class Initialize extends Command {

	[Inject]
	public var controller:StampsController;


	override public function execute():void {
		trace("Initialize Controller");
		controller.init();
	}
}
}