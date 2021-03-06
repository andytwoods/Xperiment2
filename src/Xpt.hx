package;

import diagnositics.DiagnosticsManager;
import openfl.Lib;
import xpt.comms.services.UrlParams_service;
import xpt.error.ErrorMessage;
import xpt.start.WebStart;
import xpt.tools.XRandom;
import xpt.tools.XTools;


class Xpt {

	
	
	public static inline var localExptDirectory:String = "experiments/";
	public static var exptName:String;
	
	private static var webStart:WebStart;
	
	public static function main() {

		XRandom.init(RandomAlgorithm.Mersenne);
		System.init();

		//exptName = 'transparent';
        //exptName = 'tastePosition';
		//exptName = "Expt1";
        //exptName = 'test';
		//exptName = 'twinSmokers';
		//exptName = 'ShapeApproachAvoidance';
		//exptName = 'testLogos';
		//exptName = 'evolve1';
        //exptName = "colourService";
		//exptName = "colourService2";
		//exptName = "colourService3";
		//exptName = "dLogo";
		//exptName = "eyeGaze1";
		//exptName = "KT1";
		//exptName = "nColours";
		//exptName = 'backendDriven';
		//exptName = 'tastePosition2';
		//exptName = 'seasons1';
		//exptName = 'drop';
		//exptName = 'michel1';
		//exptName = 'lineVbox1';
		//exptName = 'magic1';
		//exptName = 'BoubaKikiXpt2_1';
		exptName = 'mBurt';
		//exptName = 'boubaKiki_icecream';
		//exptName = 'choiceLund';
		//exptName = 'choiceLundPoliticalIssues';
		
		#if html5
			var force_exptName = UrlParams_service.get('exptName');
			if (force_exptName != '') exptName = force_exptName;
		#end
		
		
		diagnositics.Timestamp.offset = diagnositics.Timestamp.get();
		
		
        DiagnosticsManager.add(DiagnosticsManager.EXPERIMENT_START, exptName);
		
        #if (debug && !html5)
            var tests:xpt.Tests = new xpt.Tests(start);
        #end

        #if html5
            var script:String = UrlParams_service.get('script');
            if (script.length > 0) {
				XRandom.setSeed(UrlParams_service.get('seed'));
                webStart = new WebStart('./.', script, true);
            }
            else {
				var local_expt_dir = UrlParams_service.get('local_expt_dir');
                start('' + local_expt_dir);
            }
        
        #elseif !debug
            start();
        #end
	}
	
	
	
	private static function start(local_expt_dir = '') {
		trace("---starting study---");
		XRandom.setSeed('random');
		webStart = new WebStart(localExptDirectory, exptName, false, local_expt_dir);
	}
}