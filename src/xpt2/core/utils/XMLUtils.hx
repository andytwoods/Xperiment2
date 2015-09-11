package xpt2.core.utils;

class XMLUtils {
	public static function applyXMLProperties(object:Dynamic, xml:Xml, index:Int = 0, exceptions:Array<String> = null):Void {
		if (exceptions == null) {
			exceptions = new Array<String>();
		}
		for (attr in xml.attributes()) {
			var prop:String = attr;
			if (StringTools.endsWith(prop, "s") == true) {
				prop = prop.substr(0, prop.length - 1);
			}
			
			if (exceptions.indexOf(attr) != -1) {
				continue;
			}
			var arr:Array<String> = xml.get(attr).split(",");
			var value:String = arr[arr.length - 1];
			if (index < arr.length) {
				value = arr[index];
			}
			Reflect.setField(object, prop, value);
		}
	}
}