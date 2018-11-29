package xpt.stimuli.builders.client;

import haxe.ui.toolkit.core.Component;
import openfl.display.Shape;
import thx.Floats;
import xpt.events.ExperimentEvent;
import xpt.experiment.Experiment;
import xpt.stimuli.Stimulus;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.builders.basic.StimDrawnLineScale;
import xpt.timing.TimingManager;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import xpt.ui.custom.DrawBox.PointLine;

class StimLundController extends StimulusBuilder_nonvisual {
   
	var scalesGroup:Group = new Group();
	var scaleImage1Group:Group = new Group();
	var scaleImage2Group:Group = new Group(); 
	var pleaseUpdateTxtGroup:Group = new Group();
	var pleaseUpdateButtonGroup:Group = new Group();
	var popup:Group = new Group();
	var finalQGroup:Group = new Group();
	var IVs:Group = new Group();
	var bigQ1:Group = new Group();
	var bigQ2:Group = new Group();
	var openminded:Group = new Group();
	var openminded_txt:Stimulus;
	var afterLineScalesButton:Stimulus;
	var popupSummary:Stimulus;
	var end:Stimulus;
	var debrief:Stimulus;
	var debrief_button:Stimulus;
	var combinedSliders:CombinedSliders;
	var conbinedAdjusters:CombinedAdjusters;
	var bigQs:BigQs;
	var reappraisals:Reappraisals = new Reappraisals();
	var numbers:Group  = new Group();
	var summaryTxt:SummaryTxt = new SummaryTxt();
	
	var somewhat:String = 'a somewhat open minded';
	var open:String = 'an open minded';
	var very:String = 'a very open minded';
	var extremely:String = 'an extremely open minded';
	var openminded_map:Map<Int,String>;
	
	
	var my_results:Map<String,String> = new Map<String,String>();
	
    public function new() {
        super();
		openminded_map  = [1=>somewhat, 2=>somewhat, 3=>somewhat, 4=>open, 5=>open, 6=>open, 7=>very, 8=>very, 9=>very, 10=>extremely, 11=>extremely, 12=>extremely];
    }
	
	private function trialEndL(e:ExperimentEvent):Void 
	{
		experiment.removeEventListener(ExperimentEvent.TRIAL_END, trialEndL);
	}
    
