package xpt.experiment;

import assets.manager.FileLoader;
import assets.manager.misc.FileInfo;
import openfl.events.Event;
import openfl.events.EventDispatcher;

class PreloaderEvent extends Event {
	public static inline var BEGIN:String = "begin";
	public static inline var COMPLETE:String = "complete";
	public static inline var PROGRESS:String = "progress";
	
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
	
	public function preloadImages(images:Array<String>) {
		for (image in images) {
			_loader.queueImage(image);
		}
		_current = 0;
		_total = images.length;
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
}