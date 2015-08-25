package xpt.trialOrder;

import haxe.Json;
import thx.Arrays;
import xpt.tools.XML_tools;
import xpt.tools.XTools;
import xpt.trialOrder.TrialBlock.ForceBlockPosition;
import xpt.trialOrder.OrderType;
using xpt.trialOrder.ForcePositionType;




class TrialBlock
{

	public var xml:Xml;
	public var blockPosition:Int;
	public var numTrials:Int = 0;
	public var trialNames:Array<String>;
	public var bind_id:String;

	public var order:String;
	public var blockDepthOrder:String;
	public var blockDepthOrders:Array<String>;
	public var alive:Bool = true;
	public var blocksIdent:String = "";
	public var blocksVect:Array<Int> = [];
	
	public var forceBlockPositions:Array<	ForceBlockPosition	>;
	public var forceBlockDepthPositions:Array<ForceBlockPosition>;
	
	public var forcePositionInBlock:Int;
	public var forcePositionInBlockDepth:Null<Int>;
	
	public var currentDepthID:Int;
	
	public var trials:Array<Int> = [];
	public var original_trials:Array<Int> = [];
	
	public var runTrial:Bool;
	
	public var preterminedSortOnOrder:Int; //used for SortOn, in another class
	
	public function trimBlocksVect():Void {
		blocksVect.pop();
		blocksIdent = blocksVect.join(",");
		//trace(222, blocksIdent);
	}
	
	public function giveParents():String{
		currentDepthID=blocksVect[blocksVect.length-1];
		return blocksVect.join(" ");
	}
	
	public function giveOnlyParents():String{

		var onlyParents:Array<String> = [];
		
		for(i in 0...blocksVect.length-1){
			onlyParents[onlyParents.length] = Std.string(blocksVect[i]);
		}

		return onlyParents.join(" ");
	}
		
	public function do_forcePositionInBlockDepth():Void{
		if (forceBlockDepthPositions != null) {
			SlotInForcePositions.DO(trials,forceBlockDepthPositions);
			forceBlockDepthPositions = null;
		}
	}
		
	public function setBlock(str:String):Void{
		blocksIdent=str;
		var arr:Array<String>=str.split(",");
		for(i in 0 ... arr.length){
			blocksVect.push(Std.parseInt(arr[i]));
		}
		//trace(blocksVect);
	}
	
	private function sortBlock(xml:Xml):Void {
		//var blo:String = XML_tools.findAttr_ignoreChildren(xml,"block"); 
		var blo:String = XML_tools.findAttr(xml,"block"); 
		if(blo == '')throw 'you MUST set the block of each of your trials. Not done so here: '+xml.toString();
		setBlock(blo);
	}
	
	public function addTrials(arr:Array<Int>):Void{
		for(i in 0...arr.length){
			trials.push(arr[i]);
		}
	}
	
	
	public function pass_forcePositionInBlockDepth(arr:Array<ForceBlockPosition>):Void {
			if (arr == null) return;
			if (forceBlockDepthPositions == null)  forceBlockDepthPositions = [];
			
			for (force in arr) {
				forceBlockDepthPositions[forceBlockDepthPositions.length] = force;
			}
		}
		
		public function getMaxTrial():Int
		{
			if (forceBlockPositions != null && forceBlockDepthPositions != null) {
				return trials[trials.length-1];
			}

			var myTrials:Array<Int>;
			
			if (forceBlockDepthPositions!=null)	myTrials = forceBlockDepthPositions[0].trials;
			else								myTrials = forceBlockPositions[0].trials;
		
			return myTrials[myTrials.length-1];
		}
		
		public function addForcedBlock(further_forceBlockPositions:Array<ForceBlockPosition>):Void
		{
			if (forceBlockPositions == null) forceBlockPositions = new Array<ForceBlockPosition>();
			for(i in 0...further_forceBlockPositions.length){
				forceBlockPositions.push(further_forceBlockPositions[i]);
			}
			
		}
	
	
	public function kill():Void{
		//trials=null;
		blocksIdent=null;
		this.alive=false;
	}
	
	public function new() { }
	
	
	public function setup(xml:Xml, counter:Int, blockPosition:Int) 
	{

		numTrials = getCount(xml);
		if (numTrials == 0) return;
		


		this.xml = xml;
		this.blockPosition = blockPosition;
		
		trials = getTrials(numTrials, counter);
		original_trials = XTools.cloneArr(trials);

		sortBlock(xml);
		trialNames = getNames(xml, numTrials, ExptWideSpecs.trialName);
		//trace(trials, 222);
		getForced(xml, numTrials);
		//trace(trials, 22222);
		order = getOrder(xml, "order");

		blockDepthOrders = getBlockDepthOrder(xml);
		
		runTrial = sortRunTrial();
	

		//doOrdering();
	}
	
	function sortRunTrial():Bool
	{
		var str:String = XML_tools.findAttr(xml, "runTrial").toLowerCase();
		
		return str == 'false';
	}
	
	function getTrials(t:Int, counter:Int):Array<Int>
	{
		var ts:Array<Int> = [];
		
		for(i in 0 ... numTrials){
			ts[ts.length]=counter+i;
		}
		
		return ts;
	}
	
