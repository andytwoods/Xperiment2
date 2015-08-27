package xpt.stimuli;
import thx.Ints;
import xpt.tools.XML_tools;
import thx.Tuple.Tuple2;
import xpt.trial.TrialSkeleton;

/**
 * ...
 * @author 
 */
class BaseStimuli
{
	private static var permittedStimuli:Array<String>;
	
	static public function createSkeletonParams(skeletons:Array<TrialSkeleton>	)
	{
		var baseStim:BaseStimulus;
		var props:Map<String,String>;
		
		for (skeleton in skeletons) {
			skeleton.baseStimuli = new Array<BaseStimulus>();
			
			for (stimXML in XML_tools.getChildren(skeleton.xml)) {
				baseStim = new BaseStimulus(stimXML.nodeName.toLowerCase());

				if (permittedStimuli.indexOf(baseStim.name) != -1) {
					props = XML_tools.flattened_attribsToMap(stimXML);
					ETCs.compose(props, skeleton.trials.length, baseStim.howMany);
					
					baseStim.setProps(	props	);
					skeleton.baseStimuli[skeleton.baseStimuli.length] = baseStim;
				}
				/*else {
					trace('asking for unknown stimulus:', baseStim.name);
				}*/
			}
		}
	}
	
	static public function setPermitted(permitted:Array<String>) {
		for (str in permitted) {
			if (str.toLowerCase() != str) throw "permitted stimuli must all be specified in lowercase";
		}
		permittedStimuli = permitted;
	}
	
}

class BaseStimulus {
	
	public var name:String;
	public var props:Map<String,String>;
	public var howMany:Int = 1;
	
	
	
	public function new(nam:String) {
		this.name = nam;
	};
	
	
	public function setProps(_props:Map<String, String>) 
	{
		props = _props;
		if (props.exists("howMany")) {
			if (Ints.canParse(props.get("howMany"))) {
				howMany = Ints.parse(props.get("howMany"));
			}
			else throw "You must specify 'howMany' as a number";
		}
		
	}
	
}