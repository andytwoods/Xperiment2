package xpt.stimuli.builders.client;

import haxe.ui.toolkit.core.Component;
import openfl.display.Shape;
import thx.Floats;
import thx.Ints;
import xpt.events.ExperimentEvent;
import xpt.experiment.Experiment;
import xpt.stimuli.Stimulus;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.builders.basic.StimDrawnLineScale;
import xpt.timing.TimingManager;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import xpt.ui.custom.DrawBox;
import xpt.ui.custom.DrawBox.PointLine;

class StimLundControllerPI extends StimulusBuilder_nonvisual {
   
	var scalesGroupPI:GroupPI = new GroupPI();
	var pleaseUpdateTxtGroupPI:GroupPI = new GroupPI();
	var pleaseUpdateButtonGroupPI:GroupPI = new GroupPI();
	var popup:GroupPI = new GroupPI();
	var finalQGroupPI:GroupPI = new GroupPI();
	var IVs:GroupPI = new GroupPI();
	var bigQ1:GroupPI = new GroupPI();
	var bigQ2:GroupPI = new GroupPI();
	var openminded:GroupPI = new GroupPI();
	var openminded_txt:Stimulus;
	var afterLineScalesButton:Stimulus;
	var popupSummary:Stimulus;
	var end:Stimulus;
	var debrief:Stimulus;
	var debrief_button:Stimulus;
	var combinedSliders:CombinedSlidersPI;
	var conbinedAdjusters:CombinedAdjustersPI;
	var bigQs:BigQsPI;
	var reappraisals:ReappraisalsPI = new ReappraisalsPI();
	var numbers:GroupPI  = new GroupPI();
	var summaryTxt:SummaryTxtPI = new SummaryTxtPI();
	var linescaleLabels:GroupPI = new GroupPI();
	
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
					}
				case 'shift':
					intitial_linescale_vals = false;
					reappraisals.list = DrawnLineScaleHelperPI.shift(combinedSliders, getInt('modify'), getInt('unmodified'), getFloat('zonePercent'));
					combinedSliders.logManipulations();
					combinedSliders.logScores('afterManipulated');
					combinedSliders.reset_durations();
					combinedSliders.disable();
					reappraisal();
				case 'readjusted':
					reappraisal();
				case 'finished_ReappraisalsPI':
					combinedSliders.logScores('afterAppraisal');
					summaryTxt.count(combinedSliders,getFloat('zonePercent'));
					popupSummary.begin();
				case 'after_popupSummary':
					popupSummary.end();
					combinedSliders.enable();
					combinedSliders.noInput();
					combinedSliders.addGreen(getFloat('zonePercent'));
					finalQGroupPI.begin();
				case 'openminded_start':
					var start:String = 'The US electorate is highly polarized, and the current presidential campaign has seen a lot of negativity between the parties and candidates.\n\nBut judging by your score, you have ';
					var end:String = ' attitude.\n\nPlease try to explain why this is the case?';

					openminded_txt.text(start + openminded_map.get(summaryTxt.modScore()) + end);	
					openminded.begin();
				case 'openminded_end':
					openminded.end();
					combinedSliders.removeGreen();
					finalQGroupPI.end();
					combinedSliders.visible(false);
					linescaleLabels.hide();
					numbers.end();		
					var nextQ = bigQs.next();
					if (nextQ != null) nextQ.begin();
				case 'big_q_answered':
					if (bigQs.current_valid()) {
						bigQs.current().end();
						var next:GroupPI = bigQs.next();
						if (next != null) next.begin();
						else {
							action(null, 'debrief');
						}
					}
				case 'debrief':		

					combinedSliders.visible(true);
					linescaleLabels.show();
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

		var nextSlider:CombinedSliderPI = reappraisals.next();
		var nextAdjuster:CombinedAdjusterPI = conbinedAdjusters.next();
		if (nextSlider != null) {
			nextSlider.enable();
			var new_y:Float = nextSlider.slider.component.y + nextSlider.slider.component.height * .5;
			nextAdjuster.moveY(new_y);
		}
		else {
			action(null, 'finished_ReappraisalsPI');
		}
	}
	
	function checkLineScalesDone() {

		for (my_stim in scalesGroupPI.stims) {
			if (my_stim.isValid == false) return false;
		}
		return true;
	}
	
	private function setup() {
		
		scalesGroupPI.stims = Stimulus.getGroup("groupScales");
		pleaseUpdateTxtGroupPI.stims = Stimulus.getGroup("pleaseUpdateTxtGroup");
		pleaseUpdateButtonGroupPI.stims = Stimulus.getGroup("pleaseUpdateButtonGroup");
		popup.stims = Stimulus.getGroup("popup");
		finalQGroupPI.stims = Stimulus.getGroup("finalQGroup");
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
		linescaleLabels.stims = Stimulus.getGroup(get('linescaleLabels'));
		
		combinedSliders = new CombinedSlidersPI(scalesGroupPI,  IVs);
		conbinedAdjusters = new CombinedAdjustersPI(pleaseUpdateTxtGroupPI, pleaseUpdateButtonGroupPI);

		bigQs = new BigQsPI([bigQ1, bigQ2]);
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

class SummaryTxtPI {
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
	
	public function count(combinedSliders:CombinedSlidersPI, zonePercent:Float) {
		clinton_i = moderate_i = trump_i = 0;
		for (slider in combinedSliders.sliders) {
			switch(slider.zoneScore(zonePercent)) {
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

class BigQsPI {
	var count:Int = -1;	
	var list:Array<GroupPI>;
	
	public function new(arr:Array<GroupPI>) {
		list = XRandom.shuffle(arr);
	}
	
	public function next():GroupPI {
		count++;
		if (count > list.length) return null;
		return list[count];
	}
	
	public function current():GroupPI {
		if (count!=-1 && count < list.length) return list[count];
		else return null;
	} 
	
	public function current_valid():Bool {
		var my_current:GroupPI = current();
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

class ReappraisalsPI {
	public function new() { }
	var count:Int = -1;	
	public var list:Array<CombinedSliderPI>;
	
	public function next():CombinedSliderPI {
		count++;
		if (list == null || count > list.length) return null;
		return list[count];
	}
	
	public function current():CombinedSliderPI {
		if (count!=-1 && count < list.length) return list[count];
		else return null;
	}
	
	
}

class GroupPI {
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
	
	public function show() {
		for (stim in stims) {
			stim.show();
		}		
	}
	
	public function end() {
		for (stim in stims) {
			stim.end();
		}
	}
}

class CombinedAdjustersPI {
	public var adjusters:Array<CombinedAdjusterPI> = new Array<CombinedAdjusterPI>();
	var count:Int = -1;
	
	public function new(pleaseUpdateTxtGroupPI:GroupPI, pleaseUpdateButtonGroupPI:GroupPI){
		if (pleaseUpdateButtonGroupPI.stims.length != pleaseUpdateTxtGroupPI.stims.length) throw 'devel err';
		
		var adjuster:CombinedAdjusterPI;
		for (i in 0...pleaseUpdateButtonGroupPI.stims.length) {
			adjuster = new CombinedAdjusterPI();
			adjuster.button = pleaseUpdateButtonGroupPI.stims[i];
			adjuster.text = pleaseUpdateTxtGroupPI.stims[i];
			adjusters.push(adjuster);
		}	
	}
	
	public function giveResults(data:Map<String,String>) {
		var adjuster:CombinedAdjusterPI;
		for (i in 0...adjusters.length) {
			adjuster = adjusters[i];
			data.set('adjuster_' + Std.string(i+1), Std.string(adjuster.text.component.y));
		}
	}
	
	public function next():CombinedAdjusterPI {
		count++;
		if (count > adjusters.length) return null;
		return adjusters[count];
	}
	
	public function current():CombinedAdjusterPI {
		if (count!=-1 && count < adjusters.length) return adjusters[count];
		else return null;
	}
}

class CombinedAdjusterPI {
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

class CombinedSlidersPI {
	public var sliders:Array<CombinedSliderPI> = new Array<CombinedSliderPI>();
	public var data:Map<String,String> = new Map <String, String>();
	
	
	public function new(scalesGroupPI:GroupPI, IVs:GroupPI){
		
		if (IVs.stims.length!=scalesGroupPI.stims.length) throw 'devel err';	
		
		
		//shuffle vertical position 
		var same_shuffled_pos:String = 'memory_id';
		StimHelper.shuffle(scalesGroupPI.stims, ['y'], same_shuffled_pos);
		StimHelper.shuffle(IVs.stims, ['y'], same_shuffled_pos);

		var combinedSlider:CombinedSliderPI;
		for (i in 0...scalesGroupPI.stims.length) {
			combinedSlider = new CombinedSliderPI(scalesGroupPI.stims[i], IVs.stims[i]);
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
	
	public function getFromSlider(slider:Stimulus):CombinedSliderPI {
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

class CombinedSliderPI {
	public var slider:Stimulus;
	var iv:Stimulus;
	public var movedTo:Null<Float>;
	public var movedFrom:Null<Float>;
	public var moved_despite_being_inside:Bool = false;
	public var dv_id:Int;
	var original_lines:Array<PointLine>;
	
	static var scoreMap:Map<Int, String> = [1 => 'C', 2 => 'T', 3 => 'C', 4 => 'C', 5 => 'T', 6 => 'T', 7 => 'C', 8 => 'C', 9 => 'C', 10 => 'T', 11 => 'T', 12 => 'T'];
	
	public function new(_slider:Stimulus, _iv:Stimulus) {
		slider = _slider;
		iv = _iv;
		var str_id:String = iv.id.split("DVid_").join("");
		if (Ints.canParse(str_id) == false) throw 'devel err';
		dv_id = Ints.parse(str_id);
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
	
	
	public function zoneScore(greenZonePercent:Float):Int {
		
		var sliderStim = cast(slider.builder, StimDrawnLineScale);
		
		var my_score:Float;
		my_score = slider.value;
		
		var minGreenZone:Float = 50 - greenZonePercent * .5;
		var maxGreenZone:Float = 50 + greenZonePercent * .5;
		
		var agreePerson = scoreMap.get(dv_id);
	
		//neutral
		var level:Int = 0;
		//agree
		if (my_score > maxGreenZone) {
			if(agreePerson == 'C') level = -1
			else if (agreePerson == 'T') level = 1;
			else throw '';
		}
		//disagree
		else if (my_score < minGreenZone) {
			if(agreePerson == 'C') level = 1
			else if (agreePerson == 'T') level = -1;
			else throw '';
		}
		
		
		
		return level;
	}
	
	public function getScore():Float {
		var sliderStim = cast(slider.builder, StimDrawnLineScale); 
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
		var sliderStim:StimDrawnLineScale = cast(slider.builder, StimDrawnLineScale);
		var bufferZone:DrawBox = sliderStim.lineScale.bufferZone;
		bufferZone.addGreen(zone, 0x00ff00);
		

		
	}
	
	public function removeGreen() {
		var sliderStim:StimDrawnLineScale = cast(slider.builder, StimDrawnLineScale);
		var bufferZone:DrawBox = sliderStim.lineScale.bufferZone;
		bufferZone.removeGreen();
	}
	
	public function visible(yes:Bool) {
		var stim:Stimulus;
		for (stim in [slider, iv]) {
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
		
	}
}


class DrawnLineScaleHelperPI {
	public function new() {	}
	
	public static function shift(all:CombinedSlidersPI, modified_count:Int, unmodified_count:Int, centre_zone:Float):Array<CombinedSliderPI> {
		var selected:Array<CombinedSliderPI> = new Array<CombinedSliderPI>();
		var combined:CombinedSliderPI;
		
		var all_copy:Array<CombinedSliderPI> = new Array<CombinedSliderPI>();
		for (combined in all.sliders) {
			all_copy.push(combined);
		}
		
		XRandom.shuffle(all_copy);
		
		//categorise sliders according to whether inside or outside

		var outside:Array<CombinedSliderPI> = [];
		var inside:Array<CombinedSliderPI> = [];
		
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