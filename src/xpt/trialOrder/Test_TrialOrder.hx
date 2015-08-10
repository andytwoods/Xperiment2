package xpt.trialOrder;

import xpt.script.BetweenSJs;
import xpt.script.ProcessScript;
import thx.Arrays;
import thx.Tuple.Tuple2;
import utest.Assert;
import xpt.experiment.Experiment;
import xpt.script.Templates;
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

	public function new() {}
	

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
			Xml.parse("<CBCondition1><TRIAL block='0,1' order='fixed' trials='2'/><TRIAL block='0,1' order='reversed' trials='2'/></CBCondition1>"))._0;
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
		
	public function __test1()
	{
		
		var expt = function(myScript:Xml,labels:Array<String>,ident:Array<String>):Bool{	
			var expt:Experiment = init(myScript);
			var skeleton:TrialSkeleton;
			var trialOrder:Array<Int> = expt.__nextTrialBoss.__trialOrder;
			
			
			for (i in 0...trialOrder.length) {

				var skeleton_trialNum = expt.__nextTrialBoss.computeRunningTrial(i);
				var skeleton = skeleton_trialNum._0;
				
				expt.__runningTrial = TrialFactory.GET(skeleton, i);
				
				var testStim:Stimulus = expt.__runningTrial.stimuli[0];
				
				
				//testing names
				if (skeleton.names[expt.__runningTrial.iteration] != labels[i])	{
					trace("failed here:", skeleton.names[i] , labels[i]);
					return false;
				}
				
				
				//testing properties
				if (testStim.get('test') != ident[i]) {
					trace("failed here:", testStim.get('test') , ident[i]);
					return false;
				}
			}
			
			return true;
		}			
		
		var script:Xml = Xml.parse("<test><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'></testStim></TRIAL></test>");
		Assert.isTrue(	expt(script, ['v1', 'v2', 'v3', 'v4'], ['a', 'b', 'c', 'd'])		);
		
		script = 		Xml.parse("<test><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	expt(script,['v1','v2','v3','v4','w1','w2','w3','w4'],['a','b','c','d','e','f','g','h'])		);
		
		script = 		Xml.parse("<test><TRIAL block='0' trials='2' order='fixed' trialName='u'><testStim test='l;m'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	expt(script,['u1','u2','v1','v2','v3','v4','w1','w2','w3','w4'],['l','m','a','b','c','d','e','f','g','h'])		);
		
	}
	
	
	function t(myScript:Xml,labels:Array<String>,props:Array<String>):Bool{	
		var expt:Experiment = init(myScript);
		
		var testProps:Array<String>=[];
		var testTrialNames:Array<String> = [];
		var skeleton_trialOrder:Tuple2<TrialSkeleton,Int>;
		var __nextTrialBoss = expt.__nextTrialBoss;
		
		for (i in 0...__nextTrialBoss.__trialOrder.length) {
			
			if (i == 0) skeleton_trialOrder = __nextTrialBoss.getTrial(GotoTrial.First, null);
			else skeleton_trialOrder = __nextTrialBoss.getTrial(GotoTrial.Next, null);
			//trace(111, __nextTrialBoss.currentTrial,skeleton_trialOrder._1);
	
			expt.__runningTrial = TrialFactory.GET(skeleton_trialOrder._0, skeleton_trialOrder._1);
			
			testProps.push(expt.__runningTrial.stimuli[0].get('test'));
			testTrialNames.push(expt.__runningTrial.trialName);
		}
		
		/*trace("testTrialNames	", testTrialNames);
		trace("labels		", labels);
		
		trace("testProps		", testProps);
		trace("props		", props);*/

		
		if (Arrays.equals(props, testProps)	== false) return false;
		if (Arrays.equals(labels, testTrialNames) == false) return false;
		
		return true;
	}			
	
	public function test2(){
		
		
		var script:Xml = Xml.parse("<test><TRIAL block='0' trials='2' order='fixed' trialName='u'><testStim test='l;m'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	t(script,['u1','u2','v1','v2','v3','v4','w1','w2','w3','w4'],['l','m','a','b','c','d','e','f','g','h'])		);
		
		script = Xml.parse("<test><TRIAL block='0' trials='2' order='reversed' trialName='u'><testStim test='l;m'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	t(script,['u2','u1','v1','v2','v3','v4','w1','w2','w3','w4'],['m','l','a','b','c','d','e','f','g','h'])		);
		
		script = Xml.parse("<test><TRIAL block='0' trials='2' order='reversed' trialName='u'><testStim test='l;m'/></TRIAL><TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a;b;c;d'/></TRIAL><TRIAL block='40' trials='4' order='reversed' trialName='w'><testStim test='e;f;g;h'/></TRIAL></test>");
		Assert.isTrue(	t(script,['u2','u1','v1','v2','v3','v4','w4','w3','w2','w1'],['m','l','a','b','c','d','h','g','f','e'])		);
	}
	
	
	
	//return to this later
	public function test3() {
		
/*	<Taste exptType="WEB">
   <SETUP>
      <trials blockDepthOrder="20,*=random 20,*,*=random" />
   </SETUP>
   <TRIAL TYPE="Trial" hideResults="true" block="0" order="fixed" trials="1">
      <testStim test="e;f;g;h" />
   </TRIAL>
   <TRIAL TYPE="Trial" block="3" order="fixed" trials="1">
      <testStim test="e;f;g;h" />
   </TRIAL>
   <TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="0" />
   <TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="11" />
   <TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="22" />
   <TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="33" />
   <TRIAL block="20,4,1" template="templateLineScale" trialName="A_sour;B_sour;C_sour;D_sour;E_sour;F_sour;G_sour;H_sour">
      <testStim copyOverID="taste" text1="991" />
   </TRIAL>
   <TRIAL block="20,4,2" template="templatePackage" trialName="Csour">
      <testStim copyOverID="taste" text1="991" />
   </TRIAL>
   <TRIAL block="20,4,3" template="templateJam" trialName="Jsour">
      <testStim copyOverID="taste" text1="991" />
   </TRIAL>
   <TRIAL block="20,4,4" template="templateLiking" trialName="Liking_sour">
      <testStim copyOverID="taste" text1="991" />
   </TRIAL>
   <TRIAL block="20,5,1" template="templateLineScale" trialName="A_sweet;B_sweet;C_sweet;D_sweet;E_sweet;F_sweet;G_sweet;H_sweet">
      <testStim copyOverID="taste" text1="523" />
   </TRIAL>
   <TRIAL block="20,5,2" template="templatePackage" trialName="Csweet">
      <testStim copyOverID="taste" text1="523" />
   </TRIAL>
   <TRIAL block="20,5,3" template="templateJam" trialName="Jsweet">
      <testStim copyOverID="taste" text1="523" />
   </TRIAL>
   <TRIAL block="20,5,4" template="templateLiking" trialName="Liking_sweet">
      <testStim copyOverID="taste" text1="523" />
   </TRIAL>
   <templatePause order="fixed" trials="1" />
   <templateLiking order="random" trials="1">
      <testStim copyOverID="taste" test="l1" />
   </templateLiking>
   <templateLineScale order="random" trials="8">
      <testStim copyOverID="taste" test="a;b;c;d;e;f;g;h" />
   </templateLineScale>
   <templatePackage order="random" trials="1">
      <testStim copyOverID="taste" test="p1" />
   </templatePackage>
   <templateJam order="random" trials="1">
      <testStim copyOverID="taste" test="j1" />
   </templateJam>
   <TRIAL TYPE="Trial" hideResults="true" block="100" order="fixed" trials="1" test="l1">
      <testStim test="e;f;g;h" />
   </TRIAL>
</Taste>
*/

		
		var tt = function():Bool{
			var script:Xml = Xml.parse("<Taste exptType='WEB'><SETUP><trials blockDepthOrder='20,*=random 20,*,*=random' /></SETUP><TRIAL TYPE='Trial'  hideResults='true' block='0' order='fixed' trials='1'><testStim test='e;f;g;h'/></TRIAL><TRIAL TYPE='Trial' block='3' order='fixed' trials='1'><testStim test='e;f;g;h'/></TRIAL><TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='0'/><TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='11'/><TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='22'/><TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='33'/><TRIAL block='20,4,1' template='templateLineScale' trialName='A_sour;B_sour;C_sour;D_sour;E_sour;F_sour;G_sour;H_sour'><testStim copyOverID='taste' text1='991'/></TRIAL><TRIAL block='20,4,2' template='templatePackage' trialName='Csour'><testStim copyOverID='taste' text1='991'/></TRIAL><TRIAL block='20,4,3' template='templateJam' trialName='Jsour'><testStim copyOverID='taste' text1='991' /></TRIAL><TRIAL block='20,4,4' template='templateLiking' trialName='Liking_sour'><testStim copyOverID='taste' text1='991' /></TRIAL><TRIAL block='20,5,1' template='templateLineScale' trialName='A_sweet;B_sweet;C_sweet;D_sweet;E_sweet;F_sweet;G_sweet;H_sweet'><testStim copyOverID='taste' text1='523'/></TRIAL><TRIAL block='20,5,2' template='templatePackage' trialName='Csweet'><testStim copyOverID='taste' text1='523'/></TRIAL><TRIAL block='20,5,3' template='templateJam' trialName='Jsweet'><testStim copyOverID='taste' text1='523' /></TRIAL><TRIAL block='20,5,4' template='templateLiking' trialName='Liking_sweet'><testStim copyOverID='taste' text1='523' /></TRIAL><templatePause  order='fixed' trials='1'></templatePause><templateLiking order='random' trials='1'><testStim copyOverID='taste' test='l1' /> </templateLiking><templateLineScale order='random' trials='8'><testStim copyOverID='taste' test='a;b;c;d;e;f;g;h' /> </templateLineScale>  <templatePackage order='random' trials='1'><testStim copyOverID='taste' test='p1' /> </templatePackage>  <templateJam order='random' trials='1'>	<testStim copyOverID='taste' test='j1' /> </templateJam>  	<TRIAL TYPE='Trial' hideResults='true' block='100' order='fixed' trials='1' test='l1'><testStim test='e;f;g;h'/></TRIAL></Taste>");
			
			//script = BetweenSJs.compose(script);
trace(script);
			Templates.compose(script);
			trace(script);
			
			var expt:Experiment = new Experiment(null);
			BaseStimuli.setPermitted(['teststim']);
			ExptWideSpecs.__init();
			ExptWideSpecs.__testSet("blockDepthOrder","20,*=random 20,*,*=random");
			var trialOrder_skeletons:Tuple2<	Array<Int>,	Array<TrialSkeleton>> = TrialOrder.COMPOSE(script);
			expt.__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);
			
			
			var testProps:Array<String>=[];
			var testTrialNames:Array<String> = [];
			var skeleton_trialOrder:Tuple2<TrialSkeleton,Int>;
			BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
			
			var __nextTrialBoss = expt.__nextTrialBoss;

			//trace(__nextTrialBoss.__trialOrder, __nextTrialBoss.__trialOrder.length, 22,"------------------");
			
			for (i in 0...__nextTrialBoss.__trialOrder.length) {
				trace(i);
				if (i == 0) skeleton_trialOrder = __nextTrialBoss.getTrial(GotoTrial.First, null);
				else skeleton_trialOrder = __nextTrialBoss.getTrial(GotoTrial.Next, null);
				if (skeleton_trialOrder._0 == null) return false;
				//trace(111, i,skeleton_trialOrder,__nextTrialBoss.currentTrial,skeleton_trialOrder._1);
		
				expt.__runningTrial = TrialFactory.GET(skeleton_trialOrder._0, skeleton_trialOrder._1);

				testProps.push(expt.__runningTrial.stimuli[0].get('test'));
				testTrialNames.push(expt.__runningTrial.trialName);
			}
				
		trace("testTrialNames	", testTrialNames);
		trace("testProps		", testProps);
			
			
			return true;		
		}
trace("-----");
		Assert.isTrue(tt());
		trace("----------");

	}


}