package xpt.stimuli.builders.basic;
import flash.events.Event;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.PopupManager.PopupButton;
import haxe.ui.toolkit.core.RootManager;
import xpt.experiment.Experiment;
import xpt.tools.PathTools;
import xpt.tools.XTools;
import xpt.stimuli.builders.basic.PopupController;

/**
 * ...
 * @author Andy Woods
 */
class StimPopup extends StimulusBuilder_nonvisual
{

		
	private var popupWindow:Popup;
	private var controller:PopupController;
	private var text:Text;
	private var instantiated = false;
	
	public function new() 
	{
		super();
	}
	
	
	private override function createComponentInstance():Component {		
		return new Component();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);

	}
	
	override public function onAddedToTrial() {
		super.onAddedToTrial();
		if (instantiated == false) {
			instantiated = true;
			
			controller = new PopupController(stim.__properties);
			RootManager.instance.currentRoot.addEventListener(Event.ADDED, _onAddedToStage);

			
			var config = {
				buttons: PopupButton.CLOSE,
				modal: true,
				fontSize: get('fontSize',null) //NB BROKEN IN HTML
			};
			

			popupWindow = PopupManager.instance.showCustom(controller.view, get("title"), config, function(e) {	
				runScriptEvent("action", new Event(Event.CLOSE));
				removePopup();
				controller = null;
					});
			
			if (getBool('forceSize', false)) controller.resize(stim.component.width, stim.component.height);
			
			if (exists('resource')) {
				var resource = get('resource');
				if(resource.indexOf('http')==-1) resource = PathTools.fixPath(resource);
				controller.setResource(resource);
			}
			
			controller.center();
		}
	}
	
	
	//override public function onRemovedFromTrial() {
	//	super.onRemovedFromTrial();
    //}

	
	@:access(haxe.ui.toolkit.core.Root)
	public function removePopup() {
		stim.end();
		var overlay:Component = popupWindow.root._modalOverlay;
		PopupManager.instance.hidePopup(popupWindow);
		popupWindow.dispose();
		popupWindow = null;	
		overlay.root.removeChild(overlay, true);

	}
	
	
	private function _onAddedToStage(event:Event) {
		RootManager.instance.currentRoot.addChild(popupWindow);
	}
	
	public function show(experiment:Experiment) {
		this.experiment = experiment;
		//nothing needed here as we have a getter for instance that generates an instance and adds it to screen if it is not there already.
	}
	
	
}