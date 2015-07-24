package xpt.trialOrder_old.components.depthNode;
import xpt.trialOrder_old.components.blockOrder.TrialBlock;




class DepthNode
{
	public var value:String;
	public var children:Map<String,DepthNode> = new Map<String,DepthNode>();
	public static var UNKNOWN:String='unknown';
	public static var WILDCARD:String="*";
	
	public function new() 
	{
		
	}

	public function init(depths:Array<String>,value:String):Void{

		if(depths.length==0 || value==''){
			throw("devel err");
		}
		
		var depth:String = depths.shift();
		if(children.exists(depth) == false) children[depth] = new DepthNode();
		if(depths.length==0)(children[depth]).value=clean(value.toUpperCase());
		
		if(depths.length>0)	(children[depth]).init(depths,value);	
	
	}
	

	public function __retrieve(depths:Array<String>):String{

		if(depths.length==0){
			if(value != null)	return value;
			else return UNKNOWN;
		}

		var depth:String=depths.shift();
		
		if(children[depth] != null)return(children[depth]).__retrieve(depths);

		if(depths.length==0 && children[WILDCARD] !=null)return(children[WILDCARD]).value;
		
		if(children[WILDCARD] != null)return(children[WILDCARD]).__retrieve(depths);
		return UNKNOWN;
	}
	
	public function __isWildCard(depths:Array<String>):Bool
	{
		if(depths.length==0){
			return false;
		}
		
		var depth:String=depths.shift();
		
		if(children[depth]!=null)return(children[depth]).__isWildCard(depths);
		
		if(depths.length==0 && children[WILDCARD]!=null)return true;
		
		if(children[WILDCARD]!=null)return(children[WILDCARD]).__isWildCard(depths);
		return false;
	}
	
	
	public function kill():Void{
		for(key in children){
			key.kill();
			key=null;
		}
		children=null;
	}
	
	private function clean(value:String):String
	{

		if([TrialBlock.FIXED,TrialBlock.RANDOM,TrialBlock.REVERSE].indexOf(value)!=-1)return value;
		else {
		
			
			var split:Array<String>=value.split(",");
			for(str in value.split(",")){
				if(Std.is(Std.parseInt(str),Int)==false) throw("you have specified an unknown type of trial ordering(you must numerically specify prespecified trial orderings, seperated by commas):"+value);
			}
			return TrialBlock.PREDETERMINED+value;
		}
		throw("you have specified an unknown type of trial ordering:"+value);
		return '';
	}
	
	//testing
	
	public function __combinedKinderCount():Int {
		var i:Int=0;
		
		for(child in children){
			i+=child.__combinedKinderCount();
		}
		

		return i+__kinderCount();
	}
	
	public function __kinderCount():Int{
		var i:Int=0;
		for(key in children){
			i++;
		}
		return i;
	}
}