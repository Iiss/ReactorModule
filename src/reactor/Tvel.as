package reactor 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import models.MainDataModel;
	import models.TvelDataModel;
	import ru.marstefo.reactor.gui.Tvs;
	/**
	 * ...
	 * @author liss
	 */
	public class Tvel extends Sprite 
	{
		private var _gfx:Tvs
		private var _core:MovieClip
		private var _glow:Sprite;
		private var _tvelData:TvelDataModel;
		private var _mainModel:MainDataModel;
		
		public function Tvel(model:MainDataModel, controller:Controller) 
		{
			//super(model, controller);
			
			_gfx = new Tvs;
			_gfx.width = _gfx.height = 99.2;
		/*	_gfx.gotoAndStop(1);
			_core = _gfx['h'];
			_core.gotoAndStop(1);
			_glow = _gfx['glow'];
			*/
			//TODO: check this out
		//	_core.alpha = .4;
			addChild(_gfx);
		
			_mainModel = model;
			
			_tvelData = new TvelDataModel;
			controller.addReactorElementDataModel(_tvelData);
			
			
		/*	var hit:Sprite = new Sprite;
			hit.graphics.beginFill(0xff0000, 0);
			hit.graphics.drawCircle(0, 0, 70);
			hit.graphics.endFill();
			addChild(hit);
			
			hitArea	= hit;*/
		}
		
		//override 
		public function set selected(value:Boolean):void
		{
		/*	if (_selected == value) return;
			_selected = value;
			
			_selected ? _gfx.gotoAndStop(2) : _gfx.gotoAndStop(1);*/
		}
		
		//override
		public function update():void 
		{
		//	durability < 10 ? _core.gotoAndStop(2) : _core.gotoAndStop(1);
		//	_glow.alpha = _model.t1/10000;
			
		//	_gfx['shad'].scaleX=_gfx['shad'].scaleY=_core.scaleX = _core.scaleY = .2+deep*0.008;
			
		//	super.update();
		}
		
	}

}