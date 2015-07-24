package xpt.trialOrder_old.components.blockOrder;

import script.XML_tools;
import xpt.tools.XTools;
import xpt.trialOrder_old.components.blockOrder.SlotInForcePositions.ForcePosition;

class TrialBlock
{
	
	public function new() 
	{
		
	}
	
	public var numTrials:Int;
	public var trials:Array<Int>=[];

	public var blocksIdent:String="";
	public var blocksVect:Array<Int>=[];
	public var order:String;
	public var blockDepthOrder:String;
	public var blockDepthOrderings:Array<Int>;
	public var alive:Bool=true;
	
	public var forcePositionInBlock:String='';
	public var forcePositionInBlockDepth:String='';
	
	//used for trial creation
	public var blockPosition:Int;
	public var names:Array<String>=[];
	
	public var preterminedSortOnOrder:Int;//used for SortOn, in another class
	

	static public var RANDOM:String='RANDOM';
	static public var FIXED:String='FIXED';
	static public var REVERSE:String='REVERSE';
	static public var PREDETERMINED:String='PREDETERMINED';
	public static var DEFAULT_DEPTH_ORDER:String=FIXED;
	
	public var forceBlockPositions:Array<ForcePosition>;
	public var forceBlockDepthPositions:Array<ForcePosition>;
	
	
	public var currentDepthID:Int;
	
	public function kill():Void{
		trials=null;
		blocksIdent=null;
		this.alive=false;
	}
	
	public function giveParents():String{
		currentDepthID=Std.int(blocksVect[blocksVect.length-1]);
		return blocksVect.join(" ");
	}
	
	public function giveOnlyParents():String{
		
		var onlyParents:Array<String>=[];
		
		for(i in blocksVect){
			onlyParents[onlyParents.length] = Std.string(blocksVect[i]);
		}
		return onlyParents.join(" ");
	}
	
	public function trimBlocksVect():Void{
		blocksVect.pop();
		blocksIdent=blocksVect.join(",");
	}
	
	
	public function getTrials():Array<Int>{
		return trials;	
	}
	

	public function do_forcePositionInBlockDepth():Void{
		if(forceBlockDepthPositions != null){
			SlotInForcePositions.DO(trials,forceBlockDepthPositions);
			forceBlockDepthPositions=null;
		}
	}
	
	
	public function doOrdering():Void{

		if(order=='' || order=='RANDOM')trials=XTools.arrayShuffle(trials);
		else if(order=="FIXED"){
			//do nothing}
		}
		else if(order=="REVERSED" || order=="REVERSE")	trials.reverse();
		else throw ("You have specifed trial order wrongly:"+order+"(should be either fixed, random, reversed or left blank).");

		
		if(forceBlockPositions !=null){
			SlotInForcePositions.DO(trials,forceBlockPositions);
		}
	}
	
	public function setup(trial:Xml,counter:Int,blockPosition:Int,composeTrial):Void{
		this.blockPosition=blockPosition;

		//have to get myTrials as SetForced manipulates the trialsArray
		var numTrialsStr:String = XML_tools.findAttr(trial, 'trials');
		if (numTrialsStr == "") numTrialsStr = "1";
		
		var myTrials:Array<Dynamic>=setTrials(numTrialsStr,counter);
		//trace(myTrials,22)
		if(trials.length>0){
			setBlock(	XML_tools.findAttr(trial,"block")		);
			__setNames(	XML_tools.findAttr(trial,"trialName")	);
			setForced( 	XML_tools.findAttr(trial, "forcePositionInBlock", XML_tools.findAttr(trial,"forceBlockDepthPositions") ));
			order=correctOrder( XML_tools.findAttr(trial,"order",'order')	);
			
			sortDepthOrder( XML_tools.findAttr(trial,"blockOrder")	);

			var runTrial:Bool = true;
			if(XML_tools.findAttr(trial,"runTrial")=="false")runTrial=false;
			
			var info:Map<String,String> = new Map<String,String>();
			info.TRIAL_ID=blockPosition;
			info.runTrial=runTrial;
			info.bind_id= XML_tools.findAttr(trial,"__BIND");
			
			for(t in 0...myTrials.length){
				info.trialBlockPositionStart=t;
				info.order=myTrials[t];
				info.trialNames=names[t];
				composeTrial(info);
			}
		}
	}
	
	private function setForced(forcedBlock:String,forcedDepth:String):Void
	{
		
		if (forcedBlock != "" && forcedDepth != "") throw ('you cannot set both forcePositionInBlock and forceBlockDepthPositions in the same trial!');
		if(forcedBlock.concat(forcedDepth).indexOf(";")!=-1)throw ("you currently cannot use the ';' symbol in forcePositionInBlock and forceBlockDepthPositions");
		
			
		if(forcedBlock!=''){
			addForced(trials, forcedBlock,'block');
			trials=[];
			return;
		}
		forcePositionInBlockDepth=forcedDepth;
		if(forcedDepth!=''){
			addForced(trials, forcedDepth,'depth');
			trials=[];
		}
	}
	
