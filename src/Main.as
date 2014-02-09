package 
{
	import api.Api;
	import controls.TemperatureIndicator;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import models.MainDataModel;
	import ru.marstefo.reactor.Backdrop;
	import ru.marstefo.reactor.gui.Temperatures;
	import reactor.Reactor;
	/**
	 * ...
	 * @author liss
	 */
	public class Main extends Sprite 
	{
		private var _model:MainDataModel;
		private var _controller:Controller;
		
		public function Main():void 
		{
			//init profiler
			//SWFProfiler.init(stage,this);
			
			//load config
			Api.getInstance().loadConfig('data/config.xml',onConfig,onError);
		}
		
		private function onError(e:String):void { trace(e) };
		
		private function onConfig(data:XML):void
		{
			//set server url
			Api.getInstance().serverUrl = data.server_url.toString();
			
			//set data model
			_model = new MainDataModel(data.constants,data.init_variables);
			_controller = new Controller(_model);
			
			//draw UI
			buildUI();
			
			addEventListener(Event.ENTER_FRAME, EF);
			
			stage.addEventListener(MouseEvent.CLICK, clear);
		}
		
		private function clear(e:MouseEvent):void
		{
			if (e.target == stage) _controller.clearSelection();
		}
		
		private function EF(e:Event):void
		{
			_controller.update();
		}
		
		private function buildUI():void
		{
			var bg:Backdrop = new Backdrop;
			
			addChild(bg);
			
			var _reactor:Reactor = new Reactor(_model, _controller);
			addChild(_reactor);
		/*	
			var _selector:RodGroupSelector = new RodGroupSelector(_reactor.groups, _controller);
			addChild(_selector);
			
			var _turbine:TurbineSystem = new TurbineSystem(_model, _controller);
			_turbine.x = 800;
			_turbine.y = 100;
			addChild(_turbine);
			
			var _controlPanel:ControlPanel = new ControlPanel(_model, _controller, 600, 200);
			addChild(_controlPanel);
			
			var genWindow:TurbineControlPanel = new TurbineControlPanel(_model, _controller, this);
			
			var ti:GFXControlPanel = new GFXControlPanel(_model, _controller);
			ti.x = 700;
			ti.y=300
			
			addChild(ti);
			
			*/
			
		}
		
	}
	
}






