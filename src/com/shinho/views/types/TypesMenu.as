package com.shinho.views.types
{

	import com.shinho.models.dto.TypesDTO;
	import com.shinho.util.SpriteUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;


	/**
	 * ...
	 * @author Nelson Alexandre
	 */
	public class TypesMenu extends Sprite
	{
		public var typeSelectedSignal:Signal = new Signal(int);
		private var _isDisplayed:Boolean = false;
		private var _buttonTypesHolder:Sprite;


		public function TypesMenu()
		{
		}



		public function destroy():void
		{
			SpriteUtils.removeAllChild(_buttonTypesHolder);
			_buttonTypesHolder.parent.removeChild(_buttonTypesHolder);
		}


		public function display(types:Vector.<TypesDTO>, currentType:uint):void
		{
			if (_isDisplayed)
			{
				destroy();
			}
			var typesMenuXPosIndex:int = 0 ;
			_buttonTypesHolder = new Sprite();
			addChild(_buttonTypesHolder);
			var buttonType:ButtonTypeView;
			for (var i:int = 0; i < types.length; i++)
			{
				buttonType = new ButtonTypeView(i, types[i].type);
				_buttonTypesHolder.addChild(buttonType);
				buttonType.setDeselected();
				buttonType.buttonMode = true;
				buttonType.y = 60;
				buttonType.x = typesMenuXPosIndex;
				buttonType.addEventListener(MouseEvent.CLICK, onButtonTypeSelected);
				typesMenuXPosIndex = typesMenuXPosIndex + buttonType.width;
				if (currentType == i)
				{
					buttonType.setSelected();
				}
			}
			_isDisplayed = true;
		}


		private function onButtonTypeSelected(event:MouseEvent):void
		{
			var typeSelected:ButtonTypeView = event.currentTarget as ButtonTypeView;
			typeSelectedSignal.dispatch(typeSelected.id);
		}
	}
}