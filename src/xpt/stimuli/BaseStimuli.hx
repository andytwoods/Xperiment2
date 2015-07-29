package xpt.stimuli;
import script.XML_tools;
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
		var stim:BaseStimulus;
		var props:Map<String,String>;
		
		for (skeleton in skeletons) {
			skeleton.baseStimuli = new Array<BaseStimulus>();
			
			for (stimXML in XML_tools.getChildren(skeleton.xml)) {
				stim = new BaseStimulus(stimXML.nodeName.toLowerCase());
				if (permittedStimuli.indexOf(stim.name) != -1) {
					props = XML_tools.AttribsToMap(stimXML);
					stim.setProps(	props	);
					skeleton.baseStimuli[skeleton.baseStimuli.length] = stim;
				}
			}
		}
	}
	
	static public function setPermitted(permitted:Array<String>) {
		permittedStimuli = permitted;
	}
	
}

class BaseStimulus {
	
	public var name:String;
	public var props:Map<String,String>;
	
	
	
	
	public function new(nam:String) {
		this.name = nam;
	};
	
	
	public function setProps(_props:Map<String, String>) 
	{
		props = _props;
	}
	
}