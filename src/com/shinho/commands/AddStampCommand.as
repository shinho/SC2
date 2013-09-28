package com.shinho.commands {

      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.CountriesModel;
      import com.shinho.models.StampsModel;
      import com.shinho.models.DecadeYearsModel;
      import com.shinho.models.StampDatabase;
      import com.shinho.models.dto.StampDTO;
      import com.shinho.views.messageBox.MessageBox;

      import org.robotlegs.mvcs.Command;

      public class AddStampCommand extends Command {
            [Inject]
            public var countries:CountriesModel;
            [Inject]
            public var decades:DecadeYearsModel;
            [Inject]
            public var stamps:StampsModel;
            [Inject]
            public var db:StampDatabase;
            [Inject]
            public var event:StampsDatabaseEvents;

            private var _stampData:StampDTO;


            override public function execute():void {
                  trace("AddStampCommand command executed");
                  _stampData = event.body as StampDTO;
                  var stampExist:Boolean = db.checkStampID(_stampData.country, _stampData.number as String, _stampData.type);
                  if (stampExist) {
                        var title:String = "Overwrite Stamp Information?";
                        var question:String = "A stamp with that number already exists. Do you want to overwrite stamp data?";
                        var msgBox:MessageBox = new MessageBox(MessageBox.TYPE_YES_NO, title, question);
                        contextView.addChild(msgBox);
                        msgBox.responseSignal.add(onResponse);
                        msgBox.display();
                  } else {
                        db.insertStampData(_stampData);
                  }

            }


            private function onResponse(response:String):void {
                  if (response == MessageBox.RESPONSE_YES) {
                        db.updateOriginalStamp(_stampData);
                  } else {

                  }
            }

      }
}
