package xpt2.core.entities;

class ExperimentMetadata {
	private function new() {
	}

	public static function fromXML(xml:Xml):ExperimentMetadata {
		var m:ExperimentMetadata = new ExperimentMetadata();
		return m;
	}
	
	public static function defaultMetadata():ExperimentMetadata {
		var m:ExperimentMetadata = new ExperimentMetadata();
		return m;
	}
}