package com.shinho.views.messageBox
{
import com.shinho.models.FlexLayout;
import com.shinho.views.messageBox.MessageBoxEvent;

import org.robotlegs.mvcs.Mediator;


public class MessageBoxMediator extends Mediator
{
    //---- inject VIEW dependency
    [Inject]
    public var view:MessageBox;
    //---- inject MODEL dependency
    [Inject]
    public var page:FlexLayout;


    public function MessageBoxMediator()
    {
    }


    override public function onRegister():void
    {
        view.page = page;
        view.responseSignal.add( closeMessageBoard );
    }


    public function closeMessageBoard( response:String ):void
    {
        view.destroy();
        contextView.removeChild( view );
    }

}
}