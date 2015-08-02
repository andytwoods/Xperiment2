package xpt.script;
import assets.manager.FolderTree.Error;
import xmlTools.E4X;


/**
 * ...
 * @author 
 */
class ProcessScript
{
	
	public function new() 
	{
		
	}
	
	public static function DO(script:Xml) {
		
		Templates.compose(script);
		
	/*	sortOutETCs(script);
		
		sortOutSpecialVariables(script);
		
		StimModify.sortOutOverExptMods(script);
		
		*/
		
		
		
	}

	
	
}
	
