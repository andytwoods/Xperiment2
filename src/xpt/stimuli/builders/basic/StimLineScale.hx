package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import thx.Floats;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.LineScale;

class StimLineScale extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
        var lineScale:LineScale = new LineScale();
        lineScale.addEventListener(UIEvent.CHANGE, function(e) {
           onStimValueChanged(lineScale.val); 
        });
		return lineScale;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var lineScale:LineScale = cast c;
		
		sortLabels(lineScale, get("labels"), get("labelPositions"));
		
		
	}
	
	function sortLabels(lineScale:LineScale, labels:String, labelPositions:String) 
	{
		
		
		if (labels!= null && labels.length == 0) return;
		var labelList:Array<String> = labels.split(",");
		
		var labelPositionsList:Array<Float> = new Array<Float>();
		if (labelPositions!=null && labelPositions.length != 0) {
			var arr:Array<String> = labelPositions.split(",");
			for (str in arr) {
				if (Floats.canParse(str)) labelPositionsList.push(Floats.parse(str));
			}
			if (labelPositionsList.length < labelList.length) throw('you have not specified enough label positions');
			
		}
		else {
		
			var numLabels:Int = labelList.length;
			for (i in 0...labelList.length) {
				labelPositionsList.push( i / (numLabels-1) );
			}
			
		}
		
		lineScale.sortLabels(labelList, labelPositionsList);
		
	}

}