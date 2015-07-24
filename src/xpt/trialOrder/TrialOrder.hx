package xpt.trialOrder;
import script.XML_tools;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class TrialOrder
{
	static public function DO(script:Xml):Array<Int>
	{
		var trialBlocks:Array<TrialBlock> = [];
		
		
		var blockXMLs:Iterator<Xml> = XML_tools.findNode(script, "TRIAL") 	;
		var trialBlock:TrialBlock;
		
		var i:Int = 0;
		var counter:Int = 0;
		for (block in blockXMLs) {
			
			trialBlock = new TrialBlock();

			trialBlock.setup(block, counter, i++);

			if(trialBlock.numTrials>0){
				trialBlocks[trialBlocks.length] = trialBlock;
				counter += trialBlock.numTrials;
			}
			
		}
		
		
		return TrialOrderTools.composeOrder(trialBlocks);
		
	}

	
}