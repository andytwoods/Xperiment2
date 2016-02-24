package xpt.stimuli.builders.basic;

import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import thx.Floats;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XRandom;
import xpt.ui.custom.LineScale;

class StimLineScale extends StimulusBuilder {
	
	var lineScale:LineScale;
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
        lineScale = new LineScale();
        lineScale.addEventListener(UIEvent.CHANGE, function(e) {
           onStimValueChanged(lineScale.val); 
        });
		return lineScale;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var lineScale:LineScale = cast c;
		
		sortLabels(lineScale, get("labels"), get("labelPositions"));
		sortStartPosition(lineScale, get('startPosition'));
		
	}
	
	function sortStartPosition(lineScale:LineScale, startPosition:String) 
	{
		
		switch(startPosition.toLowerCase()) {
			case 'random':
				lineScale.position_percent(XRandom.random());
			case 'hidden':
				if(lineScale.hasEventListener(MouseEvent.MOUSE_OVER)==false) lineScale.addEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
				lineScale.selectionVisible(false);
		}
	}
	
	private function mouseOverL(e:MouseEvent):Void 
	{
		lineScale.pos_from_stageX(e.stageX);
		lineScale.removeEventListener(e.type, mouseOverL);
		lineScale.selectionVisible(true);		
				
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