	private override function applyProperties(c:Component) {
        c.visible = false;  
	}
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
		experiment.addEventListener(ExperimentEvent.TRIAL_END, trialEndL);
		this.stim.__properties.set('action', action);
		setup();
					//my_results.set('openminded', trial.getStim('openminded_input').value);
					//my_results.set('howCompare', trial.getStim('howCompare').value);
					//my_results.set('howImportant', trial.getStim('howImportant').value);
		super.onAddedToTrial();
    }

	public var intitial_linescale_vals:Bool = true;
	
	public function action(stim:Stimulus, info:String = null) {

		if (info == null) {		
			throw 'devel err';
		}
		else {	
			switch(info) {
				case 'linescale_change':
					if (intitial_linescale_vals && checkLineScalesDone()) {
						combinedSliders.hardcopy_lines();
						combinedSliders.logPos();
						combinedSliders.logScores('initial');
						afterLineScalesButton.begin();					
						//summaryTxt.count(combinedSliders,getFloat('zonePercent')); //remove ASAP
					}
				case 'shift':
					intitial_linescale_vals = false;
					reappraisals.list = DrawnLineScaleHelper.shift(combinedSliders, getInt('modify'), getInt('unmodified'), getFloat('zonePercent'));
					combinedSliders.logManipulations();
					combinedSliders.logScores('afterManipulated');
					combinedSliders.reset_durations();
					combinedSliders.disable();
					reappraisal();
				case 'readjusted':
					reappraisal();
				case 'finished_reappraisals':
					combinedSliders.logScores('afterAppraisal');
					summaryTxt.count(combinedSliders,getFloat('zonePercent'));
					popupSummary.begin();
				case 'after_popupSummary':
					popupSummary.end();
					combinedSliders.enable();
					combinedSliders.noInput();
					combinedSliders.addGreen(getFloat('zonePercent'));
					finalQGroup.begin();
				case 'openminded_start':
					var start:String = 'The US electorate is highly polarized, and the current presidential campaign has seen a lot of negativity between the parties and candidates.\n\nBut judging by your score, you have ';
					var end:String = ' attitude.\n\nPlease try to explain why this is the case?';

					openminded_txt.text(start + openminded_map.get(summaryTxt.modScore()) + end);	
					openminded.begin();
				case 'openminded_end':
					openminded.end();
					combinedSliders.removeGreen();
					finalQGroup.end();
					combinedSliders.visible(false);
					numbers.end();		
					var nextQ = bigQs.next();
					if (nextQ != null) nextQ.begin();
				case 'big_q_answered':
					if (bigQs.current_valid()) {
						bigQs.current().end();
						var next:Group = bigQs.next();
						if (next != null) next.begin();
						else {
							action(null, 'debrief');
						}
					}
				case 'debrief':		

					combinedSliders.visible(true);
					combinedSliders.recall(XTools.getColour('green'));
					combinedSliders.addModifiedAsDot(XTools.getColour('yellow'));
					debrief.begin();
					debrief_button.begin();
					

				default: throw 'unknown action:' + info;
			}	
		}
	}
	
	function reappraisal() {
		
		var prev = conbinedAdjusters.current();
		if (prev != null) {
			prev.end();
		}
		var prevSlider = reappraisals.current();
		if (prevSlider != null) {
			prevSlider.disable();	
		}

		var nextSlider:CombinedSlider = reappraisals.next();
		var nextAdjuster:CombinedAdjuster = conbinedAdjusters.next();
		if (nextSlider != null) {
			nextSlider.enable();
			var new_y:Float = nextSlider.slider.component.y + nextSlider.slider.component.height * .5;
			nextAdjuster.moveY(new_y);
		}
		else {
			action(null, 'finished_reappraisals');
		}
	}
	
	function checkLineScalesDone() {

		for (my_stim in scalesGroup.stims) {
			if (my_stim.isValid == false) return false;
		}
		return true;
	}
	
	private function setup() {
		
		scalesGroup.stims = Stimulus.getGroup("groupScales");
		scaleImage1Group.stims = Stimulus.getGroup("scaleClintonImageGroup");
		scaleImage2Group.stims = Stimulus.getGroup("scaleTrumpImageGroup");
		pleaseUpdateTxtGroup.stims = Stimulus.getGroup("pleaseUpdateTxtGroup");
		pleaseUpdateButtonGroup.stims = Stimulus.getGroup("pleaseUpdateButtonGroup");
		popup.stims = Stimulus.getGroup("popup");
		finalQGroup.stims = Stimulus.getGroup("finalQGroup");
		IVs.stims = Stimulus.getGroup("IVs");
		afterLineScalesButton = trial.getStim(get('afterLineScalesButton'));
		popupSummary = trial.getStim(get('popupSummary'));
		numbers.stims = Stimulus.getGroup(get('numbers'));
		bigQ1.stims = trial.getStims(getStringArray('bigq1'));
		bigQ2.stims = trial.getStims(getStringArray('bigq2'));
		end = trial.getStim(get('end'));
		debrief = trial.getStim(get('debrief'));
		debrief_button = trial.getStim(get('debrief_button'));
		summaryTxt.setup(trial.getStims(getStringArray('summaryTxt')),getFloat('zonePercent'));
		openminded.stims = Stimulus.getGroup('openminded');
		openminded_txt = trial.getStim(get('openminded_txt'));
		
		combinedSliders = new CombinedSliders(scalesGroup, scaleImage1Group, scaleImage2Group, IVs);
		conbinedAdjusters = new CombinedAdjusters(pleaseUpdateTxtGroup, pleaseUpdateButtonGroup);

		bigQs = new BigQs([bigQ1, bigQ2]);
	}
	

    
    public override function onRemovedFromTrial() {

       super.onRemovedFromTrial();
    }
	
	
	override public function results():Map<String,String> {
		summaryTxt.giveResults(my_results);		
		conbinedAdjusters.giveResults(my_results);

		for (key in combinedSliders.data.keys()) {
			my_results.set(key, combinedSliders.data.get(key));
		}
		return my_results;
	}
}

