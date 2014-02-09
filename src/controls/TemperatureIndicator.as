package controls 
{
	import flash.display.Sprite;
	import models.MainDataModel;
	import ru.marstefo.reactor.gui.Temperatures;
	/**
	 * ...
	 * @author liss
	 */
	public class TemperatureIndicator
	{
		private var _roomMask:Sprite;
		private var _reactorMask:Sprite;
		private var _liquidMask:Sprite;
		
		private var _roomRange:Range;
		private var _reactorRange:Range;
		private var _liquidRange:Range;
		
		private var _model:MainDataModel;
		
		public function TemperatureIndicator(view:Temperatures,model:MainDataModel) 
		{
		
			_model = model;
		}
		
		public function get roomRange():Range { return _roomRange; }
		public function set roomRange(value:Range):void
		{
			_roomRange = value;
			update();
		}
		
		public function get reactorRange():Range { return _reactorRange; }
		public function set reactorRange(value:Range):void
		{
			_reactorRange = value;
			update();
		}
		
		public function get liquidRange():Range { return _liquidRange; }
		public function set liquidRange(value:Range):void
		{
			_liquidRange = value;
			update();
		}
		
		
		public function update():void
		{
			if (_roomRange)
			{
				
			};
			if (_reactorRange) { };
			if (_liquidRange) { };
		}
	}

}