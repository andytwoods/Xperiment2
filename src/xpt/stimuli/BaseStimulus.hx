package xpt.stimuli;
import thx.Ints;
import xpt.tools.ScriptTools;


class BaseStimulus {
	
	public var type:String;
	public var props:Map<String,String>;
	public var howMany:Int = 1;
	public var children:Array<BaseStimulus> = [];
	
	
	
	public function new(nam:String) {
		this.type = nam;
	};
	
	
	public function setProps(_props:Map<String, String>) 
	{
		props = _props;
		if (props.exists("howMany")) {
            var howManyString = ScriptTools.expandScriptValues(props.get("howMany"));
			if (Ints.canParse(howManyString)) {
				howMany = Ints.parse(howManyString);
			}
			else throw "You must specify 'howMany' as a number";
		}
		
	}
	

}