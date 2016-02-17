package xpt.results;
import flash.events.Event;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.PopupManager.PopupButton;
import haxe.ui.toolkit.core.RootManager;
import xpt.tools.XTools;




class ResultsFeedback
{

	private static var _instance:ResultsFeedback;
    public static var instance(get, null):ResultsFeedback;
    private static function get_instance():ResultsFeedback {
        if (_instance == null) {
            _instance = new ResultsFeedback();
        }
        return _instance;
    }
	
	
	public function success(success:Bool, data:String) 
	{
		//saveSuccessMessage
		//saveFailMessage
		trace(success);
		if (success) controller.success(ExptWideSpecs.IS("saveSuccessMessage"));
		else {
			controller.fail(ExptWideSpecs.IS("saveFailMessage"), data);
		}

	}
	
	private var feedbackWindow:Popup;
	private var controller:ResultsFeedbackController;
	private var text:Text;
	public function new() 
	{

		controller = new ResultsFeedbackController();
		RootManager.instance.currentRoot.addEventListener(Event.ADDED, _onAddedToStage);

		var config = {
			buttons: PopupButton.CLOSE,
			modal: true,
		};
		/*feedbackWindow = PopupManager.instance.showSimple("Attempting...", "Saving your results",
			{ buttons: [PopupButton.OK, PopupButton.CANCEL] },
			function(btn:Dynamic) {
				if (Std.is(btn, Int)) {
					switch(btn) {
						case PopupButton.OK: trace("OK");
						case PopupButton.CANCEL: trace("CANCEL");
					}
				}
			} 
		);
		*/
		
		feedbackWindow = PopupManager.instance.showCustom(controller.view, "Saving your results", config, function(e) {
					controller = null;
				});
		
		controller.center();
	}
	

	
	private function _onAddedToStage(event:Event) {
		RootManager.instance.currentRoot.addChild(feedbackWindow);
	}
	
	public function show() {
		//nothing needed here as we have a getter for instance that generates an instance and adds it to screen if it is not there already.
	}
	
	
}

