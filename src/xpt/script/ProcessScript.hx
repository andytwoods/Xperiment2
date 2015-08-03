package xpt.script;
import assets.manager.FolderTree.Error;
import xmlTools.E4X;

class ProcessScript
{
	
	public function new() 
	{
		
	}
	
	public static function DO(script:Xml) {
		
		
		Templates.compose(script);
		ETCs.compose(script);
	
		
		/*		
		sortOutSpecialVariables(script);
		
		StimModify.sortOutOverExptMods(script);
		
		*/
		
		
		
	}

	
	
}
	
