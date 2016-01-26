package xpt.stimuli;
import xpt.debug.DebugManager;
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
	
	public function new() { }
	
	public function createSkeletonParams(skeletons:Array<TrialSkeleton>	)
	{

		for (skeleton in skeletons) {
			skeleton.baseStimuli = _generateStimuli(XML_tools.getChildren(skeleton.xml), skeleton.trials.length); 
			}
		}
		
	public function _generateStimuli(xmlList:Iterator<Xml>,numTrials:Int):Array<BaseStimulus>
	{
		var baseStimuli = new Array<BaseStimulus>();
		var baseStim:BaseStimulus;
		var nam:String;
				
		for (stimXML in xmlList) {
						
			if(stimXML.nodeType == Xml.Element){
			
				nam = XML_tools.nodeName(stimXML).toLowerCase();
				if (permittedStimuli.indexOf(nam) != -1) {
					
					baseStim = _composeBaseStim(nam, stimXML,numTrials);
					
					if(baseStim!=null)	baseStimuli[baseStimuli.length] = baseStim;
				} else {
                    #if debug
                    DebugManager.instance.warning("Unknown stim: " + nam);
                    #end
				}
			}
		}
		return baseStimuli;
	}
	
	
	
	
	public inline function _composeBaseStim(nam:String, stimXML:Xml, numTrials:Int):BaseStimulus
	{
		var baseStim = new BaseStimulus(nam);
		
		baseStim.children = _generateStimuli(XML_tools.getChildren(stimXML) , numTrials);
		
		var props:Map<String,String> = XML_tools.flattened_attribsToMap(stimXML,permittedStimuli);
		ETCs.compose(props, numTrials, baseStim.howMany);
		baseStim.setProps(	props	);
		return baseStim;
	}
	
	
	static public function setPermittedStimuli(permitted:Array<String>) {
		for (str in permitted) {
			if (str.toLowerCase() != str) throw "permitted stimuli must all be specified in lowercase";
		}
		permittedStimuli = permitted;
	}
	
}
