package diagnositics;
import xpt.debug.DebugManager;

class DiagnosticsManager {
    public static inline var EXPERIMENT_START:String = "experiment.start";
    public static inline var EXPERIMENT_END:String = "experiment.end";
    public static inline var TRIAL_START:String = "trail.start";
    public static inline var TRIAL_END:String = "trail.start";
    public static inline var STIMULUS_SHOW:String = "stimulus.show";
    public static inline var STIMULUS_HIDE:String = "stimulus.hide";
    public static inline var STIMULUS_CLICK:String = "stimulus.click";
    
    private static var _instance:DiagnosticsManager;
    public static var instance(get, null):DiagnosticsManager;
    private static function get_instance():DiagnosticsManager {
        if (_instance == null) {
            _instance = new DiagnosticsManager();
        }
        return _instance;
    }
    
    
    public static function add(type:String, sourceId:String = null, sourceType:String = null, additionalInfo:Array<String> = null):DiagnosticsRecord {
        return instance.addDiagnosics(type, sourceId, sourceType, additionalInfo);
    }
    
	////////////////////////////////////////////////////////////////////////
	// INSTANCE
	////////////////////////////////////////////////////////////////////////
    private var _records:Array<DiagnosticsRecord> = new Array<DiagnosticsRecord>();
    
    public function new() {
        
    }
    
    public function addDiagnosics(type:String, sourceId:String = null, sourceType:String = null, additionalInfo:Array<String> = null):DiagnosticsRecord {
        var timestamp:Float = Timestamp.get();
        var record:DiagnosticsRecord = new DiagnosticsRecord(timestamp, type, sourceId, sourceType, additionalInfo);
        
        var details = 'timestamp: ${timestamp}\nsourceId: ${sourceId}\nsourceType: ${sourceType}';
        if (additionalInfo != null) {
            for (info in additionalInfo) {
                details += '\n${info}';
            }
        }
        DebugManager.instance.info('Adding diagnostics: ${type}', details);
        
        _records.push(record);
        
        return record;
    }
}