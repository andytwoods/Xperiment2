package xpt.stimuli;
import xpt.debug.DebugManager;
import xpt.tools.XML_tools;
import thx.Tuple.Tuple2;
import xpt.tools.XTools;
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
		var children:Array<Xml>;
		
		for (skeleton in skeletons) {
			children = XTools.iteratorToArray( XML_tools.getChildren(skeleton.xml) );
			skeleton.baseStimuli = _generateStimuli(children, skeleton.trials.length); 
			}
		}
		
	public function _generateStimuli(xmlList:Array<Xml>,numTrials:Int):Array<BaseStimulus>
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
		
		var children:Array<Xml> = XTools.iteratorToArray( XML_tools.getChildren(stimXML) );

		
		var props:Map<String,String> = XML_tools.flattened_attribsToMap(stimXML, permittedStimuli);
		
		var nodeName:String;
		var nodeVal:String;
		
		for (child in children) {
		
			if (child.nodeType == Xml.Element) {
				nodeName = child.nodeName;
				trace(nodeName, 33);
				if (nodeName.charAt(0) == ".") {
					nodeVal = child.firstChild().nodeValue;
					props.set(nodeName.substr(1), XTools.removeProtectedTextIndicators(nodeVal));
					children.remove(child);
				}
				
			}
		}
		
		baseStim.children = _generateStimuli(children , numTrials);
		
		//var nodeVal:String = XML_tools.getNodeVal(stimXML);
		//if (nodeVal != null) props.set('nodeValue', nodeVal);
		
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
