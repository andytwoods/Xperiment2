package;

import code.Code;
import openfl.display.Sprite;
import xpt.error.ErrorMessage;
import xpt.start.WebStart;
import xpt.Tests;
import xpt.trial.Trial;


class Xpt extends Sprite {

	private var localExptDirectory:String = "./experiments/";
	
	public function new() {
		super();
		
		System.init();
		ErrorMessage.setup(stage);
		
		var expt:String = "test";
		var dir:String = localExptDirectory;
		
		#if debug
			/*
			Trial.testing = true;
			Code.testing = true;
			var tests:xpt.Tests = new xpt.Tests();
			Trial.testing = false;
			Code.testing = false;
			*/
		#end
		
		var webStart:WebStart = new WebStart(dir, expt);
	}
}
