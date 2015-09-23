package;

import openfl.Lib;
import xpt.error.ErrorMessage;
import xpt.start.WebStart;


class Xpt {

	private static var localExptDirectory:String = "./experiments/";
	
	public static function main() {
		System.init();
		ErrorMessage.setup(Lib.current.stage);
		
		var expt:String = "test";
		var dir:String = localExptDirectory;
		
		var webStart:WebStart = new WebStart(dir, expt);
	}
}
