package xpt;

/**
 * ...
 * @author 
 */
import code.Test_CheckIsCode;
import xpt.script.Test_ETCs;
import xpt.script.Test_BetweenSJs;
import xpt.script.templateHelpers.Test_templateList;
import xpt.script.Test_Templates;
import xpt.tools.Test_XML_Tools;
import utest.Runner;
import utest.ui.Report;
import utest.ui.common.HeaderDisplayMode;
import xpt.tools.Test_XTools;
import xpt.trial.Test_NextTrialBoss;
import xpt.trialOrder.Test_DepthNode;
import xpt.trialOrder.Test_DepthNodeBoss;
import xpt.trialOrder.Test_SlotInForcePositions;
import xpt.trialOrder.Test_TrialBlock;
import xpt.trialOrder.Test_TrialOrder;
import xpt.trialOrder.Test_TrialOrderTools;

 
class Tests
{

	public function new() 
	{
				
		var runner = new Runner();
		runner.addCase(new Test_XML_Tools());
		runner.addCase(new Test_XTools());
		runner.addCase(new Test_TrialOrder());
		runner.addCase(new Test_TrialBlock());
		runner.addCase(new Test_DepthNode());
		runner.addCase(new Test_DepthNodeBoss());
		runner.addCase(new Test_SlotInForcePositions());
		runner.addCase(new Test_TrialOrderTools());
		runner.addCase(new Test_NextTrialBoss());
		runner.addCase(new Test_BetweenSJs());
		runner.addCase(new Test_templateList());
		runner.addCase(new Test_Templates());
		runner.addCase(new Test_ETCs());
		runner.addCase(new Test_CheckIsCode());
		
		Report.create(runner,NeverShowSuccessResults,AlwaysShowHeader);
		runner.run();
	}
	
}