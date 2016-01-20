package xpt.debug;

import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import openfl.events.Event;
import xpt.experiment.Experiment;

class DebugManager {
	private static var _instance:DebugManager;
	public static var instance(get, never):DebugManager;
	private static function get_instance():DebugManager {
		if (_instance == null) {
			_instance = new DebugManager();
		}
		return _instance;
	}

	////////////////////////////////////////////////////////////////////////
	// INSTANCE
	////////////////////////////////////////////////////////////////////////
	private var _debugWindowController:DebugWindowController;
	private var _debugWindowPopup:Popup;
	
	public function new() {
		
	}
	
	private var _experiment:Experiment;
	public var experiment(never, set):Experiment;
	private function set_experiment(value:Experiment):Experiment {
		_experiment = value;
		if (_debugWindowController != null) {
			_debugWindowController.experiment = _experiment;
		}
		return value;
	}
	
	private var _enabled:Bool = false;
	public var enabled(get, set):Bool;
	private function get_enabled():Bool {
		return _enabled;
	}
	private function set_enabled(value:Bool):Bool {
		_enabled = value;
		if (_enabled == true) {
			if (_debugWindowController == null) {
				_debugWindowController = new DebugWindowController(_experiment);
				RootManager.instance.currentRoot.addEventListener(Event.ADDED, _onAddedToStage);
			}
			
			var config = {
				buttons: PopupButton.CLOSE,
				modal: false,
				styleName: "debugWindow"
			};
			_debugWindowPopup = PopupManager.instance.showCustom(_debugWindowController.view, "Debug", config, function(e) {
				_debugWindowController = null;
			});
			
			var cx:Float = RootManager.instance.currentRoot.width;
			var cy:Float = RootManager.instance.currentRoot.height;
			
			_debugWindowPopup.x = cx - _debugWindowPopup.width;
			_debugWindowPopup.y = 0;
			
			_debugWindowPopup.style.alpha = .15;
			_debugWindowPopup.onMouseOver = function(e) {
				_debugWindowPopup.style.alpha = 1;
			}
			_debugWindowPopup.onMouseOut = function(e) {
				_debugWindowPopup.style.alpha = .15;
			}
		} else {
			
		}
		return value;
	}
	
	private function _onAddedToStage(event:Event) {
		RootManager.instance.currentRoot.addChild(_debugWindowPopup);
	}
	
	public function info(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.info(message, details);
		}
	}
	
	public function error(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.error(message, details);
		}
	}
	
	public function warning(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.warning(message, details);
		}
	}
	
	public function stimulus(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.stimulus(message, details);
		}
	}
	
	public function progress(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.progress(message, details);
		}
	}
	
	public function script(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.script(message, details);
		}
	}
	
	public function event(message:String, details:String = null) {
		if (_debugWindowController != null) {
			_debugWindowController.event(message, details);
		}
	}
}