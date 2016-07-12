package xpt.start;
import assets.manager.FileLoader;
import assets.manager.misc.FileInfo;
import assets.manager.misc.LoaderStatus;
import openfl.utils.Dictionary;
import openfl.utils.Object;
import xpt.backend_driven_expt.BackendDriven;
import xpt.error.ErrorMessage;
import xpt.runner.Runner;
import xpt.tools.PathTools;
import xpt.tools.XTools;
import xpt.comms.services.UrlParams_service;

/**
 * ...
 * @author ...
 */
class WebStart 
{
	
	public function kill():Void {
		
	}

	public function new(dir:String, exptName:String, overrideDir:Bool) 
	{
        var combined_expt_name:String;
		
		if (overrideDir) {	
			PathTools.explictExptPath(exptName);		
			combined_expt_name = exptName;
		}
		
        else {
			PathTools.experimentPath = dir;
			PathTools.experimentName = exptName;
			combined_expt_name = dir + exptName + "/" + exptName+".xml";
		}
		

		#if html5
			var check_script_exists:Bool = untyped x_utils != undefined && x_utils['expt_script'] != undefined;
			if (check_script_exists == true) {
				processScript(untyped x_utils['expt_script']);
				return;
			}
		#end
		
		load_script(combined_expt_name);

	}
	
	private function load_script(nam:String) {
		var loader = new FileLoader();
		loader.loadText(nam, listen);
	}
	
	private function listen(f:FileInfo):Void {
		

		if (f.status == LoaderStatus.LOADED) {  // check for errors
			processScript(cast(f.data, String));
		}
		else {
			ErrorMessage.error(ErrorMessage.Report_to_experimenter, "could not load script");
		}
	}
	
	function processScript(str:String):Void {
		var script:Xml;
		if (str.length > 0) {
			
			str = BackendDriven.process(str);
			XTools.protectCodeBlocks(str, 'code');
			
			try {
				
				script = Xml.parse(str);
			}
			catch (e:String) {
				script = Xml.parse(''); //annoying bodge to allow for non-nested try statements
				ErrorMessage.error(ErrorMessage.Report_to_experimenter, "loaded script, but it was malformed (not proper xml).");
			}
			
			startExpt(script);
			kill();
		}
		else {
			ErrorMessage.error(ErrorMessage.Report_to_experimenter, "loaded script, but it was empty.");
		}
	}


	
	public function exptPlatform():Runner {
		var runner:Runner = new Runner();
		return runner;
	}
	
	
	private function modifyScript(script:Xml):Void {
	}
	

	
	public function startExpt(script:Xml):Void
		{

			modifyScript(script);

			var expt:Runner = exptPlatform();
			expt.run(script);
			
			
		}
		

	
}

