package xpt.script;
import xpt.tools.Random;
import xpt.tools.XTools;


enum HowSelectCond {
	Random;	
}


class ToRun
{

	static public function select(how:HowSelectCond, options:Array<String>):String
	{
		return Random.randomlySelect(options);
	}
	
}