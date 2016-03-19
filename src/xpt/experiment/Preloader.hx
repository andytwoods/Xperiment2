package xpt.experiment;

import assets.manager.FileLoader;
import assets.manager.misc.FileInfo;
import assets.manager.misc.FileType;
import assets.manager.misc.LoaderStatus;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import xpt.debug.DebugManager;

class PreloaderEvent extends Event {
	public static inline var BEGIN:String = "preloadBegin";
	public static inline var COMPLETE:String = "preloadComplete";
	public static inline var PROGRESS:String = "preloadProgress";
	
	public var total:Int = 0;
	public var current:Int = 0;
	
	public function new(type:String) {
		super(type);
	}
}

class Preloader extends EventDispatcher {
	private static var _instance:Preloader;
	public static var instance(get, null):Preloader;
	private static function get_instance():Preloader {
		if (_instance == null) {
			_instance = new Preloader();
		}
		return _instance;
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// INSTANCE METHODS
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private var _loader:FileLoader;
	private var _total:Int;
	private var _current:Int;
	private var callBacks:Map <String, Array<Void->Void>> = new Map<String,Array<Void->Void>>();
	
	public var preloadedImages:Map<String, Bitmap> = new Map<String, Bitmap>();
	public var preloadedText:Map<String, String> = new Map<String, String>();
	public var stimuli_to_load:Array<String>;
	
	public function new() {
		super();
		_loader = new FileLoader();
		_loader.onFileLoaded.add(onFileLoaded);
		_loader.onFilesLoaded.add(onFilesLoaded);
	}
	
	private function onFileLoaded(file:FileInfo) {
		_current++;
		
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.PROGRESS);
		event.current = _current;
		event.total = _total;
		dispatchEvent(event);
        if (file.status == LoaderStatus.LOADED) {
			switch(file.type) {		
				case FileType.IMAGE:
					preloadedImages.set(file.id, new Bitmap(file.data));
				case FileType.TEXT:
					preloadedText.set(file.id, file.data);
				case FileType.SOUND:
					throw 'to do';
				case FileType.BINARY:
					throw 'to do';
			}	
		    
        } else {
            DebugManager.instance.error("Could not preload stimulus", file.id);
        }
		if (callBacks.exists(file.id)) {
			while (callBacks.get(file.id).length > 0) {
				var f:Void->Void = callBacks.get(file.id).shift();
				if (f != null) f();
			}
		}
		
		
		if (_current >= _total) {
			var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.COMPLETE);
			event.current = _current;
			event.total = _total;
			dispatchEvent(event);
		}
	}
	
	private function onFilesLoaded(files:Array<FileInfo>) {
		_current = files.length;
		_total = _current;
		
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.PROGRESS);
		event.current = _current;
		event.total = _total;
		dispatchEvent(event);
		
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.COMPLETE);
		event.current = _current;
		event.total = _total;
		dispatchEvent(event);
	}
	
	
	private function fileType(str:String):String {
		var arr:Array<String> = str.split(".");
		return arr[arr.length - 1].toUpperCase();
	}
	
	public function preloadStimuli(stimuli:Array<String>) {
		
		stimuli_to_load = stimuli;
		for (stimulus in stimuli) {
			switch(fileType(stimulus)) {
				case "JPG" | "PNG":
					_loader.queueImage(stimulus);
				case "SVG" | "TXT":
					_loader.queueText(stimulus);
				default:
					throw 'unknown file type: ' + stimulus;
			}			
		}
		_current = 0;
		_total = stimuli.length;
		_loader.loadQueuedFiles();

		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.PROGRESS);
		event.current = _current;
		event.total = _total;
		dispatchEvent(event);
		
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.BEGIN);
		event.current = _current;
		event.total = _total;
		dispatchEvent(event);
	}
	
	public function callbackWhenLoaded(nam:String, setBitmap:Void -> Void) 
	{
		if (callBacks.exists(nam) == false) {
			callBacks[nam] = new Array< Void -> Void >  ();
		}
		callBacks[nam].push(setBitmap);
	}
	
}