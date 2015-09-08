package xpt;

import haxe.macro.Context;
import haxe.macro.Expr;
import thx.Maps;

class ExptWideSpecs_Macros
{

	public static function generateLists(map:Map<String,String>):Array<Field>
	{
        var fields = Context.getBuildFields(); 
		/*
		for(key in map){
			fields.push( genField(key, map.get(key))  );
		}*/

        return fields;
	}
	
	/*static function genField(prop:String, val:String):Field
	{
		var field = new Field();
		/*field.name = prop;
		field.kind = FieldType.FVar(prop, toMap(val));
		field.access = [Access.APrivate];
		field.pos = Context.currentPos();
		
		
		return field;
	}
	
	static function toMap(val:String):Map<String,String>
	{
		var map:Map<String,String> = new Map();
		for (prop in val.split(",")) {
			map.set(prop, "");
		}
		return map;
	}
	

	
	static public function __getListStatic():Array<String>
	{
		var list:Array<String> = [];
		
		for (field in Type.getClassFields(ExptWideSpecs)) {
			if (field.charAt(0) != "_") {
			
				//if a function, don't add.
				if(Reflect.isFunction(Reflect.field(ExptWideSpecs, field)) == false)	list.push(field.split("special_").join(""));
			}
		}
 		return list;
	}*/
	
	
}