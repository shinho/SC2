package com.shinho.commands {
	//Robotlegs import command
	import com.shinho.views.messageBox.MessageBox;
	import com.shinho.views.messageBox.MessageBoxEvent;
	import org.robotlegs.mvcs.Command;
	
	
	
	/**
	 * @author Nelson Alexandre
	 */
	public class MessageBoxLoad extends Command {
		
		[Inject]
		public var event:MessageBoxEvent;
		
		
		override public function execute():void {
			trace("default command executed . "+event.typeBox);
			var msgbox:MessageBox = new MessageBox(event.typeBox);
			contextView.addChild(msgbox);
			if (event.typeBox == MessageBox.YES_NO) {
				msgbox.setTitleQuestion(event.title, event.question);			
			}
			msgbox.display();	
		}
	}
}