	public function sortDepthOrder(ord:String):Void{

		blockDepthOrder=ord;
		if(blockDepthOrder.indexOf(",")!=-1){
			
			blockDepthOrderings=blockDepthOrder.split(",");
		
			for(i in 0...blockDepthOrderings.length){
				blockDepthOrderings[i]=correctOrder(blockDepthOrderings[i],'blockDepthOrder');
			}

			blockDepthOrder=DEFAULT_DEPTH_ORDER;
			
		}
		
		else blockDepthOrder=correctOrder(blockDepthOrder,'blockDepthOrder');

	
	}
	
	
	
	private function correctOrder(ord:String,what:String):String{
		var ordUpdated:String;
		ordUpdated=ord.toUpperCase();
		
		if(ordUpdated=='REVERSED')ordUpdated=REVERSE;
		else if(ordUpdated==''){
			if(what=='order')ordUpdated=RANDOM;
			else if(what=='blockDepthOrder')ordUpdated=DEFAULT_DEPTH_ORDER;
			else throw new Dynamic();
		}
		else if([REVERSE, RANDOM, FIXED].indexOf(ordUpdated)==-1)throw new Dynamic('you have specifed the '+what+' of a block in an unknown way:'+ord);

		return ordUpdated;
	}
	
	
	//unitTestMeSVP
	/*trace(test(3,"a;b;c","a;b;c")==true);
	trace(test(4,"a;b;c","a1;b1;c1;a2")==true);
	trace(test(9,"a;b;c","a1;b1;c1;a2;b2;c2;a3;b3;c3")==true);
	trace(names)
	
	function test(trialNum:Int,namesStr:String, ansStr:String):Bool{
		trials=[];
		for(i in 0...trialNum){
			trials.push(true);
		}
		
		__setNames(namesStr);
		
		var ans:Array<Dynamic>=ansStr.split(";");
		for(i in 0...ans.length){
			if(ans[i]!=names[i])return false;
		}
		return true;
	}*/
	
	
	public function __setNames(namesStr:String):Void
	{
		names=[];
		var origNames:Array<String>=namesStr.split(";");
		var iteration:Int=0;
		var i:Int = 0;
		for(trial in trials){
			
			names[i]=origNames[i%origNames.length];
			if(origNames.length<trials.length){
				iteration= Std.parseInt(i / origNames.length);
				names[i] += iteration + 1;
				i++;
			}	
		}
	}
	
	

	
	public function setTrials(t:String,counter:Int):Array<Int>
	{
		if(t=='')numTrials=1;
		else if(Std.parseInt(t)!=null)numTrials=Std.parseInt(t);
		else throw("you have set number of trials to a non numeric value of "+t);
		
		for(i in 0...numTrials){
			trials[trials.length]=counter+i;
		}
		
		return trials;
	}
	
	public function addTrials(arr:Array<Int>):Void{
		for(i in 0...arr.length){
			trials.push(arr[i]);
		}
	}
	
	public function setBlock(str:String):Void{

		if(str=='')throw('you MUST set the block of each of your trials');
		blocksIdent=str;
		var arr:Array<String>=str.split(",");
		for(i in 0...arr.length){
			blocksVect[blocksVect.length] = Std.parseInt(arr[i]);
		}
	}
	

	public function addForced(trials:Array<Int>, forcePosition:String,type:String):Void
	{
		//trace(trials,forcePosition,type,22)
		if(trials.length>0){
			if(type=='block'){
				if(forceBlockPositions == null) forceBlockPositions = [];
				forceBlockPositions.push({trials:trials,forcePosition:forcePosition});
			}
			else if(type=='depth'){ 
				if(forceBlockDepthPositions==null) forceBlockDepthPositions = [];
				forceBlockDepthPositions.push({trials:trials,forcePosition:forcePosition});
			}
			else throw("");
		}
	}
	
	public function pass_forcePositionInBlockDepth(arr:Array<Int>):Void{
		if(forceBlockDepthPositions == null) forceBlockDepthPositions =[];
		forceBlockDepthPositions=forceBlockDepthPositions.concat(arr);
	}
	
	public function getMaxTrial():Int
	{
		if(!forceBlockPositions && !forceBlockDepthPositions)	return trials[trials.length-1];

		var myTrials:Array<Int>;
		
		if (forceBlockDepthPositions)	myTrials = forceBlockDepthPositions[0].trials;
		else							myTrials = forceBlockPositions[0].trials;
	
		return myTrials[myTrials.length-1];
	}
	
	public function addForcedBlock(further_forceBlockPositions:Array<Int>):Void
	{
		if (forceBlockPositions == null) forceBlockPositions = [];
		
		for(i in 0...further_forceBlockPositions.length){
			forceBlockPositions.push(further_forceBlockPositions[i]);
		}
		
	}
}