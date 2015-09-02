package;

import hscript.Interp;
import hscript.Parser;
import openfl.display.Sprite;
import openfl.system.System;
import xpt.error.ErrorMessage;
import xpt.runner.Runner;
import xpt.start.WebStart;
import xpt.Tests;


class Xpt extends Sprite 
{

	private var localExptDirectory:String = 'C:/Users/Andy/Desktop/Xpt2/experiments/';
	
	public function new() 
	{

		super();
			
		
		ErrorMessage.setup(stage);
		WebStart.setup(stage);
		
		
		var expt:String = "test";
		var dir:String = '';
		#if debug
			dir = localExptDirectory;
			var tests:xpt.Tests = new xpt.Tests();
		#end
		
		var webStart:WebStart = new WebStart(dir,expt);

		
	
       
		
		System.exit(0);
	}
}
