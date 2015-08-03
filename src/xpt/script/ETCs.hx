package xpt.script;
using xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class ETCs
{

	public static var list:Array<String>		= ["---etc---"	, ",,,etc,,,", ";;;etc;;;"];

	inline static public function compose(script:Xml) 
	{
		var startingVal:String;
		var etcArr:Array<String>;
		var num:Int;
		var initEtcArrLen:Int;
		var difArr:Array<Int>;
		var etcSuffix:String="";
		var etcPrefix:String="";
		var prefix:String="";
		var tempnum:Int;
		
		/*
		In a nutshell, search throughout all of script looking for both ---etc--- and ,,,etc,,,
		---etc--- is for multiple objects per trial, where objects seperated by ---
		,,,etc,,, is for BOTH:
								object variations over trial
								AND also for any numbered sequence seperated by ,
		
		Objects are iterated by:
		---etc--- howMany in the object
		,,,etc,,, by specifying 'etcHowMany' parameter.
		
		note that ---etc--- howMany value can be overwritten by etcHowMany.
		
		Note that patterns can be picked up.  E.g. 1,4,5 will have a starting value of 1 and subsequent numbers will be 3 and then 1 bigger.
		
		Note that for both, you can specify etcPrefix and etcSuffix.
		
		Note that ,,,etc,,, works with behaviours, stripping out stuff before : and adding at the end.  
		NOTE THO, only works with ONE behaviour type currently.		
		NOOOOOTE THO that just use multiple behaviours to specify :) e.g. behaviours="a" behaviours2="b" etc etc
		*/
		
		var map:Map<String,Array<NodesWithFilteredAttribs>> = XML_tools.find_inVal(script, list);
		
		for (splitter in map.keys()) {
			for (nodesWithFilteredAttribs in map.get(splitter)){
			
				var iterate:Int = __getIterate(nodesWithFilteredAttribs.xml, splitter);
				var newVal:String = __buildETC(splitter, nodesWithFilteredAttribs.attribVal, iterate);
				
				nodesWithFilteredAttribs.xml.modifyAttrib(nodesWithFilteredAttribs.attribName, newVal);

			}
		}
	
		return script;
	}
	
	static public inline function __getIterate(stimulus:Xml, splitter:String):Int 
	{
		
		var num = Std.parseInt(stimulus.findAttr("howMany"));	
		
		if (splitter == ";;;etc;;;") {
			var str = XML_tools.findParentAttr(stimulus, "trials");
			num = Std.parseInt(str);
		}

		
		var etcHowMany:String = stimulus.findAttr("etcHowMany");
		if (etcHowMany != "") num = Std.parseInt(etcHowMany);

		return num;
	}
	
	public static inline function __buildETC(splitter:String, oldVal:String, iterate:Int)
	{
			var isPercent:String = "";
		

			if(oldVal.indexOf("%")!=-1){
				oldVal=oldVal.split("%").join("");
				isPercent="%";
			}
			

			var etcArr:Array<String> = oldVal.split(splitter);

			
			//if all the elements in the Array are numbers, only then perform 'etc' operation

			
			function myFilter(element:*, index:int, arr:Array):Boolean{
				if((tempnum=arr[index].indexOf(":"))!=-1){
					prefix=arr[index].split(":")[0]+":";
					arr[index]=arr[index].split(":")[1];
				}
				arr[index]=Number(arr[index]);//sneakily convert elements to Numbers while we are at it
				//trace(type,!isNaN(arr[index]),etcArr.length,num);
				return !isNaN(arr[index]);								
				
			}
			//trace(111,etcArr.filter(myFilter),etcArr.length , num)
			
			//////////////MAKE THIS COMPATIBLE WITH TEXT TOO
			if(etcArr.filter(myFilter).length==etcArr.length && num>=1){

				var pos1:Number=etcArr.shift();
				//etcArr.unshift(0);
				difArr=new Array;
				difArr[0]=etcArr[0]
				for(var i:uint=1;i<etcArr.length;i++){
					difArr.push(etcArr[i]-etcArr[i-1]+pos1);
	
				}

				if(difArr[0]==0)difArr.shift();
				
				etcArr.unshift(pos1);
				for(i=etcArr.length;i<num;i++){
					etcArr.push(etcArr[etcArr.length-1]+difArr[(i+1)%difArr.length]-pos1);
				}

				etcSuffix=(stimulus.@etcSuffix.toString());
				etcPrefix=(stimulus.@etcPrefix.toString());
				
				if( isPercent=="%"){
					
					etcArr[etcArr.length-1]+="%";
				}

				if(num==1){
					stimulus.@[attrib.name()]=prefix+etcArr[0]+isPercent;
				}
				
				else if(splitter=="---etc---"){
					
					stimulus.@[attrib.name()]=prefix+etcArr.join(etcSuffix+isPercent+"---"               +etcPrefix);
				}
				else{			
					
					stimulus.@[attrib.name()]=prefix+etcArr.join(etcSuffix+isPercent+splitter.substr(0,1)+etcPrefix);
				}

				
				
				
		}
	}
		
	
}