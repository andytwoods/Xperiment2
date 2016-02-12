package xpt;

import openfl.system.Capabilities;
#if html5
	import js.html.Navigator;
#end

/**
 * ...
 * @author 
 */
class ComputerInfo
{

	public static function GET():Map<String,String>
	{
		var map:Map<String,String> = new Map<String,String>();
		
		map.set('resX', Std.string(Capabilities.screenResolutionX));
		map.set('resY', Std.string(Capabilities.screenResolutionY));
		map.set('DPI', Std.string(Capabilities.screenDPI));
		map.set('CPU', Capabilities.cpuArchitecture);
		
		#if html5
			map.set('browser', untyped window.navigator.userAgent);
		#end
		return map;
	}
	
}