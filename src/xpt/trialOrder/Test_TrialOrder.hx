package xpt.trialOrder;

import utest.Assert;
import xpt.experiment.Experiment;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.Stimulus;
import xpt.trial.GotoTrial;
import xpt.trial.NextTrialBoss;
import xpt.trial.TrialFactory;
import xpt.trial.TrialSkeleton;
/**
 * ...
 * @author 
 */
class Test_TrialOrder
{

	public function new() 
	{
		
	}
	
	

		private function myTest(result:Array<Int>, answer:Array<Int>):Bool{
		
		if (result.length != answer.length) {
			return false;
		}
		
		for(i in 0...result.length){
			if (result[i] != answer[i]) {
				return false;
			}
		}
		return true;
	}
		

	
	public function test7()
		{
		
			ExptWideSpecs.__init();
			
			
			
			var result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='0,1' order='fixed' trials='2'/> <TRIAL block='8' order='fixed' trials='3'/> </CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [0, 1, 2, 3, 4]));
						
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='0,1,2' order='fixed' trials='1'/><TRIAL block='0,5,2' order='fixed' trials='1'/><TRIAL block='0' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [2, 0, 1]));
				
				
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='0' order='fixed' trials='1'/><TRIAL block='0' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [0, 1]));
						
				result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='0,1' order='fixed' trials='2'/><TRIAL block='0,5' order='fixed' trials='3'/><TRIAL block='0,2' order='fixed' trials='3'/>                    <TRIAL block='0,1' order='fixed' trials='2' /></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [0, 1, 8, 9, 5, 6, 7, 2, 3, 4]));
							
			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='0,1' order='fixed' trials='2'/><TRIAL block='0,1' order='reverse' trials='2'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[3,2,1,0]));
			
		
			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='1' order='fixed' trials='1'/><TRIAL block='0,1' order='fixed' trials='1'/></CBCondition1>"))._0;
		Assert.isTrue(myTest(result, [1, 0]));
			
			
			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='0,1,2' order='reverse' trials='1'/><TRIAL block='0' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [1, 0]));
			
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL  block='0' order='fixed' trials='1'/><TRIAL  block='0' order='fixed' trials='1'/> <TRIAL  block='0' order='fixed' trials='1'/><TRIAL block='10'/></CBCondition1>"))._0;		
			Assert.isTrue(myTest(result, [0, 1, 2, 3]));

			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='0,1,2' order='reverse' trials='2'/><TRIAL block='0,5,2' order='fixed' trials='3'/><TRIAL block='0,2,3' order='fixed' trials='3'/> <TRIAL block='0,2,3' order='reverse' trials='2' /><TRIAL block='0' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [10, 1, 0, 9, 8, 7, 6, 5, 2, 3, 4]));

			result = TrialOrder.COMPOSE( Xml.parse("<CBCondition1><TRIAL block='20' order='fixed' trials='1'></TRIAL><dummy></dummy><TRIAL block='0' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [1, 0]));			
			
			result = TrialOrder.COMPOSE(	Xml.parse("<CBCondition1><TRIAL block='20' order='fixed' trials='1'  trialName='v'><d></d></TRIAL></CBCondition1>"))._0;

		}
		

	private function init(myScript:Xml):Experiment {
		var expt:Experiment = new Experiment(null);
		expt.__script=myScript;
		ExptWideSpecs.__init();
		var trialOrder_skeletons = TrialOrder.COMPOSE(myScript);
		
		
		BaseStimuli.setPermitted(['teststim']);
		BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		expt.__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);
		expt.__startTrial();
		return expt;
	} 
		
	public function test1()
	{
		
		var expt = function(myScript:Xml,labels:Array<String>,ident:Array<String>):Bool{	
			var expt:Experiment = init(myScript);
			var skeleton:TrialSkeleton;
			var trialOrder:Array<Int> = expt.__nextTrialBoss.__trialOrder;
			
			
			for(i in 0...trialOrder.length){
				var skeleton_trialNum = expt.__nextTrialBoss.computeRunningTrial(i);
				var skeleton = skeleton_trialNum._0;

				//testing names
				if (skeleton.names[i] != labels[i])	{
					trace("failed here:", skeleton.names[i] , labels[i]);
					return false;
				}
				
				expt.runningTrial = TrialFactory.GET(skeleton, i);
				
				var testStim:Stimulus = expt.runningTrial.stimuli[0];
				
				//testing properties
				if (testStim.get('test') != ident[i]) {
					trace("failed here:", testStim.get('test') , ident[i]);
					return false;
				}
			}
			
			return true;
		}			
		
		var script:Xml = Xml.parse("<test><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'></testStim></TRIAL></test>");
		Assert.isTrue(	expt(script,['v1','v2','v3','v4'],['a','b','c','d'])		);
		
		trace("-----");
		script = 		Xml.parse("<test><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	expt(script,['v1','v2','v3','v4','w1','w2','w3','w4'],['a','b','c','d','e','f','g','h'])		);
		trace("-----");
		/*
		script = 		Xml.parse("<test><TRIAL block='0' trials='2' order='fixed' trialName='u'><testStim test='l;m'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	expt(script,['u1','u2','v1','v2','v3','v4','w1','w2','w3','w4'],['l','m','a','b','c','d','e','f','g','h'])		);
		*/
	}
	
	/// MORE TO ADD

}