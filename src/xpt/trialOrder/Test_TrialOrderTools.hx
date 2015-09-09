package xpt.trialOrder;

import utest.Assert;
import xmlTools.E4X;
import xpt.ExptWideSpecs;
import xpt.tools.XTools;


class Test_TrialOrderTools
{

	public function new() {}
	

	public function test_6():Void {

	
		var make = function(blocks1:Array<Int>,blocks2:Array<Int>):Int{
			var t1:TrialBlock = new TrialBlock();
			var t2:TrialBlock = new TrialBlock();
			
			for(i in 0...blocks1.length){
				t1.blocksVect.push(blocks1[i]);
			}
			for(i in 0...blocks2.length){
				t2.blocksVect.push(blocks2[i]);
			}
			
			return TrialOrderTools.__sortF(t1,t2);
		}

		Assert.isTrue(make([0],[1])==-1);
		Assert.isTrue(make([1],[0])==1);
		Assert.isTrue(make([0],[0])==0);
		
		Assert.isTrue(make([0,1],[0])==1);
		Assert.isTrue(make([0,1],[0,2])==-1);
		Assert.isTrue(make([0,2],[0,2])==0);
		Assert.isTrue(make([0,3],[0,2])==1);
		
		Assert.isTrue(make([0],[0,2])==-1);

		Assert.isTrue(make([20], [0]) == 1);
		
	}
	


		public function test_combineIdentical():Void {
			
			
			var getTrialBlock = function(ident:String, alive:Bool, trials:Array<Int>):TrialBlock {
				var t:TrialBlock = new TrialBlock();
				t.blocksIdent = ident;
				t.alive = alive;
				t.trials = trials;
				return t;
			}
			
			var trialBlocks:Array<TrialBlock> = [];
			trialBlocks[trialBlocks.length] = getTrialBlock("a", true, [1, 2, 3]);
			trialBlocks[trialBlocks.length] = getTrialBlock("a", true, [4, 5, 6]);
			
			TrialOrderTools.__combineIdentical(trialBlocks);
			Assert.isTrue(trialBlocks[0].alive == true);
			Assert.isTrue(trialBlocks[1].alive == false);
			Assert.isTrue(XTools.arrsIdent(trialBlocks[0].trials , [1, 2, 3, 4, 5, 6]));
			
			trialBlocks = [];
			trialBlocks[trialBlocks.length] = getTrialBlock("a", true, [1, 2, 3]);
			trialBlocks[trialBlocks.length] = getTrialBlock("b", true, [4, 5, 6]);
			
			TrialOrderTools.__combineIdentical(trialBlocks);
			Assert.isTrue(trialBlocks[0].alive == true);
			Assert.isTrue(trialBlocks[1].alive == true);
			Assert.isTrue(XTools.arrsIdent(trialBlocks[0].trials , [1, 2, 3]));
			Assert.isTrue(XTools.arrsIdent(trialBlocks[1].trials , [4, 5, 6]));
	
		}
		
		
		public function test8_7() 
		{
			function makeTrialBlocks(params:MyTest):Bool{
				
	
				var blocks:Array<String> = params.blocks;
				var numTrials:Array<Int> = params.numTrials;
				
				var trialBlocks:Array<TrialBlock> = [];
				var block:TrialBlock;
				
				var count:Int=0;
				var trials:Array<Int>;
				var i:Int;
				var j:Int;
				
				for (i in 0...blocks.length){
					
					block = new TrialBlock();
									
					trials=[];
					for(j in 0...numTrials[i]){
						trials.push(count);
						count++;
					}
					block.trials=trials;
					block.order=OrderType.FIXED;
					block.setBlock(blocks[i]);
					trialBlocks.push(block);
				}
				
				
				BlockDepthOrdering.DO(trialBlocks);

				var trialList:Array<Int> = [];
				var expectedTrialList:Array<Int>=params.trials;
				var tArr:Array<Int>; 
				
				for(i in 0...trialBlocks.length){	
					
					if(trialBlocks[i].alive){
						tArr=trialBlocks[i].trials;
						
						for(j in 0...tArr.length){
							trialList.push(tArr[j]);
						}
					}
				}
			
				for (i in 0...expectedTrialList.length) {
					if(expectedTrialList[i]!=trialList[i])return false;
				}
				
				
				return true; 
			}
			var xml:Xml = Xml.parse("<x><SETUP><A blockDepthOrder='1,2=fixed 1,2,3=fixed 1,2,4=fixed'/></SETUP></x>");
			ExptWideSpecs.set(xml);
			
			
			Assert.isTrue(makeTrialBlocks(new MyTest(
				null,
				['1,2','1,2,3','1,2,4'],
				[2,2,2],
				[0,1,2,3,4,5]
			)));
			
			ExptWideSpecs.__testSet("blockDepthOrder", "1,2=fixed 1,2,*=reversed");
			

			
			Assert.isTrue(makeTrialBlocks(new MyTest(
				['fixed','fixed','reverse'],
				['1,2','1,2,3','1,2,4'],
				[2,2,2],
				[0,1,4,5,2,3]
			)));

			
			ExptWideSpecs.__testSet("blockDepthOrder","1,2=fixed 1,2,*=reversed");
			Assert.isTrue(makeTrialBlocks(new MyTest(
				['fixed','fixed','reverse'],
				['1,2','1,2,3','1,2,4'],
				[2,2,2],
				[0,1,4,5,2,3])
			));
			
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
		
		
	public function test12() 
		{
			ExptWideSpecs.set(null);		
	
			
			var result:Array<Int>;

			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='20' order='fixed' forcePositionInBlock = '1' trials='2'/><TRIAL block='0' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[2,0,1]));

