package;

import diagnositics.DiagnosticsManager;
import openfl.Lib;
import xpt.comms.services.UrlParams_service;
import xpt.error.ErrorMessage;
import xpt.screenManager.ScreenManager_web;
import xpt.start.WebStart;


class Xpt {

	
	public static inline var localExptDirectory:String = "experiments/";
	public static var exptName:String;
	
	private static var webStart:WebStart;
	
	public static function main() {
        System.init();
            
        ErrorMessage.setup(Lib.current.stage);
            
        //exptName = "Expt1";
        exptName = 'test';
        diagnositics.Timestamp.offset = diagnositics.Timestamp.get();
    
        DiagnosticsManager.add(DiagnosticsManager.EXPERIMENT_START, exptName);
            
        #if (debug && !html5)
            var tests:xpt.Tests = new xpt.Tests();
        #end

        #if html5
            ScreenManager_web.init(Lib.current.stage);

            var script:String = UrlParams_service.get('script');
            if (script.length > 0) {
                webStart = new WebStart('.', script);
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