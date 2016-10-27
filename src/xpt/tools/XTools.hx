package xpt.tools;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.utils.Timer;
import thx.Floats;
import thx.Ints;
import xpt.preloader.Preloader;
import xpt.tools.XRandom;
import xpt.stimuli.Stimulus;

/**
 * ...
 * @author 
 */
class XTools
{

	private static inline var startProtected:String = "<![CDATA[";
	private static inline var endProtected:String = "]]>";

	
	// returns a function that ensures response only every X ms
	static public function onceEvery(time_period:Int):Void->Bool {

		var t:Timer = null;
		
		return function():Bool {
			
			if (t != null && t.running == true) {
				return false;
			}

			t = new Timer(time_period, 0);

			function timerEnd(e:TimerEvent) {
				t.stop();
				t.removeEventListener(TimerEvent.TIMER, timerEnd);
			}
			t.addEventListener(TimerEvent.TIMER, timerEnd);
		
			t.start();	
			return true;
		}
	}
	
	static public function stimuli_to_map(stimuli:Array<Stimulus>):Map<String,Stimulus> {
		var map = new Map<String, Stimulus>();
		for (stim in stimuli) {
			map[stim.id] = stim;
		}
		return map;
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
					
					if (i != 0) appendUpProp += Std.string(i);

					if(map.exists(appendUpProp)){		
						appendUpVal += map.get(appendUpProp);
						if (i == 0) {
							map.set(prop + "0", appendUpVal);
						}
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
					arr[i] = txt.substr(0, startPos) + startProtected + txt.substr(startPos, endPos - startPos) + endProtected + txt.substr(endPos);
				}
			}
		}
		return arr.join("<"+searchNodeName);

	}

	
	static public inline function removeProtectedTextIndicators(nodeVal:String) :String
	{
		if (nodeVal.substr(0, startProtected.length) == startProtected) {
			nodeVal = nodeVal.substr(startProtected.length, nodeVal.length - startProtected.length - endProtected.length);
		}
		return nodeVal;
	}
	
	static public inline function delay(time:Int, f:Void -> Void) 
	{
		var t:Timer = new Timer(time,0);
		function timerEnd(e:TimerEvent){
			t.removeEventListener(TimerEvent.TIMER, timerEnd);
			f();
		}
		t.addEventListener(TimerEvent.TIMER, timerEnd);
		t.start();
	}
	
	static public inline function filetype(str:String, uppercase:Bool = false):String {
		var arr:Array<String> = str.split(".");
		str = arr[arr.length - 1];
		if (uppercase) str = str.toUpperCase();
		return str;
	}
	
	public static function getColour(colour:String):Int{	
		switch((colour).toLowerCase()){
			case "red":
				return 0xFF0000;
			case "green":
				return 0x00FF00;
			case "blue":
				return 0x0000FF;
			case "yellow":
				return 0xFFFF00;
			case "pink":
				return 0xFFC0CB;
			case "orange":
				return 0xFFA500;
			case "white":
				return 0xFFFFFF;
			case "brown":
				return 0xA52A2A;
			case "black":
				return 0x000000;
			case "grey" | "gray":
				return 0x808080;
			case "purple":
				return 0x800080;
				//colours defined here http://www.htmlgoodies.com/tutorials/colors/article.php/3478961/So-You-Want-A-Basic-Color-Code-Huh.htm
		}
		
		if(colour.charAt(0)=="#")colour = "0x" + colour.substr(1);
		
		if(Ints.canParse(colour)) {
			return Ints.parse(colour);
		}
		
		if(Ints.canParse('0x'+colour)) {
			return Ints.parse('0x'+colour);
		}
		
		
		
		throw "you have specified a colour incorrectly or have used text I don't understand:"+colour;
		return 0;
	}
	
	static public function callBack_onEvent(listenOn:EventDispatcher, listenFor:String, callBackF:Event->Void) 
	{
		function caller(e:Event) {
			listenOn.removeEventListener(listenFor, caller);
			callBackF(e);
		}
		
		listenOn.addEventListener(listenFor, caller);
		
		
	}
	
		
	static public inline function safeProp(nam:String, results:Map<String, String>):String
	{
		var temp_nam:String = nam;
		var count:Int=1;
		
		while(results.exists(temp_nam)){
			temp_nam = nam + Std.string(count); 
			count++;
		}
		return temp_nam;
		
	}	
	
	// https://web.archive.org/web/20130925180002/http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
	public static function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, as_seg:Bool = true):Point {
			
		var ip:Point;
		var a1:Float;
		var a2:Float;
		var b1:Float;
		var b2:Float;
		var c1:Float;
		var c2:Float;
	 
		a1= B.y-A.y;
		b1= A.x-B.x;
		c1= B.x*A.y - A.x*B.y;
		a2= F.y-E.y;
		b2= E.x-F.x;
		c2= F.x*E.y - E.x*F.y;
	 
		var denom:Float=a1*b2 - a2*b1;
		if (denom == 0) {
			return null;
		}
		ip=new Point();
		ip.x=(b1*c2 - b2*c1)/denom;
		ip.y=(a2*c1 - a1*c2)/denom;
	 
		//---------------------------------------------------
		//Do checks to see if intersection to endpoints
		//distance is longer than actual Segments.
		//Return null if it is with any.
		//---------------------------------------------------
		if(as_seg){
			if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
			{
			   return null;
			}
			if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
			{
			   return null;
			}
	 
			if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
			{
			   return null;
			}
			if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
			{
			   return null;
			}
		}
		return ip;
	}
	

	public static function moderate(change:Float, actual:Float, central_limit:Float):Float {

		if (actual> central_limit) {
			if (actual - change < central_limit) return central_limit - actual;
			return -change;
		}
		
		if (actual + change > central_limit)  return central_limit - actual;
		return change;
	}
		

}