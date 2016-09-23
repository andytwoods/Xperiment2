package xpt.experiment;

import assets.manager.FileLoader;
import assets.manager.loaders.SoundLoader;
import assets.manager.misc.FileInfo;
import assets.manager.misc.FileType;
import assets.manager.misc.LoaderStatus;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.media.Sound;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.net.URLRequest;
import thx.Url;
import xpt.debug.DebugManager;
import xpt.experiment.Preloader.SoundBundle;
import xpt.tools.XTools;
import openfl.utils.ByteArray;

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
	public var success:Bool = true;
	public var failed_to_load:Array<String>;
	public var preloadedImages:Map<String, Bitmap> = new Map<String, Bitmap>();
	
	//below not needed as currently video handled entirely by external JS. As though preloading still done, necessary to pass video here to 1st be preloaded (and then retrieved from cache).
	//public var preloadedVideoUrl:Map<String, String> = new Map<String, String>();
	public var preloadedText:Map<String, String> = new Map<String, String>();
	
	private var preloadedSound:Map<String, Sound> = new Map<String, Sound>();
	
	public var stimuli_to_load:Array<String>;
	public var soundLoader:SoundLoader;
	
	public function new() {
		super();
		_loader = new FileLoader();
		_loader.onFileLoaded.add(onFileLoaded);
		_loader.onFilesLoaded.add(onFilesLoaded);
	}
	
	public function getSound(nam:String) {
		return preloadedSound.get(nam);
	}
	
	private function onFileLoaded(file:FileInfo) {
		
		if (file.status == LoaderStatus.LOADED) {
			switch(file.type) {		
				case FileType.IMAGE:
					preloadedImages.set(file.id, new Bitmap(file.data));
				case FileType.TEXT:
					preloadedText.set(file.id, file.data);
				case FileType.SOUND:
					preloadedSound.set(file.id, file.data);
				case FileType.VIDEO:
					//see explanation where preloadedVideoUrl defined
					//preloadedVideoUrl.set(file.id, file.id);
				case FileType.BINARY:
					throw 'to do';
			}	
		    
        } else {
			if (failed_to_load == null)  failed_to_load = new Array<String>();
			failed_to_load.push(file.id);
            DebugManager.instance.error("Could not preload stimulus", file.id);
			var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.COMPLETE);
			success = false;
			dispatchEvent(event);
        }

		_onFileLoaded(file.id);
	}
	
	public function failed_to_load_list():String {
	
		return failed_to_load.join(",");
	}
	
	private function _onFileLoaded(id:String) {
		_current++;
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.PROGRESS);
		event.current = _current;
		event.total = _total;
		dispatchEvent(event);
		if (callBacks.exists(id)) {
			var file_callbacks = callBacks.get(id);
			for(i in 0...file_callbacks.length) {
				var f:Void->Void = file_callbacks[i];
				if (f != null) f();
			}
			file_callbacks = null;
		}
		else {
			
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
	
	private function soundLoader_callback(sl:SoundLoader, nam:String, sound:Sound) {
		if (sound == null) {
			'do something';
			return;
		}

		preloadedSound.set(nam, sound);
		_onFileLoaded(nam);
	}
	
	public function preloadStimuli(stimuli:Array<String>) {
		
		stimuli_to_load = stimuli;
		_current = _total = 0;
		for (stimulus in stimuli) {
			switch(fileType(stimulus)) {
				case "JPG" | "JPEG" | "PNG":
					_loader.queueImage(stimulus);
				case "SVG" | "TXT":
					_loader.queueText(stimulus);
				case "MP4":
					_loader.queueVideo(stimulus);
				case "MP3" | "WAV":
					if (soundLoader == null) soundLoader = new SoundLoader();
					soundLoader.load(stimulus, soundLoader_callback);
				default:
					throw 'unknown file type: ' + stimulus;
			}
			_total++;
		}
		

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

class SoundLoader {

    public var soundsArr:Array<SoundBundle> = new Array<SoundBundle>();
	public var err:Bool = false;
	public var complete:Bool = false;
	public var callback:SoundLoader->String->Sound->Void;
	
	public function new(){}
	
	public function load(url:String, callback:SoundLoader->String->Sound->Void) {
		if (this.callback == null) this.callback = callback;
		
		soundsArr.push(new SoundBundle(url, callback_soundBundle));
	}
	
	function callback_soundBundle(sb:SoundBundle) 
	{
		
		if (sb.err == true) {
			err = true;
		}
		
		soundsArr.remove(sb);
		
		callback(this, sb.url, sb.sound);
	}
}

class SoundBundle {
	var callback:SoundBundle->Void;
	public var sound:Sound;
	public var url:Url;
	public var completed:Bool = false;
	public var err:Bool = false;
	public var attempts:Int = 4;

	
	public function new(url:String, callback:SoundBundle-> Void) {
		this.callback = callback;
		this.url = url;
		load();
	}
	
	function load() {
		sound = new Sound();
		listeners(true);
		sound.load(new URLRequest(url));
	}
	
	private function listeners(on:Bool) {
		if (on) {
			sound.addEventListener(Event.COMPLETE, loadedL);
			sound.addEventListener(IOErrorEvent.IO_ERROR, errL);		
		}else {
			sound.removeEventListener(Event.COMPLETE, loadedL);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, errL);		
		}
	}
	
	private function has_completed() {
		completed = true;	
		if (callback != null) callback(this);
	}
	

	
	private function errL(e:IOErrorEvent):Void 
	{
		listeners(false);
		err = true;
		if (attempts-- > 0) {
			load();
		}
		else has_completed();
	}
	
	private function loadedL(e:Event):Void 
	{
		listeners(false);
		has_completed();
	}
}