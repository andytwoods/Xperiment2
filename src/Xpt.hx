package;

import code.Code;
import openfl.Lib;
import xpt.error.ErrorMessage;
import xpt.start.WebStart;
import xpt.trial.Trial;


class Xpt {

	private static var localExptDirectory:String = "./experiments/";
	
	public static function main() {
		System.init();
		ErrorMessage.setup(Lib.current.stage);
		
		var expt:String = "test";
		var dir:String = localExptDirectory;

		#if debug
			Trial.testing = true;
			Code.testing = true;
			var tests:xpt.Tests = new xpt.Tests();
			Trial.testing = false;
			Code.testing = false;
		#end
		
		var webStart:WebStart = new WebStart(dir, expt);
	}
}
