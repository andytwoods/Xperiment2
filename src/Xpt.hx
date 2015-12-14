package;

import code.Code;
import comms.services.UrlParams_service;
import haxe.macro.Compiler;
import openfl.Lib;
import screenManager.ScreenManager_web;
import xpt.error.ErrorMessage;
import xpt.start.WebStart;
import xpt.trial.Trial;


class Xpt {

	
	public static inline var localExptDirectory:String = "experiments/";
	public static var exptName:String;
	private static var webStart:WebStart;
	
	public static function main() {
		System.init();
		ErrorMessage.setup(Lib.current.stage);
		exptName = "test";
		
		

		#if (debug && !html5)
		
			Trial.testing = true;
			Code.testing = true;
			var tests:xpt.Tests = new xpt.Tests();
			Trial.testing = false;
			Code.testing = false;
		#end
		
		#if html5
			ScreenManager_web.init(Lib.current.stage);
			var script:String = UrlParams_service.get('script');
			if (script.length > 0) {
				webStart = new WebStart('.', script, true);
			}
			else {
				start();
			}
		
		#else
			start();
		#end

		
	}
	
	private static function start() {
		webStart = new WebStart('./' + localExptDirectory, exptName);
	}
}
