package com.shinho.commands {
	//Robotlegs import command
	import org.robotlegs.mvcs.Command;



	/**
	 * @author Nelson Alexandre
	 */
	public class Default extends Command {

		override public function execute():void {
			trace("default command executed");
		}

	}
}

