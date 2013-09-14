package com.shinho.commands
{
	//Robotlegs import command
	import com.shinho.views.statsBox.StatsBox;

	import org.robotlegs.mvcs.Command;


	/**
	 * @author Nelson Alexandre
	 */
	public class StatsLoad extends Command
	{

		override public function execute():void
		{
			var statsBoard:StatsBox = new StatsBox();
			contextView.addChild( statsBoard );
		}
	}
}