package xpt.trialOrder;
import thx.Ints;
import xmlTools.E4X;
import xpt.tools.XML_tools;
import thx.Tuple.Tuple2;
import xpt.tools.XTools;
import xpt.trial.TrialSkeleton;
import xpt.trialOrder.TrialBlock;


class TrialOrder
{
	static private var trial_sep:String;
	public function new() { };
	
	public function COMPOSE(script:Xml):Tuple2<	Array<Int>,	Array<TrialSkeleton>	>
	{
		var trialBlocks:Array<TrialBlock> = [];
		
		
		var blockXMLs:Array<Xml> = XTools.iteratorToArray(XML_tools.findNode(script, "TRIAL")) 	;
		
		
		__add_overTrial_blocks(blockXMLs);
		
		
		var trialBlock:TrialBlock;
		var i:Int = 0;
		var counter:Int = 0;
		var skeletons:Array<TrialSkeleton> = [];
		
		for (block in blockXMLs) {

			//not happy about the below. But keeps independence from the overall script I guess. 
			//this method may work: xml.elementsNamed("TRIAL")
			block = Xml.parse(block.toString()); 
			
			trialBlock = new TrialBlock();

			trialBlock.setup(block, counter, i++);

			if (trialBlock.numTrials > 0) {
				trialBlocks[trialBlocks.length] = trialBlock;
				counter += trialBlock.numTrials;
			}
			
			skeletons[skeletons.length] = new TrialSkeleton(trialBlock);
			
		}
		
		var trialOrderTools:TrialOrderTools = new TrialOrderTools();
		var trialOrder:Array<Int> = trialOrderTools.composeOrder(trialBlocks);
		
		
		return new Tuple2(trialOrder, skeletons);
		
	}
	
	
	public static function __add_overTrial_blocks(blockXMLs:Array<Xml>) 
	{
		var trial_iteration:Int = 0;

		var trials:Array<String>;
		
		var copyXml:Xml;
		var addBack:Array<Xml> = null;
		var remove:Array<Xml> = null;
		var split:String;
		var blockArr:Array<String>;
		var block:Xml;
		for (i in 0...blockXMLs.length) {
			block = blockXMLs[i];
			var blo:String = XML_tools.findAttr(block, "block"); 
			if (blo !=null && blo.indexOf(trial_sep) != -1) {
				if (addBack == null) {
					addBack = new Array<Xml>();
					remove = new Array<Xml>();
				}
				blockArr = blo.split(trial_sep);
				
				var trialsStr:String = XML_tools.findAttr(block, "trials");

				if (trialsStr == null) trialsStr = '1';
				trials = trialsStr.split(trial_sep);
				
				for (trial_iteration in 0...blockArr.length) {

					split = blockArr[trial_iteration];

					copyXml = Xml.parse(block.toString());
					copyXml.firstChild().set("block", split);
					copyXml.firstChild().set("trials", Std.string(trials[trial_iteration%trials.length]));

					__update_overTrials_allAttribs(copyXml, trial_iteration );
					addBack.push(copyXml);
					remove.push(block);
				}
			}
		}

		if (addBack != null) {
			while (remove.length > 0) {
				blockXMLs.remove(remove.shift());
			}
			while (addBack.length > 0) {
				blockXMLs.push(addBack.shift());
			}
		}
	}
	
	public static function __update_overTrials_allAttribs(xml:Xml, i:Int) 
	{
		var val:String;
		for (x in E4X.x(xml.desc())) {
			if (x != null) {
				if ( x.nodeType == Xml.Element) {
				
					for (attrib in x.attributes()) {
						val = x.get(attrib);
						if (val.indexOf(trial_sep) != -1) {
							val = XTools.multiCorrection(val, trial_sep, i);
							x.set(attrib, val);
						}
					}
					
					
				}
			}
		}
	}
	
	
	public static function setLabels(_trial_sep:String) 
	{
		trial_sep = _trial_sep;
	}

	
}