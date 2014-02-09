package reactor 
{
	import flash.display.MovieClip;
	import models.MainDataModel;
	import models.RodDataModel;
	/**
	 * ...
	 * @author liss
	 */
	public class Rod
	{
		private var _gfx:MovieClip;
		private var _rodModel:RodDataModel;
		private var _view:MovieClip;
		private var _selected:Boolean;
		
		public function Rod(view:MovieClip,rodModel:RodDataModel,controller:Controller) 
		{
			_gfx = view;
			_gfx.gotoAndStop(1);
			
			_rodModel = rodModel;
			controller.addReactorElementDataModel(_rodModel);
		}
		
		public function get group():int
		{
			return _rodModel.group;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void
		{
			if (_selected == value) return;
			_selected = value;
			
			_selected ? _gfx.gotoAndStop(2) : _gfx.gotoAndStop(1);
		}
		
		public function update():void 
		{
			super.update();				
		}
		
	}

}