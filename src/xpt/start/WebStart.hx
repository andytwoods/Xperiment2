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

	public function new(dir:String, exptName:String) 
	{

		var loader = new FileLoader();

		loader.loadText(dir + exptName + "/" + exptName+".xml", listen);
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
		
		var params = new Map();
		var script:Xml;
		var prop:String;

		if(str.length>0){
			var arr:Array<String> = str.split('---end script---');
			if(arr.length>1){
				script = Xml.parse(arr[0]);
				var strSplit:Array<String>;
				for (str in arr[1].split("\n")){
					strSplit=str.split(":");
					if (strSplit.length > 1) {
						prop = strSplit[0];
						params.set(prop, strSplit[1]);
					}
				}
			}
			else script = Xml.parse(str);
			
			startExpt(script,params);
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
	
	private function modifyParams(params:Object):Void {
	}
	
	
	public function startExpt(script:Xml, params:Object):Void
		{
			
			modifyScript(script);
			modifyParams(params);

			var expt:Runner = exptPlatform();
			expt.run(script, null, params);
			
			
		}
		

	
}