class SummaryTxt {
	public function new() { }
	
	var trump:Stimulus;
	var moderate:Stimulus;
	var clinton:Stimulus;
	var greenZonePercent:Float;
	var trump_i:Int;
	var clinton_i:Int;
	var moderate_i:Int;
	
	public function modScore():Int {
		return moderate_i;
	}

	public function setup(stims:Array<Stimulus>, _greenZonePercent:Float) {
		var id:String;
		for (stim in stims) {
			id = stim.id;
			if (id.indexOf('trump')!=-1) trump = stim;
			else if(id.indexOf('moderate')!=-1) moderate = stim;
			else if (id.indexOf('clinton')!=-1) clinton = stim;
			else throw 'devel err';
		}
		greenZonePercent = _greenZonePercent;
	}
	
	public function giveResults(my_results:Map<String, String> ) {
		my_results.set('trumpCount', Std.string(trump_i));
		my_results.set('moderateCount', Std.string(moderate_i));
		my_results.set('clintonCount', Std.string(clinton_i));	
	}
	
	public function count(combinedSliders:CombinedSliders, zonePercent:Float) {
		clinton_i = moderate_i = trump_i = 0;
		for (slider in combinedSliders.sliders) {
			switch(slider.score(greenZonePercent)) {
				case -1:
					clinton_i++;
				case 0:
					moderate_i++;
				case 1:
					trump_i++;
				default:
					throw 'devel err';
			}
		}

		trump.text(Std.string(trump_i));
		clinton.text(Std.string(clinton_i));
		moderate.text(Std.string(moderate_i));	
	}
}

class BigQs {
	var count:Int = -1;	
	var list:Array<Group>;
	
	public function new(arr:Array<Group>) {
		list = XRandom.shuffle(arr);
	}
	
	public function next():Group {
		count++;
		if (count > list.length) return null;
		return list[count];
	}
	
	public function current():Group {
		if (count!=-1 && count < list.length) return list[count];
		else return null;
	} 
	
	public function current_valid():Bool {
		var my_current:Group = current();
		if (my_current == null) return false;
		
		var stim:Stimulus;
		
		for (stim in my_current.stims) {
			if (Std.is(stim.builder, StimDrawnLineScale)) {
				return stim.isValid;
			}
		}
		throw 'devel err';
		return false;
	}
}

class Reappraisals {
	public function new() { }
	var count:Int = -1;	
	public var list:Array<CombinedSlider>;
	
	public function next():CombinedSlider {
		count++;
		if (list == null || count > list.length) return null;
		return list[count];
	}
	
	public function current():CombinedSlider {
		if (count!=-1 && count < list.length) return list[count];
		else return null;
	}
	
	
}

class Group {
	public var stims:Array<Stimulus> = new Array<Stimulus>();
	
	public function new() { }
	
	public function begin() {
		if (stims == null) return;
		for (stim in stims) {
			stim.begin();
		}	
	}
	
	public function hide() {
		for (stim in stims) {
			stim.hide();
		}		
	}
	
	public function end() {
		for (stim in stims) {
			stim.end();
		}
	}
}

class CombinedAdjusters {
	public var adjusters:Array<CombinedAdjuster> = new Array<CombinedAdjuster>();
	var count:Int = -1;
	
	public function new(pleaseUpdateTxtGroup:Group, pleaseUpdateButtonGroup:Group){
		if (pleaseUpdateButtonGroup.stims.length != pleaseUpdateTxtGroup.stims.length) throw 'devel err';
		
		var adjuster:CombinedAdjuster;
		for (i in 0...pleaseUpdateButtonGroup.stims.length) {
			adjuster = new CombinedAdjuster();
			adjuster.button = pleaseUpdateButtonGroup.stims[i];
			adjuster.text = pleaseUpdateTxtGroup.stims[i];
			adjusters.push(adjuster);
		}	
	}
	
