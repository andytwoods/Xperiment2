package xpt.stimuli.builders.nonvisual;

import flash.events.Event;
import haxe.ui.toolkit.core.Component;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import thx.Arrays;
import thx.Ints;
import xpt.debug.DebugManager;
import xpt.stimuli.StimuliFactory;
import xpt.stimuli.Stimulus;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.tools.XRandom;

class StimSmartGroup extends StimulusBuilder_nonvisual {
    
	public var all_group:Group;
	public var groups:Groups = new Groups();
	public var stims:Array<Stimulus>;
	
    public function new() {
        super();
    }
    
    public override function onAddedToTrial() {

		stims = NonVisual_Tools.getStims(trial, this);
		
		if (getBool('random', false)) {
			XRandom.shuffle(stims);
		}
		
		if (stims.length == 0) throw 'err';
		
		var groupSizesArr = getStringArray('groupSizes', []);	
		if (groupSizesArr.length == 0) {
			var sizStr = Std.string(stims.length);
			groupSizesArr.push(sizStr);	
		}
		var groupNamesArr = getStringArray('groupNames', []);
		if (groupNamesArr.length == 0) {
			var random_nam;
			for(i in 0...groupSizesArr.length){
				random_nam = 'group_' + XRandom.string(10);
				groupNamesArr.push(random_nam);
			}
		}


		if (groupSizesArr.length != groupNamesArr.length) throw ['err',Std.string(groupSizesArr.length), Std.string(groupNamesArr.length)];
		
		var group:Group;
		var nam:String;
		var size:Int;
		var stim_i:Int = 0;
		for (i in 0...groupNamesArr.length) {
			if (Ints.canParse(groupSizesArr[i]) == false) {
				throw 'err, prob parsing as number: '+groupSizesArr[i];
			}
			
			nam = groupNamesArr[i];
			size = Ints.parse(groupSizesArr[i]);
			group = new Group();
			group.name = nam;
			group.counter = i;
			
			while (size > 0) {
				group.stims.push(stims[stim_i]);
				size--;
				stim_i++;
			}

			this.stim.__properties.set(nam, group);
			groups.add(group);	
		}

		if (exists('mixture')) sortMixture(get('mixture').split(" ").join(""));
		
		linkup_funcs();
		super.onAddedToTrial();
		

    }
	
	private function sortMixture(mix:String) {
		var arr:Array<String> = mix.split("=");
		if (arr.length != 2) throw 'must be 2';
		var mix_name = arr.shift();
		
		var from_groups:Map<String,Int> = new Map<String,Int>();
		var namCount:Array<String>;
		
		for (txt in arr.shift().split("+")) {
			namCount = txt.split("*");
			if (namCount.length != 2) throw 'must be 2';
		
			if (groups.groups.exists(namCount[1]) == false) throw 'unknwon group asked to be in a mixture: '+namCount[1];
			if (Ints.canParse(namCount[0]) == false) throw 'must be a whole number:' + namCount[0];
			from_groups.set(namCount[1], Ints.parse(namCount[0]));
		}
		

		var group:Group = new Group();
		group.name = mix_name;
		var rand_stims:Array<Stimulus>;
		for (groupNam in from_groups.keys()) {
			rand_stims = groups.groups.get(groupNam).random(from_groups[groupNam]);
			group.addStims(rand_stims);
		}
		
		groups.add(group);
		this.stim.__properties.set(mix_name, group);
		
		
		
	}
	
	private function linkup_funcs() {
		this.stim.__properties.set('next', give_next);
		this.stim.__properties.set('current', groups.current);
		this.stim.__properties.set('all', give_all);
		
	}
	
	//nb cant be 'next' as parent.parent has same function and cant return group
	public function give_next():Group {
		return groups.next();
	}
	
	
	
	public function give_all():Group {
		
		if (all_group == null) {
			all_group = new Group();
			all_group.name = 'all';
			all_group.counter = 0;
			all_group.stims = stims;
		}
		return all_group;
	}
	
	override public function kill() {
		stims = null;
		groups.kill();
		groups = null;
		if (all_group != null) { 
			all_group.kill();
			all_group = null;
		}
		super.kill();
	}

	
	   override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
		kill();
    }
}

class Groups {
	public var groups:Map<String, Group> = new Map<String, Group>();
	public var groupsList:Array<Group> = new Array<Group>();
	public var next_group_i:Int = 0;

	public function new() { }

	public function add(group:Group) {
		groups.set(group.name, group);
		groupsList.push(group);
	}
	
	public function kill() {
		groups = null;
		for (group in groupsList) {
			group.kill();
		}
		groupsList = null;
	}
	
	public function current() {
		return groupsList[next_group_i - 1];
	}
	
	public function next() {
		next_group_i ++;
		return groupsList[next_group_i - 1];
	}

	
}

class Group {
	public var name:String;
	public var counter:Int;
	public var next_i:Int = 0;
	public var stims:Array<Stimulus> = new Array<Stimulus>();
	
	public function new() { }

	public function next():Stimulus {
		next_i++;
		return stims[next_i-1];
	}

	public function f(name:String, params:Dynamic = null) {

		var _viaGet:Bool = true;
		
		if (stims.length == 0) return;
		if (stims[0].get(name, null) == null) _viaGet = false;
		
		for (stim in stims) {
			if (_viaGet) stim.get(name)(params);
			else f_via_stimulus_f(name, stim, params);
		}
	}
	
	public function random(howMany:Int):Array<Stimulus> {
		var my_rand:Array<Stimulus> = new Array<Stimulus>();
		for (stim in stims) {
			my_rand.push(stim);
		}
		XRandom.shuffle(my_rand);

		while (my_rand.length > howMany) {
			my_rand.pop();
		}
		return my_rand;
	}
	
	public function addStims(arr:Array<Stimulus>) {
		for (stim in arr) {
			stims.push(stim);
		}
	}
	
	public function current():Stimulus {
		if (next_i == 0) return null;
		return stims[next_i-1];
	}
	
	public function shuffle() {
		XRandom.shuffle(stims);
	}

	
	inline function f_via_stimulus_f(name:String, stim:Stimulus, params:Dynamic) {
		if(params==null)Reflect.callMethod(stim, Reflect.field(stim, name), []);
		else Reflect.callMethod(stim, Reflect.field(stim, name), [params]);
	}
	
	public function isValid():Bool {
		var valid = true;
		for (stim in stims) {
			
			if (stim.isValid == false) return false;
		}
		return true;
	}
	
	public function disable(yes:Bool) {
		for (stim in stims) {
			if (yes) {
			
				if (stim.exists('disabled')) stim.get('disabled')();
			}
			else {
				if (stim.exists('enabled')) stim.get('enabled')();
			}
		}
	}

	public function kill() {
		stims = null;
	}
	
	
}