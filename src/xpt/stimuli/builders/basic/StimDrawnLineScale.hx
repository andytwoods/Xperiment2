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
import xpt.ui.custom.DrawnLineScale;
import xpt.ui.custom.LineScale;

class StimDrawnLineScale extends StimulusBuilder {
	
	var lineScale:DrawnLineScale;
	var my_results:Map<String,String> = new Map<String,String>();
	#if html5
		var spr:Sprite;
	#end
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
        lineScale = new DrawnLineScale();
		lineScale.updatedCallback = updatedCallback;
		this.stim.__properties.set('moderate', moderate);
		return lineScale;
	}
	
	private function updatedCallback(val:Float) {
		onStimValueChanged(Floats.roundTo(val, 2)); 
		var e:UIEvent = new UIEvent(UIEvent.CHANGE);
		lineScale.dispatchEvent(e);
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	
		lineScale = cast c;		
		
		lineScale.setType(get('type', 'line'));
		
		var lhs:String = get('lhs', '');
		var rhs:String = get('rhs', '');
		
		if (lhs.length > 0 && rhs.length > 0) {
			stim.set('labels', [lhs, rhs].join(","));
		}
		
		sortLabels(lineScale, get("labels",""), get("labelPositions",""));
	}
	
	public function moderate(percent:Float) {
		var moderatedPercent:Float = XTools.moderate(percent, stim.value, 50);
		var pixelChange:Float = lineScale.scoreableWidth() * moderatedPercent / 100;
		lineScale.bufferZone.moveOver(pixelChange, 0);
		addResult('moderatedTo', Std.string(moderatedPercent + stim.value));
	}
	
	override public function snapshot(nam:String) {
		addResult(nam, stim.value);
	}

	@:access(xpt.ui.custom.DrawnLineScale)
	private function mouseOverL(e:MouseEvent):Void 
	{
		stim.value = lineScale.val;
		lineScale.dispatchEvent(new UIEvent(UIEvent.CHANGE));
		if(lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER)==true)lineScale.sprite.removeEventListener(e.type, mouseOverL);		
		onStimValueChanged(Floats.roundTo(stim.value, 2)); 
	}
		
	function sortLabels(lineScale:DrawnLineScale, labels:String, labelPositions:String) 
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
	
	public function addResult(what:String, val:String) {
		my_results.set(stim.id + '_' + what, val);
	}
	
	public override function results():Map<String,String> {
		return my_results;
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