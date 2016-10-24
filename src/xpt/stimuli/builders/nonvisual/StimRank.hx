package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import openfl.display.Stage;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import thx.Ints;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.nonvisual.StimRank.Rankable;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.tools.XTools;

class StimRank extends StimulusBuilder_nonvisual {
   
	private var manager:Manager;

    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
	}

    public override function onAddedToTrial() { 
        manager = new Manager(informComplete_callback);
		rank_ability();
		super.onAddedToTrial();
    }
	
	function informComplete_callback(completed:Bool) 
	{
		onStimValueChanged(completed);
	}
	
		
	function rank_ability() 
	{
		var stims = NonVisual_Tools.getStims(trial, this);
			
		for (stim in stims) {
			manager.add(stim);
		}    
	}	
	
	override public function results():Map<String,String> {
		return manager.compose_results();
	}
	
	public override function onRemovedFromTrial() {
		if (manager != null) manager.kill();
       super.onRemovedFromTrial();
    }
}

class Manager{
	var rankables:Array<Rankable> = new Array<Rankable>();
	var tf:TextFormat;
	var ranks:Array<Int>;
	var informComplete_callback: Bool -> Void;
	
	public function new(change_callback:Bool->Void) {
		this.informComplete_callback = change_callback;
		tf = new TextFormat();
		tf.size = 25;	
	}
	
	public function kill() {
		for (rankable in rankables) {
			rankable.kill();	
		}
	}
	
	public function add(stim:Stimulus) {
		rankables.push(new Rankable(stim, callback_rankable, tf));
	}
	
	function callback_rankable(clicked_rankable:Rankable):Int {

		if (clicked_rankable == null) {
			informComplete_callback(false);
			return -1;
		}

		ranks = new Array<Int>();
		for (rankable in rankables) {

			if(rankable.rank!=-1)	ranks.push(rankable.rank);
			
		}
		
		if (ranks.length == 0) {
			if (rankables.length == 1) {
				informComplete_callback(true);
			}
			return 1;
		}
		
		XTools.sort(ranks);
		
		//trace(ranks.length, rankables.length, 33);
	
		if (ranks.length + 1 == rankables.length) {
			informComplete_callback(true);
		}

		
		for (i in 0...ranks.length) {
			if (ranks[i] != i+1) return i+1;
		}

		
		if (ranks.length < rankables.length) {
			return ranks.length + 1;
		}

		
		throw 'devel err';
		return 0;

	}
	
	public function compose_results():Map<String,String>
	{
		
		var map:Map<String,String> = new Map<String,String>();
		var key:String;
		var val:String;
		var count:Int = rankables.length;
		for (rankable in rankables) {
			key = rankable.stim.get('resource');
			if (count == 1) val = '100';
			else val = Std.string(100 - ((rankable.rank-1) / (count-1) * 100)); //inverting the score and converting to % such that higher = better
			
			map.set(key, val);
		}
		
		return map;
	}
	
}

class Rankable extends TextField{

	public var stim:Stimulus;
	var callback:Rankable -> Int;
	
	public var rank:Int = -1;
	
	public function new(stim:Stimulus, callback:Rankable-> Int, tf:TextFormat) {	
		super();
		this.stim = stim;
		this.callback = callback;
		stim.component.addEventListener(MouseEvent.CLICK, mouseL);
		this.defaultTextFormat = tf;
		stim.component.sprite.addChild(this);
		sortPos();
		//test();
	}
	
	private function sortPos() {
		this.x = stim.component.width *.5 - 10;
		this.y = stim.component.height + 1;	
	}
	
	
	private function mouseL(e:MouseEvent):Void 
	{
		if (rank != -1) {
			rank = -1;
			this.text = ' ';
			callback(null); // to update validation so it knows 'incomplete'
			sortPos();
			return;
		}
		rank = callback(this);
		this.text = pretty_rank(rank);
		sortPos();
	}
	
	/*
	function test() {
		trace(pretty_rank(1) == '1st');
		trace(pretty_rank(2) == '2nd');
		trace(pretty_rank(3) == '3rd');
		trace(pretty_rank(4) == '4th');
		trace(pretty_rank(5) == '5th');
		trace(pretty_rank(6) == '6th');
		trace(pretty_rank(7) == '7th');
		trace(pretty_rank(8) == '8th');
		trace(pretty_rank(9) == '9th');
		trace(pretty_rank(10) == '10th');
		trace(pretty_rank(11) == '11th');
		trace(pretty_rank(12) == '12th');
		trace(pretty_rank(13) == '13th');
		trace(pretty_rank(14) == '14th');
		trace(pretty_rank(15) == '15th');
		trace(pretty_rank(16) == '16th');
		trace(pretty_rank(17) == '17th');
		trace(pretty_rank(18) == '18th');
		trace(pretty_rank(19) == '19th');
		trace(pretty_rank(20) == '20th');
		trace(pretty_rank(21) == '21st');
		trace(pretty_rank(121) == '121st');
		trace(pretty_rank(101) == '101st');
	}*/
	
	private function pretty_rank(rank:Int):String {
		var str:String = Std.string(rank);
		var suffix:String;
		switch (str.charAt(str.length-1))
		{
			case '1':
				suffix = "st";		 
			case '2':
				suffix = "nd";		 
			case '3':
				suffix = "rd";
			default:
				suffix = "th";
		}
		
		if(rank>10){
			var lastTwoDigits:Int = Std.parseInt(str.substr(str.length - 2, 2));
			if (11 <= lastTwoDigits && lastTwoDigits <= 13)
			{
				suffix = "th";
			}
		}
				
		
		return str+suffix;
	}
	
	public function kill() {
		
		if (stim != null && stim.component != null) {
			stim.component.sprite.removeChild(this);
			stim.component.addEventListener(MouseEvent.CLICK, mouseL);	
		}
	}
	
}