	public static function getBlockDepthOrder(xml:Xml):Array<String>
	{
		var bdOrder:String = XML_tools.findAttr(xml, "blockDepthOrder"); 

		var arr:Array<String> = [];

		for (ord in bdOrder.split(",")) {
				arr[arr.length] = correctOrder(ord.toUpperCase(),'blockDepthOrder');
		}
		
		return arr;
	}
	
	public function getForced(xml:Xml, numTrials:Int)
	{
		var forceBlockStr:String = 	XML_tools.findAttr(xml, "forcePositionInBlock");
		var forceDepthStr:String = 	XML_tools.findAttr(xml, "forceBlockDepthPositions");
		
		check(forceBlockStr);
		check(forceDepthStr);
		
		//trace(forceBlockStr, forceDepthStr, 232);
		
		if (forceBlockStr != "" && forceDepthStr != "") throw "you cannot set both forcePositionInBlock and forceBlockDepthPositions in the same trial";
			

		if (forceBlockStr != "") {
				
				if (forceBlockPositions == null) forceBlockPositions = new Array<ForceBlockPosition>();

				forceBlockPositions.push(	get_ForBlockPosition(XTools.cloneArr(trials),forceBlockStr)	);	
				
				trials=[];
				
				return;
			
			}

		if (forceDepthStr != "") {

			if (forceBlockDepthPositions == null)	forceBlockDepthPositions = new Array<ForceBlockPosition>();
			var forceBlockPosition:ForceBlockPosition = get_ForBlockPosition(XTools.cloneArr(trials), forceDepthStr);
			
			forceBlockDepthPositions.push(	forceBlockPosition	);
			forcePositionInBlockDepth = forceBlockPosition.position;

			trials = [];
		}
	}
	
	
	function get_ForBlockPosition(trials:Array<Int>, forceStr:String):ForceBlockPosition {
			var fp:ForceBlockPosition = new ForceBlockPosition();
			
			fp.trials = trials;
			//fp.position = force;
			fp.positionStr = forceStr;
			return fp;
	}
	
	function check(fb:String)
	{
		if (fb.indexOf(";") != -1 || fb.indexOf(";") != -1) throw "you currently cannot use the ';' symbol in forcePositionInBlock and forceBlockDepthPositions";		
	}
	
	public function doOrdering():Void{
		//trace(1212112, order,trials);
		if(order=='' || order=='RANDOM')trials = XTools.arrayShuffle(trials);
		else if(order=="FIXED"){
			//do nothing}
		}
		else if(order=="REVERSED" || order=="REVERSE") trials.reverse();
		else throw "You have specifed trial order wrongly: "+order+" (should be either fixed, random, reversed or left blank).";
		//trace(222, trials);
	}
	
	public function forcePositions() {
		//note similar function above called do_forcePositionInBlockDepth();
		if (forceBlockPositions != null) {
			SlotInForcePositions.DO(trials,forceBlockPositions);
		}
	}
	
	
	public static function getOrder(xml:Xml, type:String):String
	{
		var ord:String = XML_tools.findAttr(xml, type);
		return correctOrder(ord.toUpperCase(), type);
	}
	
	private static function correctOrder(ordUpdated:String, type:String):String {
		if (ordUpdated == "REVERSED" || ordUpdated == "REVERSE") return OrderType.REVERSED;
		else if (ordUpdated == "RANDOM") return OrderType.RANDOM;
		else if (ordUpdated == "FIXED") return OrderType.FIXED;
		else if(ordUpdated==''){
			if(type=='order')return OrderType.RANDOM;
			else if(type=='blockDepthOrder')	return OrderType.DEFAULT_DEPTH_ORDER;
		}
		throw "";

		return OrderType.RANDOM;
	}
	
	
	
	
	
	
	
	
	
	
	
	public static function getNames(xml:Xml,trials:Int, nam:String):Array<String>
	{
		var names:String = XML_tools.findAttr(xml, nam);
		//trace(names, 2323233232,XML_tools.findAttr(xml, nam));
		var namesArr:Array<String> = names.split(ExptWideSpecs.trial_sep);
		var notUniqueTrialNames:Array<String> = [];
		
		for(i in 0 ... trials) {
			notUniqueTrialNames[i] = namesArr[ i % namesArr.length ];
		}
		
		var uniqueNames:Map<String, Int> = new Map<String, Int>();

		
		var name:String;
		for (i in 0 ... trials) {
			name = notUniqueTrialNames[i];
			if (uniqueNames.exists(name) == false) {	
				uniqueNames.set(name, 0);
			}
			else {
				uniqueNames.set(name, 1);
			}
		}
		
		var uniqueTrialNames:Array<String> = [];
		var val:Int;
		
		for (i in 0 ... trials) {
			name = notUniqueTrialNames[i];
			val = uniqueNames.get(name);
			if (val > 0 ) {
				uniqueNames.set(name,++val);
				name = name + Std.string(val-1);				
			}
			uniqueTrialNames[uniqueTrialNames.length] = name;
		}
		return uniqueTrialNames;
	}
	

	
	public static function getCount(xml:Xml):Int
	{
		var str:String = XML_tools.findAttr(xml,"trials");
		if (str == null)	return 1;
		if (Std.parseInt(str) == null)	return 1;
		if (str.indexOf(".") != -1)	throw ("must specify number of trials as a whole number, not" + str);
		return Std.parseInt(str);
	}
	
	
	
}

class ForceBlockPosition {
	public function new(){}	
	public var trials:Array<Int>;
	public var position:Int;
	public var positionStr:String;
	
}