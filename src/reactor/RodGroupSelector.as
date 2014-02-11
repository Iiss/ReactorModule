package reactor 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import org.osflash.signals.natives.NativeSignal;
	import ru.marstefo.reactor.gui.RodGroupSelectorPanel;
	/**
	 * ...
	 * @author liss
	 */
	public class RodGroupSelector
	{
		private var _controller:Controller;
		private var _groups:Dictionary;
		public var onClick:NativeSignal;
		
		public function RodGroupSelector(view:RodGroupSelectorPanel,groupsMap:Dictionary, controller:Controller) 
		{
			_groups = groupsMap;
			_controller = controller;
			onClick = new NativeSignal(view, MouseEvent.CLICK, MouseEvent);
			onClick.add(clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var btn:DisplayObject = e.target as DisplayObject
			if (_groups[btn])
			{
				_controller.clearSelection();
				_controller.pushSelection(_groups[btn]);
			}
		}

	}

}