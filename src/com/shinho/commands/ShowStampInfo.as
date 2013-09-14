package com.shinho.commands {
	//Robotlegs import command
	import com.shinho.views.stampInfo.StampInfoView;
	import org.robotlegs.mvcs.Command;
	
	
	
	/**
	 * @author Nelson Alexandre
	 */
	public class ShowStampInfo extends Command {
		private var stampInfo:StampInfoView;
		
		
		
		override public function execute():void {
			stampInfo = new StampInfoView();
			contextView.addChild(stampInfo);
		}
	}
}