			result = TrialOrder.COMPOSE(
			Xml.parse("<CBCondition1><TRIAL block='20,2' order='fixed' forceBlockDepthPositions = '1' trials='2'/><TRIAL block='20,1' order='fixed' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[0,1,2]));
			

			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='20,6' order='fixed' forceBlockDepthPositions = '1/3' trials='1'/><TRIAL block='20,6' order='fixed' forceBlockDepthPositions = '2/3' trials='1'/><TRIAL block='20,3' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' trials='5'/><TRIAL block='20,1' order='fixed' trials='5'/></CBCondition1>"))._0;
		
			Assert.isTrue(myTest(result,[12,13,14,15,16,0,7,8,9,10,11,1,2,3,4,5,6]));
			
				
			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='20,1' order='fixed' forceBlockDepthPositions = '1/3' trials='1'/><TRIAL block='20,1' order='fixed' forceBlockDepthPositions = '2/3' trials='1'/><TRIAL block='20,3' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' trials='5'/><TRIAL block='20,1' order='fixed' trials='5'/></CBCondition1>"))._0;
		
			Assert.isTrue(myTest(result,[12,13,14,15,16,0,7,8,9,10,11,1,2,3,4,5,6]));
			
			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='20,3' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' forceBlockDepthPositions = '1/3' trials='1'/><TRIAL block='20,2' order='fixed' forceBlockDepthPositions = '2/3' trials='1'/><TRIAL block='20,1' order='fixed' trials='5'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[12,13,14,15,16,10,5,6,7,8,9,11,0,1,2,3,4]));
			
			result = TrialOrder.COMPOSE(
				Xml.parse("<CBCondition1><TRIAL block='-20,6' order='fixed' forceBlockDepthPositions = '1/3' trials='1'/><TRIAL block='-20,6' order='fixed' forceBlockDepthPositions = '2/3' trials='1'/><TRIAL block='-20,3' order='random' trials='5'/><TRIAL block='-20,2' order='random' trials='5'/><TRIAL block='-20,1' order='random' trials='5'/></CBCondition1>"))._0;
			
			Assert.isTrue(result[5] == 0 && result[11] == 1);
	}
				
		

		
		public function test13() 
		{
			ExptWideSpecs.set(null);
			
			
			
			var result:Array<Int>;
			
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='20,2' order='fixed' trials='6'/><TRIAL block='20,2' order='fixed' forcePositionInBlock = '1/3' trials='1'/><TRIAL block='20,2' order='fixed' forcePositionInBlock = '2/3' trials='1'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[0,1,6,2,3,7,4,5]));
			
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='20,3' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' trials='5'/>   <TRIAL block='20,2' order='fixed' forcePositionInBlock = '1/3' trials='1'/>   <TRIAL block='20,2' order='fixed' forcePositionInBlock = '2/3' trials='1'/><TRIAL block='20,1' order='fixed' trials='5'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result, [12, 13, 14, 15, 16, 5, 6, 10, 7, 11, 8, 9, 0, 1, 2, 3, 4]));
										   
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='20,3' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' trials='5'/><TRIAL block='20,2' order='fixed' forcePositionInBlock = '1/3' trials='1'/><TRIAL block='20,2' order='fixed' forcePositionInBlock = 'last' trials='1'/><TRIAL block='20,1' order='fixed' trials='5'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[12,13,14,15,16,5,6,10,7,8,9,11,0,1,2,3,4]));
							
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='20' order='fixed' forcePositionInBlock = '1/4' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '1/2' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '3/4' trials='1'/><TRIAL block='20' order='fixed' trials='8'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[3,4,0,5,6,1,7,8,2,9,10]));
			
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='1' order='fixed' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '1/4' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '1/2' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '3/4' trials='1'/><TRIAL block='20' order='fixed' trials='8'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[0,4,5,1,6,7,2,8,9,3,10,11]));
			
			result = TrialOrder.COMPOSE(Xml.parse("<CBCondition1><TRIAL block='1' order='fixed' trials='5'/><TRIAL block='20' order='fixed' forcePositionInBlock = '1/4' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '1/2' trials='1'/><TRIAL block='20' order='fixed' forcePositionInBlock = '3/4' trials='1'/><TRIAL block='20' order='fixed' trials='8'/><TRIAL block='22' order='fixed' trials='5'/></CBCondition1>"))._0;
			Assert.isTrue(myTest(result,[0,1,2,3,4,8,9,5,10,11,6,12,13,7,14,15,16,17,18,19,20]));
			
		}
	
}







class MyTest {
	public var depthOrdering:Array<String>;
	public var blocks:Array<String>;
	public var numTrials:Array<Int>;
	public var trials:Array<Int>;
	
	public function new(depthOrdering:Array<String>, blocks:Array<String>, numTrials:Array<Int>, trials:Array<Int>) {
		this.depthOrdering = depthOrdering;
		this.blocks = blocks;
		this.numTrials = numTrials;
		this.trials = trials;
	}
	
}