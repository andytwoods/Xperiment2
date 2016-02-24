package xpt.script;
import xpt.tools.XRandom;
import xpt.tools.XTools;




class ToRun
{

	static public function select(how:HowSelectCond, options:Array<String>):String
	{
		return XRandom.randomlySelect(options);
	}
	
}


enum HowSelectCond {
	Random;	
}
