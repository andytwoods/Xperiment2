package xpt.ui.custom;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;

class Line extends Box {
	private var labels:Array<Text>;
	
	public var offsetX:Int = 30;
	public var offsetY:Int = -5;
	
	public function new() {
		super();
	}
	
	public override function paint():Void {
		_sprite.graphics.clear();

		_sprite.graphics.lineStyle(_baseStyle.borderSize, _baseStyle.borderColor);
		_sprite.graphics.moveTo(offsetX, offsetY);
		_sprite.graphics.lineTo(_width - offsetX, offsetY);
		
		_sprite.graphics.moveTo(offsetX, offsetY - 5);
		_sprite.graphics.lineTo(offsetX, offsetY + 5);
		
		_sprite.graphics.moveTo(_width - offsetX, offsetY - 5);
		_sprite.graphics.lineTo(_width - offsetX, offsetY + 5);
	}
	
	public function sortLabels(labelList:Array<String>, labelPositionsList:Array<Float>) 
	{
		if (labels == null) {
			labels = new Array<Text>();
		}

		
		var label:Text;
		for (i in 0...labelList.length) {
			if (labels.length > i) label = labels[i];
			else {
				label = new Text();
				labels.push(label);
			}
			
			
			label.verticalAlign = "bottom";
			label.textAlign = "center";
			label.text = labelList[i];
			label.x = _width * labelPositionsList[i] - label.width * .5;
			
			addChild(label);

		}
	}
	


}