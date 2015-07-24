package xpt.trialOrder_old.components.depthNode;

class DepthNodeBoss extends DepthNode
{

	public static var SEPERATER:String=" ";
	private var active:Bool=true;
	
	public function new(str:String)
	{
		if(str=="")active=false;
		else{
			var commands:Array<Dynamic>=str.split(SEPERATER);
			
			var arr:Array<Dynamic>;
			var depths:Array<Dynamic>;
			var value:String;
			
			for(i in 0...commands.length){
				arr=Std.string(commands[i]).split("=");
				if(arr.length!=2)throw new Dynamic("you have specifed a trial depth wrong:"+commands[i]+". Must be of the format 10=random or 10.1=random or *.1=random or 10.*=random.");
				depths=arr[0].split(",");
				value=arr[1];
				init(depths, value);
				
			}
		}
	}

	public function retrieve(str:String):String
	{
		if(active)	return __retrieve(str.split(" "));
		else return DepthNode.UNKNOWN;;
	}
	
	public function IsWildCard(str:String):Bool
	{
		if(active)	return __isWildCard(str.split(" "));
		else return DepthNode.UNKNOWN;;
	}
	

}