package diagnositics;

class DiagnosticsRecord {
    public var timestamp(default, default):Float;
    public var eventType(default, default):String;
    public var sourceId(default, default):String;
    public var sourceType(default, default):String;
    
    public function new(timestamp:Float, eventType:String, sourceId:String = null, sourceType:String = null) {
        this.timestamp = timestamp;
        this.eventType = eventType;
        this.sourceId = sourceId;
        this.sourceType = sourceType;
    }
}