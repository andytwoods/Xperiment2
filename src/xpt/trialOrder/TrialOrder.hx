package xpt.trialOrder;
import xpt.tools.XML_tools;
import thx.Tuple.Tuple2;
import xpt.tools.XTools;
import xpt.trial.TrialSkeleton;

/**
 * ...
 * @author 
 */
class TrialOrder
{
	static public function COMPOSE(script:Xml):Tuple2<	Array<Int>,	Array<TrialSkeleton>	>
	{
		var trialBlocks:Array<TrialBlock> = [];
		
		
		var blockXMLs:Iterator<Xml> = XML_tools.findNode(script, "TRIAL") 	;
		var trialBlock:TrialBlock;
		
		var i:Int = 0;
		var counter:Int = 0;
		
		var skeletons:Array<TrialSkeleton> = [];
		var block:Xml;
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
			//trace("---", trialBlock.trials,block);
			skeletons[skeletons.length] = new TrialSkeleton(trialBlock);
			//trace("---", skeletons[skeletons.length - 1].trials);
			
		}
		
		var trialOrder:Array<Int> = TrialOrderTools.composeOrder(trialBlocks);
		
		
		return new Tuple2(trialOrder, skeletons);
		
	}

	
}