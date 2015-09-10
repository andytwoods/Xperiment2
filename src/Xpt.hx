package;

import assets.manager.FileLoader;
import assets.manager.misc.FileInfo;
import assets.manager.misc.LoaderStatus;
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
import xpt2.core.entities.Experiment;


class Xpt extends Sprite 
{

	private var localExptDirectory:String = 'Z:/GitHub/Xperiment2/experiments/';
	
	public function new() 
	{

		super();
			
		/*
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
		
		var webStart:WebStart = new WebStart(dir,expt);
		*/
		
		//var loader:Loader = new FileLoader("Z:/GitHub/Xperiment2/experiments/poc/demo1.xml");
       
		var loader:FileLoader = new FileLoader();
		loader.loadText("Z:/GitHub/Xperiment2/experiments/poc/demo1.xml", function(f:FileInfo) {
			if (f.status == LoaderStatus.LOADED) {  // check for errors
				var xml:Xml = Xml.parse(cast(f.data, String));
				var e:Experiment = Experiment.fromXML(xml);
				trace(e.trials.length);
				for (trial in e.trials) {
					trace(trial.id);
					trace(trial.type);
				}
			}
			else {
				trace("COULD NOT LOAD XML");
			}
		});
		
		//below now in Tests.hx
		//System.exit(0);
	}
}
