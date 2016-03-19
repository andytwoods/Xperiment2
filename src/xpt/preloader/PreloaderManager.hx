package xpt.preloader;
import openfl.events.EventDispatcher;
import xpt.preloader.Preloader.PreloaderEvent;
import xpt.debug.DebugManager;
import xpt.ExptWideSpecs;
import xpt.stimuli.BaseStimulus;
import xpt.stimuli.StimuliFactory;
import xpt.trial.TrialSkeleton;

/**
 * ...
 * @author 
 */

using PreloaderManager.ExtractStimuli;

class PreloaderManager
{
	private var parent:EventDispatcher;
	
	public function new(skeletons:Array<TrialSkeleton>, parent:EventDispatcher) 
	{
		this.parent = parent;
		
		var preloadList:Array<String> = skeletons.extractLoadableStimuli();

		if (preloadList.length > 0) {
			
			preloadList.decorateFileLoc();

			DebugManager.instance.progress("Preloading " + preloadList.length + " image(s)");
			Preloader.instance.addEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
			Preloader.instance.addEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
			Preloader.instance.preloadImages(preloadList);
		}
		else {
			parent.dispatchEvent(new PreloaderEvent(PreloaderEvent.COMPLETE));
			kill();
		}
	}
	

	
	private function dispatch_to_parent(event:PreloaderEvent) {
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		parent.dispatchEvent(progressEvent);
	}
	
	private function _onPreloadProgress(event:PreloaderEvent) {
		dispatch_to_parent(event);
	}
	
	private function _onPreloadComplete(event:PreloaderEvent) {
		DebugManager.instance.progress("Preload complete");
		Preloader.instance.removeEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
		Preloader.instance.removeEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
		dispatch_to_parent(event);
		kill();
	}
	
	function kill() 
	{
		parent = null;	
	}
	
}

class ExtractStimuli {
	public static function extractLoadableStimuli(skeletons:Array<TrialSkeleton>):Array<String> {
		
		var loadable:Array<String> = new Array<String>();
		var baseStim:BaseStimulus;
		var props:Map<String,String>;
		
		for (skeleton in skeletons) {
			for (baseStim in skeleton.baseStimuli) {
				props = baseStim.props;
				if(props.exists(ExptWideSpecs.filename)) addStimuli(loadable, props.get(ExptWideSpecs.filename), baseStim.howMany, skeleton.trials.length);				
			}
		}

		return loadable;
		
	}
	
	static private function addStimuli(loadable:Array<String>, filenames:String, howMany:Int, trials:Int) 
	{
		var arr:Array<String> = filenames.split(ExptWideSpecs.stim_sep);
		for (str in arr.iterator()) {
			for(filename in str.split(ExptWideSpecs.trial_sep)){
				loadable.push(filename);
			}
		}
	}
	
	static public function decorateFileLoc(loadable:Array<String>) {
	
		var deco:String = ExptWideSpecs.IS('stimuliFolder');
		
		var str:String;
		for (i in 0...loadable.length) {
			loadable[i] = deco+loadable[i];
		}
		
	}
	


}
