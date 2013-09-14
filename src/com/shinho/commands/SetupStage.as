package com.shinho.commands {

import com.shinho.events.MenuEvents;
import com.shinho.models.LanguageModel;
import com.shinho.views.ApplicationMainView;

import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import org.robotlegs.mvcs.Command;

//----------------------------------------------------------------------------- CLASS
/**
 * @author Nelson Alexandre
 */
public class SetupStage extends Command {
	//Private Properties

	[Inject]
	public var lang:LanguageModel;

	//Public Properties


	override public function execute():void {
		trace("Setting up stage")
		//------------------------------------------------------------------  define application view
		contextView.stage.scaleMode = StageScaleMode.NO_SCALE;
		contextView.stage.align = StageAlign.TOP_LEFT;
		contextView.stage.frameRate = 45;
		var item:XMLList = lang.labels;
		//------------------------------------------------------------------  defines native menu
		var menu:NativeMenu = new NativeMenu();
		menu.addItem(new NativeMenuItem(item[25].@label));
		menu.addItem(new NativeMenuItem(item[26].@label));
		menu.addItem(new NativeMenuItem(item[27].@label));
		contextView.contextMenu = menu;
		menu.addEventListener(Event.SELECT, menuItemSelected);
		//------------------------------------------------------------------  adds application main view
		contextView.addChild(new ApplicationMainView);
	}


	// -------------------------------------------------------- context menu item selected


	private function menuItemSelected(e:Event):void {
		var item:NativeMenuItem = e.target as NativeMenuItem;
		switch (item.label) {
			case "import xml":
				eventDispatcher.dispatchEvent(new MenuEvents(MenuEvents.IMPORT_XML));
				break;
			case "export xml":
				eventDispatcher.dispatchEvent(new MenuEvents(MenuEvents.EXPORT_XML));
				break;
			case "about":
				trace("created by Nelson Alexandre(c)2011");
				break;
		}
	}
}
}