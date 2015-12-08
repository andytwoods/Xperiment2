package comms.services;

/**
 * ...
 * @author 
 */
class UrlParams_service
{

	public static var params:Map<String,String>;

	
	
	public static function init() {
		#if html5
			var query:String = StringTools.urlDecode(js.Browser.window.location.search.substring(1));
			
			var paramsList = query.split("&");
			params = new Map<String,String>();
			
			
			var arr:Array<String>;
			var nam:String;
			var val:String;

			for (item in paramsList) {
				
				arr = item.split("=");
				var nam = arr[0];
				var val = arr[1];
				
				params.set(nam, val);

			}

			#if debug
				trace(params);
			#end
			
	    #end

	}

		
	
	public static function get(what:String):String {
		#if html5
			if (params == null) init();
			if (params.exists(what)) return params.get(what);
		#end
		return '';
	}
		
	
	
}