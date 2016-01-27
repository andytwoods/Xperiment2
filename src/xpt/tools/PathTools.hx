package xpt.tools;

class PathTools {
    public static var experimentPath:String;
    public static var experimentName:String;
    public static function fixPath(path:String):String {
        return experimentPath + experimentName + "/stimuli/" + path;
    }
}