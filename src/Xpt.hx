package;

import hscript.Interp;
import hscript.Parser;
import openfl.display.Sprite;
import openfl.system.System;
import ru.stablex.ui.UIBuilder;
import xpt.error.ErrorMessage;
import xpt.runner.Runner;
import xpt.start.WebStart;


class Xpt extends Sprite 
{

	private var localExptDirectory:String = 'C:/Users/Andy/Desktop/Xpt2/experiments/';
	
	public function new() 
	{

		super();
			
		UIBuilder.init();
		
		ErrorMessage.setup(stage);
		WebStart.setup(stage);
		
		
		var expt:String = "test";
		var dir:String = '';
		#if debug
			dir = localExptDirectory;
			var tests:tests.Tests = new tests.Tests();
		#end
		
		var webStart:WebStart = new WebStart(dir,expt);

		
		System.exit(0);
	}
}