	public function giveResults(data:Map<String,String>) {
		var adjuster:CombinedAdjuster;
		for (i in 0...adjusters.length) {
			adjuster = adjusters[i];
			data.set('adjuster_' + Std.string(i+1), Std.string(adjuster.text.component.y));
		}
	}
	
	public function next():CombinedAdjuster {
		count++;
		if (count > adjusters.length) return null;
		return adjusters[count];
	}
	
	public function current():CombinedAdjuster {
		if (count!=-1 && count < adjusters.length) return adjusters[count];
		else return null;
	}
}

class CombinedAdjuster {
	public function new(){}
	public var text:Stimulus;
	public var button:Stimulus;
	
		
	public function moveY(moveY:Float) {
		text.moveY(moveY+10);
		button.moveY(moveY);
		text.begin();
		button.begin();
	}
	
	public function end() {
		text.end();
		button.end();
	}
}

class CombinedSliders {
	public var sliders:Array<CombinedSlider> = new Array<CombinedSlider>();
	public var data:Map<String,String> = new Map <String, String>();
	
	
	public function new(scalesGroup:Group, scaleImage1Group:Group, scaleImage2Group:Group, IVs:Group){
		
		if (scalesGroup.stims.length != scaleImage1Group.stims.length || scaleImage1Group.stims.length != scaleImage2Group.stims.length && IVs.stims.length!=scalesGroup.stims.length) throw 'devel err';	
		
		
		//shuffle vertical position 
		var same_shuffled_pos:String = 'memory_id';
		StimHelper.shuffle(scalesGroup.stims, ['y'], same_shuffled_pos);
		StimHelper.shuffle(scaleImage1Group.stims, ['y'], same_shuffled_pos);
		StimHelper.shuffle(scaleImage2Group.stims, ['y'], same_shuffled_pos);
		StimHelper.shuffle(IVs.stims, ['y'], same_shuffled_pos);

		var combinedSlider:CombinedSlider;
		for (i in 0...scalesGroup.stims.length) {
			combinedSlider = new CombinedSlider(scalesGroup.stims[i], scaleImage1Group.stims[i], scaleImage2Group.stims[i], IVs.stims[i]);
			sliders.push(combinedSlider);
		}
	}
	
	public function addGreen(zone:Float) {
		for (slider in sliders) {
			slider.addGreen(zone);
		}
	}
	
	public function removeGreen() {
		for (slider in sliders) {
			slider.removeGreen();
		}
	}
	
	public function logManipulations() {
		for (slider in sliders) {
			slider.logManipulations(data);
		}
	}
	
	public function logPos() {
		for (slider in sliders) {
			data.set(slider.getId()+"_pos", slider.getPos());
		}
	}

	
	public function logScores(id:String) {
		
		var score:Float;
		var slider_id:String;
		
		for (slider in sliders) {
			score = slider.getScore();
			slider_id = slider.getId();

			data.set(id + '_' + slider_id, Std.string(score));

			data.set(id + '_' + slider_id + '_duration', Std.string((cast(slider.slider.builder, StimDrawnLineScale).my_duration()) ));
			data.set(id + '_' + slider_id + '_flipped', Std.string(slider.swapped));
		}		
	}
	
	public function reset_durations() {
		for (slider in sliders) {
			(cast(slider.slider.builder, StimDrawnLineScale)).reset_duration();
		}
	}
	
	public function hardcopy_lines() {
		for (slider in sliders) {
			slider.hardcopy_lines();
		}
	}

	public function fakeScoring() {
		//for (slider in sliders) {
		//	slider.fakeScoring();
		//}	
	}
	
	public function getFromSlider(slider:Stimulus):CombinedSlider {
		for (combined in sliders) {
			if (combined.slider == slider) return combined;
		}
		throw 'devel err';
		return null;
	}
	
	public function disable() {
		for (combined in sliders) {
			combined.disable();
		}
	}
	
	public function enable() {
		for (combined in sliders) {
			combined.enable();
		}
	}
	
	public function noInput() {
		for (combined in sliders) {
			combined.noInput();
		}
	}
	
