package xpt.tools;

class PathTools {
    public static var experimentPath:String;
    public static var experimentName:String;
	
	public static function explictExptPath(path_filename:String) {
		
			var dir_arr:Array<String> = (path_filename).split("/");
			experimentName = dir_arr.pop().split(".")[0];
			dir_arr[dir_arr.length - 1] = '';
			experimentPath =  dir_arr.join("/");

	}
	
    public static function fixPath(path:String):String {
		return experimentPath + experimentName + "/stimuli/" + path;
    }
}