package xpt;

/**
 * ...
 * @author 
 */
import code.Test_CheckIsCode;
import code.Test_HScriptLayer;
import openfl.events.Event;
import openfl.system.System;
import xpt.results.Test_Results;
import xpt.results.Test_TrialResults;
import xpt.script.Test_ETCs;
import xpt.script.Test_BetweenSJs;
import xpt.script.templateHelpers.Test_templateList;
import xpt.script.Test_Templates;
import xpt.stimuli.Test_BaseStimuli;
import xpt.timing.Test_TickTimer;
import xpt.timing.Test_TimingBoss;
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
		
		//trial setup related
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
		
		//stimuli related
		runner.addCase(new Test_BaseStimuli());
		
		//timing related
		//runner.addCase(new Test_TickTimer());
		//runner.addCase(new Test_TimingBoss());
		
		//results related
		runner.addCase(new Test_Results());
		runner.addCase(new Test_TrialResults());
		
		//code
		runner.addCase(new Test_HScriptLayer());
		
		
		
		Report.create(runner, NeverShowSuccessResults, AlwaysShowHeader);
		
		runner.onComplete.add(function(h) { 
			//System.exit(0);
		} );
		runner.run();
		
	
	}
	
}