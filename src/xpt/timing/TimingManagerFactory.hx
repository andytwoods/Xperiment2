package xpt.timing;

class TimingManagerFactory {
	private static var _managerClass:Class<TimingManager> = xpt.timing.managers.BaseTimingManager;
	
	private static var _managerAlias:Map<String, Class<TimingManager>> = [
		"actuate" => xpt.timing.managers.ActuateTimingManager,
		"default" => xpt.timing.managers.BaseTimingManager,
		"delay" => xpt.timing.managers.DelayTimingManager,
		"delta" => xpt.timing.managers.DeltaTimingManager
	];
	
	public function new() {
		
	}

	public static var managerClassAlias(never, set):String;
	private static function set_managerClassAlias(value:String):String {
		_managerClass = _managerAlias.get(value);
		return value;
	}
	
	public function create():TimingManager {
		var c:Class<TimingManager> = _managerClass;
		if (c == null) {
			throw "No timing manager found";
		}
		return Type.createInstance(c, []);
	}
}