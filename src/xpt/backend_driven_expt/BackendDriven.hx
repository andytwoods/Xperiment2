package xpt.backend_driven_expt;
import xpt.comms.services.UrlParams_service;
import xpt.tools.Base64;

class BackendDriven
{
	
	public static function process(script:String):String {
			var backend_extra:String = UrlParams_service.get('backend_extra');
						
			if (backend_extra.length == 0) {
				return script;
			}
			
			var decoded:String = Base64.decode(backend_extra);			
			script = StringTools.replace(script, '<backend_extra/>', decoded);
			
			trace(script);
			return script;
	}
	
}