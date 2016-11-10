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
		lineScale.triangleSize(getInt('size'));
		lineScale.triangleMoveCallBack = triangleMoveCallBack;
  
		return lineScale;
	}
	
	private function triangleMoveCallBack(val:Float) {
		onStimValueChanged(Floats.roundTo(val, 2)); 
		var e:UIEvent = new UIEvent(UIEvent.CHANGE);
		lineScale.dispatchEvent(e);
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	
		lineScale = cast c;			
		
		var lhs:String = get('lhs', '');
		var rhs:String = get('rhs', '');
		
		if (lhs.length > 0 && rhs.length > 0) {
			stim.set('labels', [lhs, rhs].join(","));
			
		}
		
		lineScale._line.style.borderColor = getColor('sliderColour', 0x000000);
		
		sortLabels(lineScale, get("labels",""), get("labelPositions",""));
		sortStartPosition(lineScale, get('startPosition'));
		
		
	}
	
	function sortStartPosition(lineScale:LineScale, startPosition:String) 
	{
		var startPos:String = startPosition.toLowerCase();
		
		switch(startPos) {
			case 'random':
				lineScale.position_percent(XRandom.random());
			case 'hidden':
				if(lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER)==false) lineScale.sprite.addEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
				lineScale.change_visible(false);
			default:
				var pos:Float = Std.parseFloat(startPos.split("%").join(""));
				lineScale.position_percent(pos/100);
		}

	}
	
	@:access(xpt.ui.custom.LineScale)
	private function mouseOverL(e:MouseEvent):Void 
	{
		lineScale.change_visible(true);
		lineScale.pos_from_localX(e.localX);
		stim.value = lineScale.val;
		lineScale.dispatchEvent(new UIEvent(UIEvent.CHANGE));
		if(lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER)==true)lineScale.sprite.removeEventListener(e.type, mouseOverL);		
		onStimValueChanged(Floats.roundTo(stim.value, 2)); 
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
    
	override public function results():Map<String,String> {
		var map:Map<String,String> = new Map<String,String>();
		if(stim.value==null)map.set(stim.id, '');
		else map.set(stim.id, stim.value);
		return map;
	}
	
	 override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
		if (lineScale.sprite.hasEventListener(MouseEvent.MOUSE_OVER) == true) lineScale.sprite.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
    }
	
	override public function kill() {
		lineScale.kill();
		super.kill();
	}

}