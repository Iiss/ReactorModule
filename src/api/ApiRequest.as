package api
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import org.osflash.signals.natives.NativeSignal;
	/**
	 * ...
	 * @author liss
	 */
	public class ApiRequest
	{
		private var _loader				:URLLoader = new URLLoader;
		private var _req				:URLRequest;
		private var _params				:URLVariables;
		private var _onComplete			:NativeSignal;
		private var _onError			:NativeSignal;
		private var _onSecurityError	:NativeSignal;
		private var _dataType			:String;
		private var _completeCB			:Function;
		private var _errorCB			:Function;
		
		public function ApiRequest() 
		{
			_onComplete 		= new NativeSignal(_loader, Event.COMPLETE, Event);
			_onError 			= new NativeSignal(_loader, IOErrorEvent.IO_ERROR,IOErrorEvent);
			_onSecurityError	= new NativeSignal(_loader, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent);
		}
		
		/**
		 * Request sender
		 * @param	url
		 * @param	params
		 * @param	completeCB
		 * @param	errorCB
		 * @param	dataFormat
		 * @param	method
		 */
		public function send(url:String, params:Object = null, completeCB:Function = null, errorCB:Function = null,
								dataFormat:String='text',method:String='GET'):void
		{
			_req = new URLRequest(url);
			_req.method = method;
			_dataType = dataFormat;
			_loader.dataFormat = dataFormat;
			
			_onComplete.addOnce(onComplete);
			_onError.addOnce(onError);
			_onSecurityError.addOnce(onError);
			
			_completeCB = completeCB;
			_errorCB = errorCB;
			
			if (params)
			{
				_params = new URLVariables;
				
				for (var p:String in params)
				{
					_params[p] = params[p];
				}
				
				_req.data = _params;
			}
			
			_loader.load(_req);
		}
		
		/**
		 * Complete listener
		 * @param	evt
		 */
		private function onComplete(evt:Event):void
		{
			if (_completeCB == null) return;
			
			if (_dataType == 'xml')
			{
				try 
				{ 
					_completeCB(XML(_loader.data));
				} 
				catch (e:Error)
				{
					onError(e);
				}
			}
			else _completeCB(_loader.data);
			
		}
		
		/**
		 * Error listener
		 * @param	e
		 */
		private function onError(e:*):void
		{
			trace(_errorCB)
			if (_errorCB == null) return;
			
			switch(true)
			{
				case e is IOErrorEvent: 		_errorCB(e.text); 		break; 
				case e is SecurityErrorEvent: 	_errorCB(e.text); 		break;
				case e is Error: 				_errorCB(e.message); 	break;
			}
			
		}
		
	}

}