package xpt.tools;
import openfl.net.FileReference;

/**
 * ...
 * @author Andy Woods
 */
class SaveFile
{

	public function new() 
	{
		
	}
	
	static public function prompt_user_to_save(d:String, name:String) 
	{
		#if html5
			untyped __js__('var blob = new Blob([{0}])',d);
			untyped __js__('saveAs(blob, {0})', name);
		#elseif flash
			var fileRef:FileReference = new FileReference();
			fileRef.save(d, name);
		#else
			throw 'not developed yet';
		#end
		
	}
	
}