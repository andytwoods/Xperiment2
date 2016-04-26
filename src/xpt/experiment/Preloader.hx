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
					preloadedSound.set(file.id, file.data);
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
		
		var soundInfo:Map<String,Int> = null;
		
		if (soundLoader != null) {
			soundInfo = soundLoader.progress();
			event.current += soundInfo.get('current');
			event.total += soundInfo.get('total');
		}
		
		dispatchEvent(event);
		
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.COMPLETE);
		event.current = _current;
		event.total = _total;
		
		if (soundLoader != null) {
			event.current += soundInfo.get('current');
			event.total += soundInfo.get('total');
		}
		dispatchEvent(event);
	}
	
	
	private function fileType(str:String):String {
		var arr:Array<String> = str.split(".");
		return arr[arr.length - 1].toUpperCase();
	}
	
	private function soundLoader_callback(sl:SoundLoader) {
		if (sl.err == false) this.preloadedSound = sl.sounds;
		var keys:Array<String> = XTools.iteratorToArray(sl.sounds.keys());
		for (key in keys) {
			if (callBacks.exists(key)) {
				while (callBacks.get(key).length > 0) {
					var f:Void->Void = callBacks.get(key).shift();
					if (f != null) f();
				}
			}
		}
	}
	
	public function preloadStimuli(stimuli:Array<String>) {
		
		stimuli_to_load = stimuli;
		_total = 0;
		for (stimulus in stimuli) {
			switch(fileType(stimulus)) {
				case "JPG" | "PNG":
					_loader.queueImage(stimulus);
					_total++;
				case "SVG" | "TXT":
					_loader.queueText(stimulus);
					_total++;
				case "MP3":
					if (soundLoader == null) soundLoader = new SoundLoader();
					soundLoader.load(stimulus, soundLoader_callback);
					//_loader.queueSound(stimulus);
				default:
					throw 'unknown file type: ' + stimulus;
			}			
		}
		_current = 0;

		_loader.loadQueuedFiles();

		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.PROGRESS);
		event.current = _current;
		event.total = _total;
		
		var soundInfo:Map<String,Int>;
		if (soundLoader != null) {
			soundInfo = soundLoader.progress();
			event.current += soundInfo.get('current');
			event.total += soundInfo.get('total');
		}
		dispatchEvent(event);
		
		var event:PreloaderEvent = new PreloaderEvent(PreloaderEvent.BEGIN);
		event.current = _current;
		event.total = _total;
		
		if (soundLoader != null) {
			soundInfo = soundLoader.progress();
			event.current += soundInfo.get('current');
			event.total += soundInfo.get('total');	
		}
		

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

	public var sounds:Map<String,Sound> = new Map<String,Sound>();
    public var soundsArr:Array<SoundBundle> = new Array<SoundBundle>();
	public var err:Bool = false;
	public var complete:Bool = false;
	public var callback:SoundLoader->Void;
	private var totalMB:Int = 0;
	
	public function new(){}
	
	public function load(url:String, callback:SoundLoader->Void) {
		if (this.callback == null) this.callback = callback;
		soundsArr.push(new SoundBundle(url, callback_soundBundle));
		
	}
	
	function callback_soundBundle(sb:SoundBundle) 
	{
		if (sb.err == true) {
			err = true;
			complete = true;
			callback(this);
		}
		totalMB += Std.int(sb.bytesTotal);
		sounds.set(sb.url, sb.sound);
		soundsArr.remove(sb);
		if (soundsArr.length == 0) {
			complete = true;
			callback(this);
		}
	}
	
	public function progress():Map<String,Int> {
		var total:Int = totalMB;
		var current:Int = totalMB;
		
		for (sb in soundsArr) {
			total += Std.int(sb.bytesTotal);
			current += Std.int(sb.bytesLoaded);
		}
		return ["total"=> total, "current"=> current];
	}
}

class SoundBundle {
	var callback:SoundBundle->Void;
	public var sound:Sound;
	public var url:Url;
	public var completed:Bool = false;
	public var err:Bool = false;
	public var attempts:Int = 4;
	
	public var bytesTotal:Float = 0;
	public var bytesLoaded:Float = 0;
	
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
			sound.addEventListener(ProgressEvent.PROGRESS, progressL);
			sound.addEventListener(IOErrorEvent.IO_ERROR, errL);		
		}else {
			sound.removeEventListener(Event.COMPLETE, loadedL);
			sound.removeEventListener(ProgressEvent.PROGRESS, progressL);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, errL);		
		}
	}
	
	private function has_completed() {
		completed = true;	
		if (callback != null) callback(this);
	}
	
	private function progressL(e:ProgressEvent):Void 
	{
		this.bytesLoaded = e.bytesLoaded;
		this.bytesTotal = e.bytesTotal;
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