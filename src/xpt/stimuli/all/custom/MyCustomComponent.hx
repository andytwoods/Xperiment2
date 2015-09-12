package xpt.stimuli.all.custom;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.XMLController;

class MyCustomComponent extends Box {
	private var controller:MyCustomComponentController;
	
	public var resultString(default, default):String;
	
	public function new() {
		super();
		resultString = "Done!";
		controller = new MyCustomComponentController(this);
		addChild(controller.view);
	}
	
	public override function applyStyle() {
		super.applyStyle();
		
		if (_baseStyle != null && controller != null) {
			if (_baseStyle.fontSize != 0) {
				controller.theButton.style.fontSize = _baseStyle.fontSize;
				controller.theText.style.fontSize = _baseStyle.fontSize;
			}
		}
	}
}

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/custom/my-custom-component.xml"))
class MyCustomComponentController extends XMLController {
	private var _component:MyCustomComponent;
	public function new(component:MyCustomComponent) {
		_component = component;
		
		theButton.onClick = function(e) {
			theText.text = _component.resultString;
		}
	}
}