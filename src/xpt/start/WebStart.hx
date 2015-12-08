package xpt.start;
import assets.manager.FileLoader;
import assets.manager.misc.FileInfo;
import assets.manager.misc.LoaderStatus;
import openfl.utils.Dictionary;
import openfl.utils.Object;
import xpt.error.ErrorMessage;
import xpt.runner.Runner;

/**
 * ...
 * @author ...
 */
class WebStart 
{
	
	public function kill():Void {
		
	}

	public function new(dir:String, exptName:String, overrideDir:Bool = false) 
	{

		var loader = new FileLoader();

		if (overrideDir == false) {
			loader.loadText(dir + exptName + "/" + exptName+".xml", listen);
		}
		else {
			loader.loadText(dir + "/" + exptName, listen);
		}
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
			try{
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
		
			var runner:Runner = exptPlatform();
			runner.run(script);
			
			
		}
		

	
}

