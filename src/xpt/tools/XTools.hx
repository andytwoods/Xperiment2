package xpt.tools;
import thx.Floats;
import thx.Ints;

/**
 * ...
 * @author 
 */
class XTools
{

	
	
	private static var shuffleArrMem:Map<String,Array<Float>>;
	
//Fisher-yates Shuffle, adapted from JS from here:http://bost.ocks.org/mike/shuffle/		
	

	public static function arrayShuffle <T>(arr:Array<T>,id:String=''):Array<T>{ 
		
		
		var m:Int = arr.length, t:Dynamic, i:Int;
		var randomList:Array<Float> = [];
		for(i in 0...m){
			randomList[i]=Math.random();
		}
		
		if(id!=''){
			if (shuffleArrMem == null) shuffleArrMem = new Map<String,Array<Float>>();
			if (shuffleArrMem[id] != null) {
				randomList = shuffleArrMem[id];
			}
			else {
				shuffleArrMem[id]=randomList;
			}

		}
		
		// While there remain elements to shuffle…
		while(m>0){
			// Pick a remaining element…
			
			i=Math.floor(randomList[m-1] * m--);
			// And swap it with the current element.
			t=arr[m];
			arr[m]=arr[i];
			arr[i]=t;
		}
		
		
		return arr;
	}
	
	
	static public function appendUpNumberedProps(map:Map<String,String>)
		{
			
			//concatenates up properties
			//below, searches for attribs appended with a 1.  These are special you see as they imply an 'appendUp' attribute.
			var appendUpAttribs:Array<String> = null;

			for (prop in map.keys()) {	
				
				if("1"== prop.charAt(prop.length-1) && prop.length > 1 && Ints.canParse(prop.charAt(prop.length-2)) == false){
					if(appendUpAttribs == null) appendUpAttribs = new Array<String>();
					if(appendUpAttribs.indexOf(prop)==-1){
						appendUpAttribs.push(prop.substr(0,prop.length-1));
					}
				}
			}
			
			if (appendUpAttribs == null) return;
			

			var i:Int;
			var appendUpProp:String;
			var appendUpVal:String;
			
			for(prop in appendUpAttribs){
				appendUpVal = '';
				i=0;
				while(true){
					appendUpProp=prop;
					
					if(i!=0)appendUpProp+=Std.string(i);
					if(map.exists(appendUpProp)){		
						appendUpVal+=map.get(appendUpProp);
						i++;
					}
					else break;	
				}		
				map[prop]=appendUpVal;
			}
					
		}

	
	public static inline function dynamic_to_StringMap(obj:Dynamic):Map<String,String> {
		var map:Map<String,String> = new Map<String,String>();
		
		for (prop in Reflect.fields (obj)) {
			map.set(prop, Reflect.field (obj, prop));		
		}

		return map;
	}

	public static function multiCorrection(s:String,seperator:String,dup:Int):String {

		if (s.indexOf(seperator)!=-1) {
			var tempArray:Array<String> = s.split(seperator);
			s=Std.string(tempArray[dup%tempArray.length]);
		}

		return s;

	}

	
	public static function iteratorToArray <T>(iterator:Iterator<T>):Array<T>{ 
		var arr:Array<T> = [];
		
		for (part in iterator) {
			arr[arr.length] = part;
		}
		return arr;
	}
		
	//use below as eg only
/*	
	public static function sortArrByIntProp <T>(prop:String, arr:Array<T>):Array<T>{ 
			arr.sort( function(a:T, b:T):Int
		{
			a = Reflect.field(a, prop);
			b = Reflect.field(b, prop);
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		} );
	}
		
	*/
		
	public static function arrsIdent < T > (arr1:Array<T>, arr2:Array<T>):Bool {
		if (arr1.length != arr2.length) return false;
		for (i in 0...arr1.length) {
			if (arr1[i] != arr2[i]) return false;
		}
		return true;
	}
	
	static public function cloneArr <T>(items:Array<T>) :Array<T>	
	{
		var arr:Array<T> = [];
		
		for (item in items) {
			arr[arr.length] = item;
		}
		
		return arr;
	}
	
/*	static public function copyArrInt(trials:Array<Int>):Array<Int> 
	{
		var arr:Array<Int> = [];
		for (i in 0...trials.length) {
			arr[arr.length] = trials[i];
		}
		return arr;
	}*/
	
	static public function sort <T>(arr:Array <T>):Array<T> {
		arr.sort( function(a:T, b:T):Int
				{
					return Reflect.compare(a, b);
				}
			);	
		return arr;
	}
	
	static public function strArr_to_FloatArr(strArr:Array<String>):Array<Float>
	{
		var arr:Array<Float> = [];
		
		for (i in 0...strArr.length) {
			var str = strArr[i];
			if (Floats.canParse(str)) {
				arr[i] = Floats.parse(str);
			}
			else return null;
		}
		return arr;
	}
	
	static public function xArr_to_StrArr <T>(strArr:Array<T>):Array<String>
	{
		var arr:Array<String> = [];
		
		for (i in 0...strArr.length) {
			arr[arr.length] = Std.string(strArr[i]);
		}
		return arr;
	}
	
	
		
	public static inline function protectCodeBlocks(str:String, searchNodeName:String):String
	{
		var arr:Array<String> = str.split("<" + searchNodeName); //left out > on purpose so any attributes in node dont break search
		if (arr.length == 1) return str;

		var txt:String;
		var endPos:Int;
		var startPos:Int;
		for (i in 0...arr.length) {
			txt = arr[i];
			endPos = txt.indexOf("</" + searchNodeName+">");
			if (endPos != -1) {
				startPos = txt.indexOf(">");
				if (startPos != -1) {
					startPos++;	
					arr[i] = txt.substr(0, startPos) + "<![CDATA[" + txt.substr(startPos, endPos - startPos) + "]]>" + txt.substr(endPos);
				}
			}
		}
		return arr.join("<"+searchNodeName);

	}

}