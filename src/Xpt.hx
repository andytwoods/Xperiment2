package;

import code.Code;
import hscript.Interp;
import hscript.Parser;
import openfl.display.Sprite;
import openfl.system.System;
import xpt.error.ErrorMessage;
import xpt.runner.Runner;
import xpt.start.WebStart;
import xpt.Tests;
import xpt.trial.Trial;


class Xpt extends Sprite 
{

	private var localExptDirectory:String = 'C:/Users/Andy/Desktop/Xpt2/XptHaxe/XptHaxe/experiments/';
	
	public function new() 
	{

		super();
			
		
		ErrorMessage.setup(stage);
		
		
		var expt:String = "test";
		var dir:String = localExptDirectory;
		
		#if debug
			Trial.testing = true;
			Code.testing = true;
			var tests:xpt.Tests = new xpt.Tests();
			Trial.testing = false;
			Code.testing = false;
		#end
		
		//var webStart:WebStart = new WebStart(dir,expt);


       
		//below now in Tests.hx
		//System.exit(0);
	}
}
