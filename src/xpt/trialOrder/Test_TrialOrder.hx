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
		
			ExptWideSpecs.set(null);
			
			
			
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
		ExptWideSpecs.set(myScript);
		var trialOrder_skeletons = TrialOrder.COMPOSE(myScript);
		
		
		BaseStimuli.setPermittedStimuli(['teststim']);
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
			
			
			for (i in 0...trialOrder.length) {

				var skeleton_trialNum = expt.__nextTrialBoss.computeRunningTrial(i);
				var skeleton = skeleton_trialNum.skeleton;
				
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
		var skeleton_trialOrder:NextTrialInfo;
		var __nextTrialBoss = expt.__nextTrialBoss;
		
		for (i in 0...__nextTrialBoss.__trialOrder.length) {
			
			if (i == 0) skeleton_trialOrder = __nextTrialBoss.getTrial(GotoTrial.First, null);
			else skeleton_trialOrder = __nextTrialBoss.getTrial(GotoTrial.Next, null);
			//trace(111, __nextTrialBoss.currentTrial,skeleton_trialOrder._1);
	
			expt.__runningTrial = TrialFactory.GET(skeleton_trialOrder.skeleton, skeleton_trialOrder.trialOrder);
			
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
	
	
	
	public function test3() {

		var script:Xml = Xml.parse("<Taste exptType='WEB'><TRIAL TYPE='Trial'  hideResults='true' block='0' order='fixed' trials='1'><testStim test='1'/></TRIAL><TRIAL TYPE='Trial' block='3' order='fixed' trials='1'><testStim test='2'/></TRIAL><TRIAL  TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='1'/><TRIAL  TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='3'/><TRIAL  TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='5'/><TRIAL  TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='7'/><TRIAL block='20,4,1' template='templateLineScale' trialName='A_sour;B_sour;C_sour;D_sour;E_sour;F_sour;G_sour;H_sour'><testStim copyOverID='taste' text1='A_sour;B_sour;C_sour;D_sour;E_sour;F_sour;G_sour;H_sour'/></TRIAL><TRIAL block='20,4,2' template='templateLineScale' trialName='Csour'><testStim copyOverID='taste' text1='991;992---1;993'/></TRIAL><templateLineScale order='fixed' trials='4'><testStim copyOverID='taste' test='a' /></templateLineScale><TRIAL TYPE='Trial' hideResults='true' block='100' order='fixed' trials='1' test='l1'><testStim test='3'/></TRIAL></Taste>");
			

			//script = BetweenSJs.compose(script);
			//trace(script);
			Templates.compose(script);

			
			var expt:Experiment = new Experiment(null);
			BaseStimuli.setPermittedStimuli(['teststim']);
			ExptWideSpecs.set(null);
			//ExptWideSpecs.__testSet("blockDepthOrder","20,*=fixed 20,*,*=fixed");
			
			var trialOrder_skeletons:Tuple2 <	Array<Int>,	Array<TrialSkeleton> > = TrialOrder.COMPOSE(script);

			expt.__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);
			//trace(111, trialOrder_skeletons);
			
			var testProps:Array<String>=[];
			var testTrialNames:Array<String> = [];
			var skeleton_trialOrder:NextTrialInfo;
			BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
			
			/*
			for (skel in trialOrder_skeletons._1) {
				trace(skel.xml);
			}*/
			
			//trace(expt.__nextTrialBoss.__trialOrder, expt.__nextTrialBoss.__trialOrder.length, 22, "------------------");
			
			
			
		
			for (i in 0...expt.__nextTrialBoss.__trialOrder.length) {
				
				if (i == 0) skeleton_trialOrder = expt.__nextTrialBoss.getTrial(GotoTrial.First, null);
				else skeleton_trialOrder = expt.__nextTrialBoss.getTrial(GotoTrial.Next, null);
				
				if (skeleton_trialOrder.skeleton == null) Assert.isTrue(false);
				//trace(111, i,skeleton_trialOrder,skeleton_trialOrder._1);
				//var skel = skeleton_trialOrder._0;
				//trace(skel.xml);
				expt.__runningTrial = TrialFactory.GET(skeleton_trialOrder.skeleton, skeleton_trialOrder.trialOrder);

				if (expt.__runningTrial.stimuli.length > 0) {
					var stim:Stimulus = expt.__runningTrial.stimuli[0];
					var val:String;
					if (stim.__properties.exists('test')) {
						val = stim.get('test');
					}
					else val = stim.get("text1");
					
					testProps.push(val);
				}
				else testProps.push("pause");
				testTrialNames.push(expt.__runningTrial.trialName);
			}
				
		Assert.isTrue(testTrialNames.toString() ==",,,A_sour,B_sour,,C_sour,D_sour,,Csour1,Csour2,,Csour3,Csour4,");
		Assert.isTrue(testProps.toString() =="1,2,pause,A_sour,B_sour,pause,C_sour,D_sour,pause,991,992,pause,993,991,3");
	}
	
	
	

	public function test4() {

		var script:Xml = Xml.parse("<Taste exptType='WEB'><SETUP></SETUP>" +
		"<TRIAL TYPE='Trial'  hideResults='true' block='0' order='fixed' trials='1'><testStim test='1'/></TRIAL><TRIAL TYPE='Trial' block='3' order='fixed' trials='1'><testStim test='2---3'/></TRIAL>" +
		"<TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='1'/>" +
		"<TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='centre'/>" +
		"<TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='center+1'/>" +
		"<TRIAL template='templatePause' TYPE='Trial' block='20,2' order='fixed' forceBlockDepthPositions='last'/>" +
		"<TRIAL block='20,4,1' template='templateLineScale' trialName='A;B;C;D;E;F;G;H;I'><testStim copyOverID='taste' text1='A;B;C;D;E;F;G;H;I'/></TRIAL>" +
		"<TRIAL block='20,4,2' template='templatePackage' trialName='Csour'><testStim copyOverID='taste' text1='991'/></TRIAL>" +
		"<TRIAL block='20,4,3' template='templateJam' trialName='Jsour'><testStim copyOverID='taste' text1='991' /></TRIAL>" +
		"<TRIAL block='20,4,4' template='templateLiking' trialName='Liking_sour'><testStim copyOverID='taste' text1='991' /></TRIAL>" +
		"<TRIAL block='20,5,1' template='templateLineScale' trialName='m;n;o;p;q;r;s;t'><testStim copyOverID='taste' text1='m;n;o;p;q;r;s;t'/></TRIAL>" +
		"<TRIAL block='20,5,2' template='templatePackage' trialName='Csweet'><testStim copyOverID='taste' text1='523'/></TRIAL><TRIAL block='20,5,3' template='templateJam' trialName='Jsweet'><testStim copyOverID='taste' text1='524' /></TRIAL>" +
		"<TRIAL block='20,5,4' template='templateLiking' trialName='Liking_sweet'><testStim copyOverID='taste' text1='525' /></TRIAL>" +
		"<templatePause  order='fixed' trials='1'></templatePause>" +
		"<templateLiking order='fixed' trials='1'><testStim copyOverID='taste' test='l1' /> </templateLiking>" +
		"<templateLineScale order='fixed' trials='8'><testStim copyOverID='taste' test='a;b;c;d;e;f;g;h' /> </templateLineScale>" +
		" <templatePackage order='random' trials='1'><testStim copyOverID='taste' test='p1' /> </templatePackage>" +
		"<templateJam order='fixed' trials='1'>	<testStim copyOverID='taste' test='jam' /> </templateJam>  	" +
		"<TRIAL TYPE='Trial' hideResults='true' block='100' order='fixed' trials='1' test='l1'><testStim test='3'/></TRIAL></Taste>");
			
			//script = BetweenSJs.compose(script);
			//trace(script);
			Templates.compose(script);

			
			var expt:Experiment = new Experiment(null);
			BaseStimuli.setPermittedStimuli(['teststim']);
			ExptWideSpecs.set(null);
			ExptWideSpecs.__testSet("blockDepthOrder","");
			var trialOrder_skeletons:Tuple2<	Array<Int>,	Array<TrialSkeleton>> = TrialOrder.COMPOSE(script);
			expt.__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);
			//trace(111, trialOrder_skeletons);
			
			var testProps:Array<String>=[];
			var testTrialNames:Array<String> = [];
			var skeleton_trialOrder:NextTrialInfo;
			BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
			
			/*
			for (skel in trialOrder_skeletons._1) {
				trace(skel.xml);
			}*/
			
			//trace(expt.__nextTrialBoss.__trialOrder, expt.__nextTrialBoss.__trialOrder.length, 22, "------------------");
			
			
			
		
			for (i in 0...expt.__nextTrialBoss.__trialOrder.length) {
				
				if (i == 0) skeleton_trialOrder = expt.__nextTrialBoss.getTrial(GotoTrial.First, null);
				else skeleton_trialOrder = expt.__nextTrialBoss.getTrial(GotoTrial.Next, null);
				
				if (skeleton_trialOrder.skeleton == null) Assert.isTrue(false);
				//trace(111, i,skeleton_trialOrder,skeleton_trialOrder._1);
				//var skel = skeleton_trialOrder._0;
				//trace(skel.xml);
				expt.__runningTrial = TrialFactory.GET(skeleton_trialOrder.skeleton, skeleton_trialOrder.trialOrder);

				if (expt.__runningTrial.stimuli.length > 0) {
					var stim:Stimulus = expt.__runningTrial.stimuli[0];
					var val:String;
					if (stim.__properties.exists('test')) {
						val = stim.get('test');
					}
					else if (stim.__properties.exists('text1')) val = stim.__properties.get('text1');
					else throw "";
					
					testProps.push(val);
				}
				else testProps.push("pause");
				testTrialNames.push(expt.__runningTrial.trialName);
			}
				
	
			Assert.isTrue(testTrialNames.toString() == ",,,A,B,C,D,E,F,G,H,Csour,Jsour,Liking_sour,,m,,n,o,p,q,r,s,t,Csweet,Jsweet,Liking_sweet,,");
			
			Assert.isTrue(testProps.toString() == "1,2,pause,A,B,C,D,E,F,G,H,991,991,991,pause,m,pause,n,o,p,q,r,s,t,523,524,525,pause,3");
			
			Assert.isTrue(testProps.length == 29);
			
			var nam:String;
			var prop:String;

			var checkArr:Array<String> = "1,2,3,pause".split(",");
			for (i in 0...testTrialNames.length) {
				nam = testTrialNames[i];
				if (nam == "") {
					prop = testProps[i];
					
					Assert.isTrue(checkArr.indexOf(prop) != -1);
					
				}
				
			}
	}
}