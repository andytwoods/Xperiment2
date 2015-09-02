package xpt.timing;
import xpt.stimuli.Stimulus;

/**
 * ...
 * @author 
 */
class TimingBoss
{

/*	public static var BOTTOM:Int=int.MAX_VALUE;
	public static var TOP:Int=int.MIN_VALUE;
	static var MAX_CHILDREN:Int=int.MAX_VALUE;
	public static inline var FOREVER:Float=int.MAX_VALUE;
	
	public var _startTimeSorted:Array<Stimulus>;
	public var _endTimeSorted:Array<Stimulus>;
	public var _mainTimer:TickTimer;
	public var __objsOnScreen:Array<Stimulus>;
	
	private var stageCount:Int;
	public var running:Bool=true;
	//private var depthRecyc:Int;
	private var _allStim:Array<Stimulus>;
	
	private var _currentCount:Int=-1;
	
	private var chromeBug:Bool=true;
	
	private var hack:String=Std.int(Math.random()*1000).toString();*/
	
/*	public function params(params:Dynamic)
	{

	}*/
	
	public function new(){
/*		_mainTimer = getimer(1);
		_mainTimer.callBack = checkForEvent;
		_startTimeSorted=[];
		_endTimeSorted=[];
		__objsOnScreen=[];
		_allStim=[];
		running=true;*/
		
		//			/trace("set up");
	}
	
/*	public function getMS():Int{
		
		return _mainTimer.now();
	}
	
	public inline function getTimer(interval:Int):TickTimer{
		return TickTimer.init(interval);
	}
	
	
	public var allStim(get_allStim, null):Array;
 	private function get_allStim():Array
	{
		return _allStim;
	}
	
	public function cleanUpScreen() {
		
		running=false;
		_mainTimer.stop();
		
		
		for(i in 0...__objsOnScreen.length){
			remove(__objsOnScreen[i]);
			__objsOnScreen[i]=null;
		}
		
		
		_startTimeSorted = null;
		_endTimeSorted = null;
		_allStim = null;
		
		
		
		stragglers();
	}
	
	private function stragglers()
	{
		if(this.stage){
			if(stageCount<this.stage.numChildren){
				for(i in 0...this.stage.numChildren){
					trace("child:",this.stage.getChildAt(i));
				}
				//throw new Dynamic();
				trace("ZZZZZZZZZZZZZZZZZZZZZZZZ");
				trace("ZZZZZZZZZZZZZZZZZZZZZZZZ");
				trace("ZZZZZZZZZZZZZZZZZZZZZZZZ");
				trace("devel error:more elements on screen after end of trial than before start");
			}
		}
	}
	
	

	
	//this function needs testing.
	public function add(stim:Stimulus){

		if(_startTimeSorted.indexOf(stim)!=-1)	_startTimeSorted.push(stim);
		if(_endTimeSorted.indexOf(stim)!=-1)	_endTimeSorted.push(stim);
		if(_allStim.indexOf(stim)!=-1)			_allStim.push(stim);
	} 
	
	public function sortSpritesTIME(){
		if(_startTimeSorted)	sortSprites(_startTimeSorted,"startTime");
		if(_endTimeSorted)		sortSprites(_endTimeSorted,"endTime");	
	}
	
	

	public function checkForEvent(time:Int) {
		
		if(running){
			
			if(_mainTimer.now==_currentCount){
				return;
			}
			_currentCount=_mainTimer.currentMS;

			if(running  && _startTimeSorted.length!=0 && _startTimeSorted[0].start<=_currentCount){
				
				do {
					__addToScreen(_startTimeSorted[0] );
				}
				while(running && _startTimeSorted.length !=0 && _startTimeSorted[0].startTime<=_currentCount);		
			}
			

			if(running && _endTimeSorted.length!=0 && _endTimeSorted[0].endTime<=_currentCount){
				
				do {
					stopObj(_endTimeSorted[0]);
				}
				while(running && _endTimeSorted.length !=0 && _endTimeSorted[0].endTime<=_currentCount);
			}
		}
	}
	
	
	public function commenceDisplay(autoStart:Bool) {

		if(this.stage)stageCount=this.stage.numChildren;
		sortSpritesTIME();
		
		if(autoStart)_mainTimer.start();
		
	}
	

	public function addtoTimeLine(stim:Stimulus) {
		
		_allStim.push(stim);
		
		if(stim.startTime!=-1){
			_startTimeSorted.push(stim);
			_endTimeSorted.push(stim);
		}				
	}
	
	
	public function sortSprites(uSprites:Array,attribute:String) {
		uSprites.sortOn(attribute,Array.NUMERIC);
	}
	
	
	
	public function killPeg(peg:String) {
		stopPeg(peg);
		
		for(i in 0..._startTimeSorted.length){
			if(_startTimeSorted[i].peg==peg){
				_startTimeSorted.splice(i,1);	
				break;
			}
		}
		
		
		for(i in 0..._endTimeSorted.length){
			if(_endTimeSorted[i].peg==peg){
				_endTimeSorted.splice(i,1);
				break;
			}
		}
		
		for(i in 0..._allStim.length){
			if(_allStim[i].peg==peg){
				_allStim.splice(i,1);
				break;
			}
		}
		
	}
	
	
	public function stopObj(stim:Stimulus):Bool {
		
		var index:Int;
		var stopped:Bool=false;
		
		if(stim && this.contains(stim)){
			
			__removeFromScreen(stim);
			if(running){
				index=_endTimeSorted.indexOf(stim);		
				if(index!=-1){
					_endTimeSorted.splice(index,1);
				}
				
				index=_startTimeSorted.indexOf(stim);	
				if(index!=-1)_startTimeSorted.splice(index,1);
				
			}
			
			stopped=true;
		}
		
		//else if(logger)logger.log("you asked to remove a screen element("+peg+")that is not on screen");
		
		
		if(stopped)sortSpritesTIME();
		
		return stopped;//only used by killObj function above
	}
	
	public function stopPeg(peg:String):Bool
	{
		for(i in 0...__objsOnScreen.length){
			if(__objsOnScreen[i].peg==peg){
				return stopObj(__objsOnScreen[i]);
			}
		}	
		return false;
	}
	
	
	public function runDrivenEvent(peg:String,delay:String="",dur:String=""):Stimulus {
		var stim:Stimulus;
		for(i in 0..._allStim.length){
			if(_allStim[i].peg==peg){
				stim=_allStim[i];
				break;
			}
		}
		
		if(stim!=null && __objsOnScreen.indexOf(stim)==-1){
			
			stim.endTime+=_mainTimer.currentMS;
			
			if(dur!="" && !isNaN(Number(dur)))stim.endTime=Std.parseFloat(dur)+ _mainTimer.currentMS;
			
			stim.startTime+=_mainTimer.currentMS;	
			
			if(delay!="" && !isNaN(Number(delay)))stim.startTime+=Std.parseFloat(delay);
			
			_endTimeSorted.push(stim);
			_startTimeSorted.push(stim);
			
			sortSpritesTIME();
			
			if(delay==""){
				__addToScreen(stim);		
			}
		}
		return stim;
	}
	
	public function __removeFromScreen(stim:Stimulus){
		
		stim.stimEvent(StimulusEvent.ON_FINISH);
		if(running){
			removeFromOnScreenList(stim);
		}
		remove(stim);
	}
	
	private function removeFromOnScreenList(stim:Stimulus)
	{
		
		var index:Int=__objsOnScreen.indexOf(stim);
		if(index!=-1)__objsOnScreen.splice(index,1);
	}		
	
	
	public function __addToScreen(stim:Stimulus){
		
		stim.stimEvent(StimulusEvent.DO_BEFORE);

		depthManager(stim);
		
		if(running){
			var index:Int=_startTimeSorted.indexOf(stim);
			if(index!=-1)_startTimeSorted.splice(index,1);
		}

		stim.ran=true;
		if(doEvents)	stim.stimEvent(StimulusEvent.DO_AFTER_APPEARED);
	}
	
	private function depthManager(stim:Stimulus=null)
	{
		
		if(stim)__objsOnScreen.push(stim);
		

		__objsOnScreen.sortOn("depth", Array.DESCENDING | Array.NUMERIC);


		for(i in 0...__objsOnScreen.length){

			if(__objsOnScreen[i])	this.addChild(__objsOnScreen[i] as uberSprite);
		}

		
	}		
	
	private inline function _sortOn(what:String, arr:Array<Stimulus>):Array {
		arrayOfStrings.sort( function(a:Stimulus, b:Stimulus):Int
		{
			if (a[what] < b[what]) return -1;
			if (a[what] > b[what]) return 1;
			return 0;
		} );	
	}
	
	

	private function remove(stim:Stimulus){
		if(this.contains(stim)){
			this.removeChild(stim);
		}
	}
	
	
	public function time():Int
	{
		return _mainTimer.currentMS;
	}
	
	
	public function stopAll()
	{
		for(stim in allStim){
			stopObj( stim );
		}
	}
	
	private function getObjFromPeg(peg:String):Stimulus{
		for(stim in allStim){
				if(stim.peg==peg){
					return allStim[i];
				}
			}
		return null;
	}
	

	public function updateStimTimesFromObj(changed:Dynamic):Stimulus
	{
		//trace("-");
		var stim:uberSprite=getObjFromPeg(changed.peg);
		//trace("---");
		if(stim &&(
			stim.startTime 	!=	changed.start ||
			stim.endTime 	!=	changed.end
		)){
			
			stim.startTime 	=	changed.start;
			stim.endTime 	=	changed.end;
			
			setTimes(stim,stim.startTime,stim.endTime,-1);
			return stim;
			
		}
		return stim;
	}
	
	*/
	
	

	
}