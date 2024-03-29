package reactor 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import models.MainDataModel;
	import models.RodDataModel;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author liss
	 */
	public class Rod
	{
		private var _gfx:MovieClip;
		private var _rodData:RodDataModel;
		private var _view:MovieClip;
		private var _selected:Boolean;
		private var _controller:Controller;
		public var onClick:NativeSignal;
		
		public function Rod(view:MovieClip,rodModel:RodDataModel,mainModel:MainDataModel,controller:Controller) 
		{
			_controller = controller;
			mainModel.onUpdate.add(update);
			
			_gfx = view;
			_gfx.mouseChildren = false;
			_gfx.gotoAndStop(1);
			
			onClick = new NativeSignal(_gfx, MouseEvent.CLICK, MouseEvent);
			onClick.add(onMouseClick);
			
			_rodData = rodModel;
			controller.addReactorElementDataModel(_rodData);
		}
		
		public function get group():int
		{
			return _rodData.group;
		}
		
		public function update():void 
		{
			_rodData.selected ? _gfx.gotoAndStop(2) : _gfx.gotoAndStop(1);				
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (!_rodData.selected)
			{
				_controller.clearSelection();
				_controller.pushSelection(_rodData);
			}
		}
	}
}