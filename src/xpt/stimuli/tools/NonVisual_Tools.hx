package xpt.stimuli.tools;
import thx.Arrays;

import xpt.stimuli.builders.nonvisual.StimDrag;
import xpt.trial.Trial;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;

/**
 * ...
 * @author Andy Woods
 */
class NonVisual_Tools
{
	static public function getStims(trial:Trial, stim:StimulusBuilder):Array<Stimulus>
	{
		var stims:Array<Stimulus> = [];
        
        if (stim.get("stims") != null) {
            var stimIds:Array<String> = stim.getStringArray("stims");
            if (stimIds != null) {
                for (stimId in stimIds) {
                    var found_stim:Stimulus = trial.findStimulus(stimId);
                    if (found_stim != null && stims.indexOf(found_stim) == -1) {
						
						
                        stims.push(found_stim);
                    }
                }
            }
        }
        
		for(groupLabel in ['group', 'groups']){
			if (stim.get(groupLabel) != null) {
				var groupIds:Array<String> = stim.getStringArray(groupLabel);
				if (groupIds != null) {
					for (groupId in groupIds) {
						var groupStims:Array<Stimulus> = Stimulus.getGroup(groupId);
						if (groupStims != null) {
							
							stims = stims.concat(groupStims);
						}
					}
				}
			}
		}
		
		for (found_stim in stims) {	
				if (Std.is(found_stim.builder, StimulusBuilder_nonvisual)) {
					stims.remove(found_stim);	
				}	
		}

		 
        return Arrays.distinct(stims);
	}
	
	

	
}