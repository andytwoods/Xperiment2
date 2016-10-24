package xpt.stimuli;
import thx.Arrays;
import thx.Floats;
import xpt.tools.XTools;
using xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class ETCs
{
	
	public static var list:Array<String>		= ["---etc---"	, ",,,etc,,,", ";;;etc;;;"]; //note this is legacy and only included to stop tests breaking.
	public static var splitByList:Array<String> = ["---", ",", ";"]; //note this is legacy and only included to stop tests breaking.
	private static var withinTrialSep:String ="---";
	private static var overTrialSep:String =";";
	
	static public function setLabels(stim_sep:String, trial_sep:String) 
	{
		withinTrialSep = stim_sep;
		overTrialSep = trial_sep;
		
		splitByList = [stim_sep, ",", trial_sep];
		
		list = new Array<String>();
		
		for (sym in splitByList) {
			list[list.length] = generate_seq(sym);	
		}
	}
	
	static private inline function generate_seq(sym:String):String {
		return sym + 'etc' + sym;
	}
	
	
	/*
	In a nutshell, search through all prop values looking for both ---etc--- and ,,,etc,,,
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
	inline static public function compose(props:Map<String, String>, trials:Int, howMany:Int) 
	{
		var iterate:Int;
		var val:String;
		var splitBy:String;
		
		
		for (splitter in ['---etc---']) {
			
			iterate = __getIterate(splitter, props, trials, howMany);
			splitBy = __getSplit(splitter);
			for (prop in props.keys()) {
				val = props.get(prop);
				if (val.indexOf(splitter) != -1) {
					val = val.split(splitter).join("");
					var newVal:String = __buildETC(splitBy, val, iterate);
					props.set(prop, newVal);
				}
			}
		}
		
	}
	
	inline static private function __getSplit(str:String):String
	{
		return splitByList[	list.indexOf(str)	];
	}
	
	inline static public inline function __getIterate(splitter:String, props:Map<String, String>, trials:Int, howMany:Int):Int 
	{
				
		var i:Int = howMany;
		
		var etcHowMany:String = props.get("etcHowMany");
		if (etcHowMany != null) i = Std.parseInt(etcHowMany);
		
		else if (splitter == generate_seq(overTrialSep)) {
			i= trials;
		}
		else if (splitter == generate_seq(withinTrialSep)) {
			var hm:String = props.get("howMany");
			if(hm !=null) i = Std.parseInt(hm);
		}



		return i;
	}


	public static inline function __buildETC(splitter:String, oldVal:String, iterate:Int):String
	{
			
		
		var isPercent:Bool = false;
		

		if(oldVal.indexOf("%")!=-1){
			oldVal=oldVal.split("%").join("");
			isPercent=true;
		}
		

		var etcArr:Array<String> = oldVal.split(splitter);
		
		if (etcArr.length <= 1) return oldVal;
		
		var numArr:Array<Float> = XTools.strArr_to_FloatArr(etcArr);
		var arr:Array<String> = null;
		if (numArr != null) {
			arr = __extendNumSequence(numArr, iterate);
		}
		else arr = __extendDecoratedNumSequence(etcArr, iterate);
		
		if (isPercent) {
			for (i in 0...arr.length) {
				arr[i] += "%";
			}
		}
		return arr.join(splitter);

	}
	
	inline static public function __extendDecoratedNumSequence(etcArr:Array<String>, iterate:Int):Array<String> 
	{
		var numText1 = new NumText(etcArr[0]);
		var numText2 = new NumText(etcArr[1]);
		if (numText1.failed || numText2.failed) return __extendTextSequence(etcArr, iterate);
		
		
		var result = __extendNumSequence([numText1.num, numText2.num], iterate);
		
		
		for (i in 0...result.length) {
			result[i] = numText1.decorate(result[i]);
		}
		
		
		return result;
	}
	
	inline static public function __extendTextSequence(etcArr:Array<String>, iterate:Int):Array<String>
	{
		var i:Int = 0;
		while (etcArr.length < iterate) {
			etcArr[etcArr.length] = etcArr[i++]; 
		}
		return etcArr;
		
	}
	
	
	inline static public function __extendNumSequence(numArr:Array<Float>, iterate:Int):Array<String>
	{
		var startingVal:Float = numArr[0];
		var nextVal:Float = numArr[1];
		var gap:Float = nextVal - startingVal;
		
		while (numArr.length < iterate) {
			var lastVal = numArr[numArr.length - 1] + gap;
			numArr[numArr.length] = lastVal;
		}
	
		return XTools.xArr_to_StrArr(numArr);
	}
}

class NumText {
	public var __numPos:Int = -1;
	public var __surroundingText:Array<String>;
	public var failed:Bool = false;
	public var num:Float;
	
	public function new(str:String) {
	
		__surroundingText = [];
		
		var numAsStr:String = "";
		var arrPos:Int = 0;
		var stopNumCheck:Bool = false;
		for (val in str.split("")) {
			if (stopNumCheck==false && (Floats.canParse(val) || val == ".")) {
				
				numAsStr += val;
				if (__numPos == -1) __numPos = arrPos +1;
				arrPos = 1;
			}
			else {
				if(__numPos!=-1)	stopNumCheck = true;
				if (__surroundingText.length < arrPos + 1) __surroundingText[arrPos] = "";
				__surroundingText[arrPos] += val;
			}
		}
		if (numAsStr.length == 0) failed = true;
		num = Std.parseFloat(numAsStr);
		
	}
	
	public function decorate(str:String):String
	{
		var a:Array<String> = __surroundingText.copy();
		a.insert(__numPos, str);
		return a.join("");
	}
	
	
}