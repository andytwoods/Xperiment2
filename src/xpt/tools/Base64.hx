package xpt.tools;
import haxe.crypto.BaseCode;

class Base64 {
	
	
	public static var CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	public static inline function encode( t : String ) : String {
		return BaseCode.encode( t, CHARS ) + "=";
	}
	

	

}