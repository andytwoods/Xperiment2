package xpt.tools;

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
	
	static public function duplicateArr <T>(items:Array<T>) :Array<T>	
	{
		var arr:Array<T> = [];
		
		for (item in items) {
			arr[arr.length] = item;
		}
		
		return arr;
	}
	
	static public function copyArrInt(trials:Array<Int>):Array<Int> 
	{
		var arr:Array<Int> = [];
		for (i in 0...trials.length) {
			arr[arr.length] = trials[i];
		}
		return arr;
	}
}