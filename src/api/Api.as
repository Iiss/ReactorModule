package api
{
	import api.ApiRequest
	/**
	 * ...
	 * @author liss
	 */
	public class Api 
	{
		private static var _allowInstance:Boolean = false;
		private static var _instance:Api
		private var _req:ApiRequest;
		
		public var serverUrl:String;
		
		public static function getInstance():Api
		{
			if (!_instance)
			{
				Api._allowInstance = true;
				_instance = new Api;
				Api._allowInstance = false;
			}
			
			return _instance;
		}
		
		public function Api() 
		{
			if (!Api._allowInstance) 
			{
				throw new Error('Error: Use SoundManager.getInstance() instead of the new keyword.'); 
			}
			
			_req = new ApiRequest;
		}
		
		/**
		 * Commands
		 */
		public function loadConfig(url:String, onComplete:Function=null, onError:Function=null):void
		{
			_req.send(url, null, onComplete, onError, 'xml');
		}
		
		public function sendPower(power:Number, onComplete:Function=null, onError:Function=null):void
		{
			_req.send(serverUrl, { power:Math.round(power) }, onComplete, onError);
		}
		
	}

}