package xpt.ui.custom;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.core.XMLController;
import openfl.events.MouseEvent;

class NumberStepper extends Box {
	private var _controller:NumberStepperController;
	
	public function new() {
		super();
		_controller = new NumberStepperController(this);
		val = 0;
		addChild(_controller.view);
	}
	
	public override function initialize():Void {
		super.initialize();
	}
	
	public override function applyStyle() {
		super.applyStyle();
	}
	
	// ************************************************************************************************************
	// PROPERTIES
	// ************************************************************************************************************
	private var _min:Int = 0;
	public var min(get, set):Int;
	private function get_min():Int {
		return _min;
	}
	private function set_min(v:Int):Int {
		_min = v;
		return v;
	}
	
	private var _max:Int = 9;
	public var max(get, set):Int;
	private function get_max():Int {
		return _max;
	}
	private function set_max(v:Int):Int {
		_max = v;
		return v;
	}
	
	public var val(get, set):Int;
	private function get_val():Int {
		return Std.parseInt(_controller.value.text);
	}
	private function set_val(v:Int):Int {
		if (v < _min) {
			v = _min;
		}
		if (v > _max) {
			v = _max;
		}
		_controller.value.text = "" + v;
		return v;
	}
	
}

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/custom/number-stepper.xml"))
class NumberStepperController extends XMLController {
	private var _stepper:NumberStepper;
	public function new(stepper:NumberStepper) {
		_stepper = stepper;
		
		inc.onClick = function(e) {
			stepper.val++;
		}
		
		deinc.onClick = function(e) {
			stepper.val--;
		}
		
		view.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent) {
			if (e.delta < 0) {
				stepper.val--;
			} else if (e.delta > 1) {
				stepper.val++;
			}
		});
	}
}