	public function recall(color:Int) {
		for (combined in sliders) {
			combined.recall(color);
		}
	}
	
	public function addModifiedAsDot(color:Int) {
		for (combined in sliders) {
			combined.addModifiedAsDot(color);
		}
	}
	
	public function visible(yes:Bool) {
		for (combined in sliders) {
			combined.visible(yes);
		}
	}
	
	public function kill() {
		for (slider in sliders) {
			slider.kill();
		}
		sliders = null;
	}
}

class CombinedSlider {
	public var slider:Stimulus;
	var image1:Stimulus;
	var image2:Stimulus;
	var iv:Stimulus;
	public var swapped:Bool = false;
	var greenZone:Shape;
	public var movedTo:Null<Float>;
	public var movedFrom:Null<Float>;
	public var moved_despite_being_inside:Bool = false;
	var original_lines:Array<PointLine>;
	
	public function new(_slider:Stimulus, _image1:Stimulus, _image2:Stimulus, _iv:Stimulus) {
		slider = _slider;
		iv = _iv;
		if (XRandom.random() < .5) {
			image1 = _image1;
			image2 = _image2;
		}
		else {
			swapped = true;
			image1 = _image2;
			image2 = _image1;
			
			var propValue1:String = _image1.get('x');
			var propValue2:String = _image2.get('x');
			
			_image1.set('x', propValue2);
			_image2.set('x', propValue1);
		}
	}
	
	public function getPos():String {
		return Std.string(slider.get('y'));
	}
	
	public function getId():String {
		return slider.id;
	}
	
	public function logManipulations(data:Map<String,String>) {
		
		if (movedFrom == null) {
			data.set(slider.id + "_manipulated", '');
		}
		else {
			data.set(slider.id + "_manipulated", Std.string(movedTo));	
		}
		
		data.set(slider.id + '_manipulated_but_green', Std.string(moved_despite_being_inside));
		
	}
	
	public function score(greenZonePercent:Float):Int {
		
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		
		var my_score:Float;
		my_score = slider.value;
		
		var minGreenZone:Float = 50 - greenZonePercent * .5;
		var maxGreenZone:Float = 50 + greenZonePercent * .5;
	
		var level:Int = 0;
		if (my_score < minGreenZone) level = -1;
		else if (my_score > maxGreenZone) level = 1;
		
		if (swapped == true) {
			level *= -1;
		}
		return level;
	}
	
	public function getScore():Float {
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		if(swapped == true) return 100 - sliderStim.stim.value; 
		return sliderStim.stim.value;
	}
	
	public function disable() {
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		sliderStim.disable();
	}
	
	public function enable() {
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		sliderStim.enable();
	}
	
	public function noInput() {
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		sliderStim.noInput();
	}
	
	public function addGreen(zone:Float) {
		greenZone = new Shape();
		greenZone.graphics.beginFill(0x00ff00, .5);
		greenZone.graphics.drawRect(0, 0, slider.component.width / 100 * zone, slider.component.height);
		greenZone.x = slider.component.width * .5 - (slider.component.width / 100 * zone) * .5;
		slider.component.sprite.addChildAt(greenZone, slider.component.sprite.numChildren);
		
	}
	
	public function removeGreen() {
		if (greenZone == null || slider == null || slider.component.sprite == null || slider.component.sprite.contains(greenZone) == false) return;
		slider.component.sprite.removeChild(greenZone);
	}
	
	public function visible(yes:Bool) {
		var stim:Stimulus;
		for (stim in [slider, image1, image2, iv]) {
			if (yes) stim.show();
			else stim.hide();
		}
	}
	
	public function fakeScoring() {
		throw 'not set up';
		//var sliderStim = cast(slider.builder, StimDrawnLineScale);
		//sliderStim.setVal(XRandom.random() * 100);
	}
	
	public function hardcopy_lines() {
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		original_lines = new Array<PointLine>();
		for (line in sliderStim.lineScale.bufferZone.lines) {
			original_lines.push(line.duplicate());
		}
	}
	
	public function recall(color:Int) {
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		sliderStim.lineScale.bufferZone.drawOtherLines(original_lines, color);
	}
	
