package code.utils;

/**
 * ...
 * @author ...
 */
class Text
{


	public static function word(str:String, pos:Int):String {
		var words:Array<String> = str.split(" ");
		pos = pos % words.length;
		
		if (pos < 0) {
			pos = words.length + pos;
		}

		return words[pos];
	}
	
}