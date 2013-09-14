/**
 * Created with IntelliJ IDEA.
 * User: Alexeef
 * Date: 24-08-2013
 * Time: 18:01
 * To change this template use File | Settings | File Templates.
 */
package com.shinho.commands
{
	//Robotlegs import command
	import org.robotlegs.mvcs.Command;

	/**
	 * @author Nelson Alexandre
	 */
	public class UpdateStampCommand extends Command {

		override public function execute():void {
			trace("UpdateStampCommand command executed");
		}

	}
}
