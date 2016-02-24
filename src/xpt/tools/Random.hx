package xpt.tools;

/**
 * ...
 * @author Andy Woods
 */
class Random
{

	public function new() 
	{
		
	}
	
	static public function float(float:Float, float1:Float) :Float
	{
	
		return 0;
	}
	
	static public function string(float:Float):String
	{
		return '';
	}
	

		
	private static var shuffleArrMem:Map<String,Array<Float>>;
	
//Fisher-yates Shuffle, adapted from JS from here:http://bost.ocks.org/mike/shuffle/		
	
	public static function shuffle <T>(arr:Array<T>,id:String=''):Array<T>{ 
		
		
		var m:Int = arr.length, t:Dynamic, i:Int;
		var randomList:Array<Float> = [];
		for(i in 0...m){
			randomList[i] = Random.float(0, 1);
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
	
	static public function randomlySelect <T>(options:Array<T>):T
	{
		var arr:Array<T> = shuffle(options);
		return arr[0];
	}
	

}