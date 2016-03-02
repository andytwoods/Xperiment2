package xpt;

/**
 * ...
 * @author 
 */
import code.Scripting;
import code.Test_Scripting;
import code.utils.Test_Text;
import openfl.events.Event;
import openfl.system.System;
import xpt.comms.services.Test_AbstractService;
import xpt.experiment.Experiment;
import xpt.experiment.Test_Translate;
import xpt.preloader.Test_Preloader_extract_loadable;
import xpt.results.Results;
import xpt.results.Test_Results;
import xpt.results.Test_TrialResults;
import xpt.screenManager.Test_DeviceManager;
import xpt.stimuli.builders.Test_Stimulus;
import xpt.stimuli.Test_ETCs;
import xpt.script.Test_BetweenSJs;
import xpt.script.templateHelpers.Test_templateList;
import xpt.script.Test_Templates;
import xpt.stimuli.Test_BaseStimuli;
import xpt.tools.Test_Base64;
import xpt.tools.Test_XML_Tools;
import utest.Runner;
import utest.ui.Report;
import utest.ui.common.HeaderDisplayMode;
import xpt.tools.Test_XTools;
import xpt.trial.Test_NextTrialBoss;
import xpt.trial.Trial;
import xpt.trialOrder.Test_DepthNode;
import xpt.trialOrder.Test_DepthNodeBoss;
import xpt.trialOrder.Test_SlotInForcePositions;
import xpt.trialOrder.Test_TrialBlock;
import xpt.trialOrder.Test_TrialOrder;
import xpt.trialOrder.Test_TrialOrderTools;

 
class Tests
{

	public function new(callBack:Void->Void) 
	{
		ExptWideSpecs.testingOn(["trial_sep" => ";", "stim_sep" => "---"]);
		Trial.testing = true;
		Scripting.testing = true;
		Results.testing = true;
		Experiment.testing = true;

		
		var runner = new Runner();
		
		//trial setup related
		runner.addCase(new Test_ETCs());
		runner.addCase(new Test_XML_Tools());
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
		runner.addCase(new Test_Scripting());
		runner.addCase(new Test_Preloader_extract_loadable());
		runner.addCase(new Test_Translate());
		
		//stimuli related
		runner.addCase(new Test_BaseStimuli());
		runner.addCase(new Test_Stimulus());
		runner.addCase(new Test_Text());
		
		//results related
		runner.addCase(new Test_Results());
		runner.addCase(new Test_TrialResults());
		runner.addCase(new Test_AbstractService());
		
		//other
		runner.addCase(new Test_XTools());
		runner.addCase(new Test_Base64());
		runner.addCase(new Test_DeviceManager());
		
		
		
		Report.create(runner, NeverShowSuccessResults, AlwaysShowHeader);
		
		runner.onComplete.add(function(h) { 
			//System.exit(0);
			ExptWideSpecs.testingOff();			
			Trial.testing = false;
			Scripting.testing = false;
			Results.testing = false;
			Experiment.testing = false;
			callBack();
		} );
		runner.run();
		
		
		
	
	}
	
}