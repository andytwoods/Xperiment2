package xpt2.core.utils;

class ObjectUtils {
	public static function copyProperties(source:Dynamic, target:Dynamic, exceptions:Array<String> = null) {
		if (exceptions == null) {
			exceptions = new Array<String>();
		}
		
		for (f in Reflect.fields(source)) {
			if (exceptions.indexOf(f) != -1) {
				continue;
			}
			
			if (Reflect.field(target, f) == null) {
				Reflect.setField(target, f, Reflect.field(source, f));
			}
		}
	}
}