package xpt.stimuli.builders.basic;

import flash.events.Event;
import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import thx.Floats;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import xpt.ui.custom.LineScale;

class StimLineScale extends StimulusBuilder {
	
	var lineScale:LineScale;
	#if html5
		var spr:Sprite;
	#end
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
        lineScale = new LineScale();
        lineScale.addEventListener(UIEvent.CHANGE, function(e) {
           onStimValueChanged(Floats.roundTo(lineScale.val,2)); 
        });

		return lineScale;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	
		lineScale = cast c;			
		sortLabels(lineScale, get("labels",""), get("labelPositions",""));
		sortStartPosition(lineScale, get('startPosition'));
		
		
	}
	
	function sortStartPosition(lineScale:LineScale, startPosition:String) 
	{
		switch(startPosition.toLowerCase()) {
			case 'random':
				lineScale.position_percent(XRandom.random());
			case 'hidden':
				if(lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER)==false) lineScale.sprite.addEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
				lineScale.change_visible(false);
		}

	}
	
	private function mouseOverL(e:MouseEvent):Void 
	{
		lineScale.change_visible(true);
		lineScale.pos_from_localX(e.localX);
		lineScale.dispatchEvent(new UIEvent(UIEvent.CHANGE));
		if(lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER)==true)lineScale.sprite.removeEventListener(e.type, mouseOverL);		
				
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
	
	public override function onAddedToTrial() {
			#if html5
			if (lineScale.sprite.stage != null) {
				XTools.delay(50, function(){
					if (lineScale.sprite.stage.contains(spr)) lineScale.sprite.stage.removeChild(spr);
					spr = new Sprite();
					spr.graphics.drawRect(0, 0, 1, 1);
					lineScale.sprite.addChild(spr);
				});
			}
			#end
		super.onAddedToTrial();
    }
    
	
	 override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
		if (lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER) == true) lineScale.sprite.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
		lineScale.kill();
    }

}