	public function addModifiedAsDot(color:Int) {
		if (movedTo == null) return;
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		sliderStim.lineScale.addModifiedAsDot(movedTo, color);
	}
	
	public function kill() {
		if (greenZone != null) {
			if (slider != null && slider.component != null) {
				slider.component.sprite.removeChild(greenZone);
			}
		}
	}
}


class DrawnLineScaleHelper {
	public function new() {	}
	
	public static function shift(all:CombinedSliders, modified_count:Int, unmodified_count:Int, centre_zone:Float):Array<CombinedSlider> {
		var selected:Array<CombinedSlider> = new Array<CombinedSlider>();
		var combined:CombinedSlider;
		
		var all_copy:Array<CombinedSlider> = new Array<CombinedSlider>();
		for (combined in all.sliders) {
			all_copy.push(combined);
		}
		
		XRandom.shuffle(all_copy);
		
		//categorise sliders according to whether inside or outside

		var outside:Array<CombinedSlider> = [];
		var inside:Array<CombinedSlider> = [];
		
		var half_centre_zone_percent:Float= centre_zone *.5;
        var min_zone:Float = 50 - half_centre_zone_percent;
        var max_zone:Float = 50 + half_centre_zone_percent;
		
		var my_slider:StimDrawnLineScale;
		var currentPos:Float;
		
		for (combined in all_copy) {
			my_slider = cast(combined.slider.builder, StimDrawnLineScale);
			currentPos = my_slider.stim.value;
			if(currentPos<min_zone || currentPos > max_zone) {
                outside.push(combined);
            }
            else {
                inside.push(combined);
            }
		}
		
		//lets select X sliders whose values are outside green and move those values inside. Lets move these into selected.
		var new_pos:Float;
		var pixelChange:Float;
		
		for (combined in outside) {
			if (selected.length >= modified_count) break;
			my_slider = cast(combined.slider.builder, StimDrawnLineScale);
			currentPos = my_slider.stim.value;
			if(currentPos<min_zone || currentPos >= 50 ){
                new_pos = Floats.roundTo(min_zone + centre_zone * XRandom.random(),2);
            }

			else throw 'devel err';
			var pixelChange:Float = my_slider.lineScale.scoreableWidth() * (new_pos - currentPos) / 100;
			my_slider.lineScale.bufferZone.my_duration = 0;
			my_slider.stim.value = new_pos;
			combined.movedFrom = currentPos;
			combined.movedTo = new_pos;
			my_slider.lineScale.movePixels(pixelChange);
			selected.push(combined);
		}

		//if there are not enough scales in selected we add some scales that have been deemed 'inside' green zone
		for (combined in inside) {
			if (selected.length >= modified_count) break;
			my_slider = cast(combined.slider.builder, StimDrawnLineScale);
			
			currentPos = my_slider.stim.value;

			if(currentPos <= min_zone || currentPos >= max_zone){
                throw 'devel err';
            }
            if(currentPos<=50 || currentPos >= 50 ){
                new_pos = Floats.roundTo(min_zone + centre_zone * XRandom.random(),2);
            }
			else {
				//new_pos = XRandom.random() * 100;//for devel
				throw 'devel err';
			}
			var pixelChange:Float = my_slider.lineScale.scoreableWidth() * (new_pos - currentPos) / 100;
			my_slider.lineScale.bufferZone.my_duration = 0;
			my_slider.stim.value = new_pos;
			combined.movedFrom = currentPos;
			combined.movedTo = new_pos;
			combined.moved_despite_being_inside = true;
			my_slider.lineScale.movePixels(pixelChange);
			selected.push(combined);
		}
		
		//we need to add Y sliders that have NOT been manipulated into selected
		var combined_count:Int = modified_count + unmodified_count;
		for (combined in all_copy) {
			if (selected.length >= combined_count) break;
			else if(selected.indexOf(combined) == -1)	selected.push(combined);
		}
		
		if (selected.length != combined_count) throw 'devel err';
		
		XRandom.shuffle(selected);
		
		return selected;
	}
}