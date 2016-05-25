package xpt.backend_driven_expt;
import haxe.Json;
import xpt.backend_driven_expt.BackendDriven.Questions;
import xpt.comms.services.UrlParams_service;

class BackendDriven
{
	
	public static var _instance:BackendDriven;
	public static var instance(get, never):BackendDriven;
	
	private static function get_instance():BackendDriven {
		if (_instance == null) {
			_instance = new BackendDriven();
		}
		return _instance;
	}
	
	
	public function new() 
	{	
	}


	
	private function startup(info:String) {
		var decoded:String = StringTools.urlDecode(info);
		decoded = decoded.split("'").join("\"");
		var crunched: { method:String, data:Array<String> } = Json.parse(decoded);
		var questions = new Array<Question>();
		for (n in Reflect.fields(crunched))
			questions.push(process_row(Reflect.field(crunched, n)));
			
		return questions;
	}
	
	private function process_row(row) {
		var question:Question = new Question();
		
		for (n in Reflect.fields(row)){
			if(Reflect.hasField(question, n)){
				Reflect.setField(question, n, Reflect.field(row, n));
			}
		}
		return question;
	}
	
	
	public function process(script:String) {
			var backend_driven_expt:String = UrlParams_service.get('backend_driven_expt');
			backend_driven_expt = '[{"instance_id":"RMb1g","question_id":"q1","image":"/static/img/line_scale.svg","q":"How innovative is the logo?","lhs":"not at all","rhs":"very much so","images":["https://questionator.s3.amazonaws.com/0a98a8fd83974f5699c6495fbd02d6a7/media/1.png","https://questionator.s3.amazonaws.com/0a98a8fd83974f5699c6495fbd02d6a7/media/6.png"]}]';
			if (backend_driven_expt.length > 0) {
				var Qs:Questions = new Questions(backend_driven_expt);	
				if (Qs.proceed()) {
					return applyToScript(Qs, script);
				}
			}
			return script;
	
	}
	
	function applyToScript(Qs:Questions, script:String):String
	{
		var map:Map<String,String> = Qs.combine();
		for (key in map.keys()) {
			script = script.split(key).join(map.get(key));
		}
		return script;
	}
}


class Questions {
	public var questions:Array<Question> = new Array<Question>();
	var lhs:String = "{{ ";
	var rhs:String = " }}";
	

	
	public inline function proceed() {
		return questions.length > 0;
	}
	
	public function new(info:String) {
		var decoded:String = StringTools.urlDecode(info);
		decoded = decoded.split("'").join("\"");
		var crunched:{method:String,data:Array<String>} = Json.parse(decoded);
		for (n in Reflect.fields(crunched))
			process_row(Reflect.field(crunched, n));
	}
	
	private function process_row(row) {
		var question:Question = new Question();
		
		for (n in Reflect.fields(row)){
			if(Reflect.hasField(question, n)){
				Reflect.setField(question, n, Reflect.field(row, n));
			}
		}
		questions.push(question);
	}
	
	public function combine() {
		var combined:Question = new Question();
		var first:Question = questions[0];
		var arr:Array<String>;
		
		var hack_count:Int = 1;
		var variables = ['rhs', 'lhs', 'q', 'images'];
		var val:String;
		for (f in variables){
			arr = [];
			for (q in questions) {
				val = Reflect.getProperty(q, f);
				if (f == 'images') {
					hack_count = val.split(',').length;
					val = val.split(',').join('|');
				}
				arr.push(val);
			}

			Reflect.setField(combined, f, arr.join("|"));
		}

		var map:Map<String, String> = new Map<String, String>();
		var question_id:String = questions[0].question_id;
		
		for (f in variables) {
			map.set(lhs + question_id + "." + f + rhs, Reflect.getProperty(combined, f));
		}
		
		trace(map);

		map.set(lhs + question_id+'.trials' + rhs, Std.string(hack_count));
		return map;
	}
	
}

class Question {

	public function new() {
		
	}
	
	public var rhs:String;
	public var lhs:String;
	public var q:String;
	public var images:String;
	public var question_id:String;
	
	
}