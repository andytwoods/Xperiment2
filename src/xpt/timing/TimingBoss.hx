package xpt.timing;

import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import openfl.display.Sprite;
import thx.Floats;
import thx.Ints;
import xpt.stimuli.Stimulus;
import xpt.tools.XTools;

class TimingBoss {
	public static inline var MAX:Int = 10000000;
	public static inline var MIN:Int = -10000000;
	
	public static inline var BOTTOM:Int = MAX;
	
	public static inline var TOP:Int=MIN;
	public static inline var FOREVER:Float = MAX;
	
	public var __startTimeSorted:Array<Stimulus>;
	public var __endTimeSorted:Array<Stimulus>;
	public var __mainTimer:TickTimer;
	public var __objsOnScreen:Array<Stimulus>;
	
	private var stageCount:Int;
	public var running:Bool=true;
	public var __allStim:Array<Stimulus>;
	
	public function new() {
		__mainTimer = new TickTimer(0);
		__mainTimer.callBack = checkForEvent;
		instantiateArrs(true);
	
		running = true;
	}
	
	private inline function instantiateArrs(DO:Bool) {
		if (DO) {
			__startTimeSorted = [];
			__endTimeSorted = [];
			__objsOnScreen = [];
			__allStim = [];
		} else {
			__startTimeSorted = null;
			__endTimeSorted = null;
			__objsOnScreen = null;
			__allStim = null;
		}
	}
	
	public function getMS():Float{
		return __mainTimer.now;
	}

	public function kill() {
		running=false;
		__mainTimer = null;
		
		for (i in 0...__objsOnScreen.length) {
			removeStimulus(__objsOnScreen[i]);
		}
		
		instantiateArrs(false);
		stragglers();
	}
	
	private function stragglers() {
		if (RootManager.instance.currentRoot != null) {
			if (stageCount < RootManager.instance.currentRoot.numChildren) {
				for (i in 0...RootManager.instance.currentRoot.numChildren) {
					trace("child:", RootManager.instance.currentRoot.getChildAt(i));
				}
				trace("devel error:more elements on screen after end of trial than before start");
			}
		}
	}

	//this function needs testing.
	public function add(stim:Stimulus) {
		if (__startTimeSorted.indexOf(stim) == -1) {
			__startTimeSorted.push(stim);
		}
		if (__endTimeSorted.indexOf(stim) == -1) {
			__endTimeSorted.push(stim);
		}
		if (__allStim.indexOf(stim) == -1) {
 			__allStim.push(stim);
		}
	} 

	public function sortTime() {
		if (__startTimeSorted != null) {
			__sortOn("start", __startTimeSorted);
		}
		if (__endTimeSorted != null) {
			__sortOn("stop", __endTimeSorted);	
			var temp = new Array<Stimulus>();
			for (stim in __endTimeSorted) {
				if (stim.stop >= 0) {
					temp.push(stim);
				}
			}
			__endTimeSorted = temp;
		}
	}

	public function checkForEvent(time:Float) {
		if (running) {
			while (running && __startTimeSorted.length != 0 && __startTimeSorted[0].start <= time) {
				trace("show");
				__addToScreen(__startTimeSorted.shift());
			}
			
			while (running && __endTimeSorted.length != 0 && __endTimeSorted[0].stop < time) {
				trace("hide");
				stopStimulus(__endTimeSorted.shift());
			}
		}
	}
	
	public function start(autoStart:Bool) {
		if (RootManager.instance.currentRoot != null) {
			stageCount = RootManager.instance.currentRoot.numChildren;
		}
		sortTime();
		
		if (autoStart) {
			__mainTimer.start();
		}
	}
	
	public function addtoTimeLine(stim:Stimulus) {
		__allStim.push(stim);
		if (stim.start != -1) {
			__startTimeSorted.push(stim);
			__endTimeSorted.push(stim);
		}				
	}

	public function killID(id:String) {
		stopStimulusID(id);
		
		for (i in 0...__startTimeSorted.length) {
			if (__startTimeSorted[i].id == id) {
				__startTimeSorted.splice(i,1);	
				break;
			}
		}
		
		for (i in 0...__endTimeSorted.length) {
			if (__endTimeSorted[i].id == id) {
				__endTimeSorted.splice(i,1);
				break;
			}
		}
		
		for (i in 0...__allStim.length) {
			if (__allStim[i].id == id) {
				__allStim.splice(i,1);
				break;
			}
		}
	}
	
	public function stopStimulus(stim:Stimulus) {
		if (stim != null) {
			__objsOnScreen.remove(stim);
			__endTimeSorted.remove(stim);
			if (RootManager.instance.currentRoot.contains(stim.component)) {
				RootManager.instance.currentRoot.removeChild(stim.component);
			}
			
		}
	}
	
	public function stopStimulusID(id:String):Bool {
		for (i in 0...__objsOnScreen.length) {
			if (__objsOnScreen[i].id == id) {
				stopStimulus(__objsOnScreen[i]);
			}
		}	
		return false;
	}
	
	
	public function addStimulusOnScreen(id:String, delay:String = "", dur:String = ""):Stimulus {
		if (Floats.canParse(dur) == false) throw "the duration you asked for is not a number";
		var duration:Float = Floats.parse(dur);
		
		var stim:Stimulus = getStimulusID(id);
		
		if (stim == null) throw "could not find the stimuli you asked to run";
		
			
		stim.stop+=__mainTimer.now;
		
		stim.stop=duration+ __mainTimer.now;
		
		stim.start+=__mainTimer.now;	
		
		if (delay != "") {
			if (Floats.canParse(delay) == false) throw "the delay you asked for is not a number";
			stim.start+=Std.parseFloat(delay);
		}
		else {
			__addToScreen(stim);
		}
		
		__endTimeSorted.push(stim);
		__startTimeSorted.push(stim);	
		sortTime();

		return stim;
	}
	
	public function __addToScreen(stim:Stimulus) {
		//stim.stimEvent(StimulusEvent.DO_BEFORE);

		depthManager(stim);
		__startTimeSorted.remove(stim);
		
		//stim.stimEvent(StimulusEvent.DO_AFTER_APPEARED);
	}
	
	private function depthManager(stim:Stimulus=null) {
		if (stim != null) {
			__objsOnScreen.push(stim);
		}

		__sortOn("depth", __objsOnScreen);

		for (i in 0...__objsOnScreen.length) {
			if (__objsOnScreen[i] != null) {
				RootManager.instance.currentRoot.addChild(__objsOnScreen[i].component);
			}
		}
	}		
	
	public static inline function __sortOn(what:String, arr:Array<Stimulus>):Array<Stimulus> {
		arr.sort( function(a:Stimulus, b:Stimulus):Int {
			return Reflect.compare(Reflect.getProperty(a, what), Reflect.getProperty(b, what));
		});	
		return arr;
	}
	
	private function removeStimulus(stim:Stimulus) {
		if(RootManager.instance.currentRoot.contains(stim.component)){
			RootManager.instance.currentRoot.removeChild(stim.component);
		}
	}
	
	public function stopAll()
	{
		for(stim in __allStim){
			stopStimulus( stim );
		}
	}
	
	public function getStimulusID(id:String):Stimulus{
		for(stim in __allStim){
				if(stim.id==id){
					return stim;
				}
			}
		return null;
	}
}