package com.shinho.views.pictureStripe.thumb
{

      import com.shinho.events.StampsDatabaseEvents;
      import com.shinho.models.StampDatabase;
      import com.shinho.models.dto.StampDTO;

      import org.robotlegs.mvcs.Mediator;

      public class ThumbMediator extends Mediator
      {
            [Inject]
            public var view:Thumb;
            [Inject]
            public var db:StampDatabase;


            public function ThumbMediator():void
            {
            }


            override public function onRegister():void
            {
                  db.stampUpdatedSignal.add(onStampInfoUpdated);
            }


            private function onStampInfoUpdated(stampData:StampDTO):void
            {
                  view.stamp = stampData;
            }
      }
}