package xpt.tools;
import de.polygonal.core.math.Limits;
import de.polygonal.core.math.random.Mersenne;
import de.polygonal.core.math.random.ParkMiller;
import de.polygonal.core.math.random.ParkMiller31;
import de.polygonal.core.math.random.RNG;




enum RandomAlgorithm {
	Mersenne;
	ParkMiller;
	ParkMiller31;
}

class XRandom
{
	
	private static var rnd:RNG;
	private static var algorithm:String;
	
	public static function init(type:RandomAlgorithm) {
		algorithm = type.getName();
		switch(type) {
			case Mersenne:
				rnd = new Mersenne();
			case ParkMiller:
				rnd = new ParkMiller();
			case ParkMiller31:
				rnd = new ParkMiller31();
		}
	}
	

	static public function random():Float {
		#if html5
			return rnd.randomFloatRange(0, 1);
		#end
		return rnd.randomFloatRange(0, 1) + .5;
	}
	
	//from https://github.com/jasononeil/hxrandom/blob/master/src/Random.hx
	static public function string(len:Int, ?charactersToUse = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String
	{
		var str = "";
		for (i in 0...len)
		{
			str += charactersToUse.charAt(Std.int(random()*charactersToUse.length-1));
		}
		return str;
	}
	
	
	static public function randomlySelect <T>(options:Array<T>):T
	{
		var rand:Int = Std.int((options.length - 1) * random());
		return options[rand];
	}

		
	private static var shuffleArrMem:Map<String,Array<Float>>;
	
//Fisher-yates Shuffle, adapted from JS from here:http://bost.ocks.org/mike/shuffle/		
	
	public static function shuffle <T>(arr:Array<T>,id:String=''):Array<T>{ 
		
		var m:Int = arr.length, t:Dynamic, i:Int;
		var randomList:Array<Float> = [];
		for (i in 0...m) {	
			
			randomList[i] = random();
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
	
	static public function setSeed(seedStr:String) 
	{
		var seed:Int = 1;
		if (seedStr == "" || seedStr.toLowerCase() == 'random') {
			seed = Std.int(Math.random() * Limits.UINT16_MAX);
		}
		else seed = Std.parseInt(seedStr);

		rnd.setSeed(seed);
	}
	
	static public function getSeed() 
	{
		return Std.string(rnd.getSeed())+"("+ algorithm+")";
	}
	
	

}