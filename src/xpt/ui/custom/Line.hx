package xpt.ui.custom;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;

class Line extends Box {
	private var labels1:Array<Text>;
	
	public var offsetX:Float = 30;
	
	public function new() {
		super();
	}
	
	public override function paint():Void {
        var offsetY:Float = this.height - 10;
		_sprite.graphics.clear();

		_sprite.graphics.lineStyle(_baseStyle.borderSize, _baseStyle.borderColor);
		_sprite.graphics.moveTo(offsetX, offsetY);
		_sprite.graphics.lineTo(_width - offsetX, offsetY);
		
		_sprite.graphics.moveTo(offsetX, offsetY - 5);
		_sprite.graphics.lineTo(offsetX, offsetY + 5);
		
		_sprite.graphics.moveTo(_width - offsetX, offsetY - 5);
		_sprite.graphics.lineTo(_width - offsetX, offsetY + 5);
	}
}