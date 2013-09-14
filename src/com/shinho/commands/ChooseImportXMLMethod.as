package com.shinho.commands {
	//Robotlegs import command
	import com.shinho.views.importer.XMLimportView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * @author Nelson Alexandre
	 */
	public class ChooseImportXMLMethod extends Command {
		override public function execute():void {
			var xmlBoard:XMLimportView = new XMLimportView();
			contextView.addChild(xmlBoard);
		}
	}
}