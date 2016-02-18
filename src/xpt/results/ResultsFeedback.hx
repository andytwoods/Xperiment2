package xpt.results;
import flash.events.Event;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.PopupManager.PopupButton;
import haxe.ui.toolkit.core.RootManager;
import xpt.experiment.Experiment;
import xpt.tools.XTools;




class ResultsFeedback
{

	
	public function success(success:Bool, data:String) 
	{
		if (success == true) {
			controller.success(ExptWideSpecs.IS("saveSuccessMessage"));
			XTools.delay(3000, removePopup);
			return;
		}

		controller.fail(ExptWideSpecs.IS("saveFailMessage"), data);
		
	}
	
	private var feedbackWindow:Popup;
	private var controller:ResultsFeedbackController;
	private var text:Text;
	private var experiment:Experiment;
	
	
	public function removePopup() {
		PopupManager.instance.hidePopup(feedbackWindow);
		feedbackWindow.dispose();
		feedbackWindow = null;	
	}
	
	public function new(experiment:Experiment) 
	{

		this.experiment = experiment;
		
		controller = new ResultsFeedbackController(function() {
			removePopup();
			experiment.saveDataEndStudy();
		});
		RootManager.instance.currentRoot.addEventListener(Event.ADDED, _onAddedToStage);

		var config = {
			buttons: PopupButton.CLOSE,
			modal: true,
		};

		
		feedbackWindow = PopupManager.instance.showCustom(controller.view, "Saving your results", config, function(e) {	
			controller = null;
				});
		
		controller.center();
	}
	

	
	private function _onAddedToStage(event:Event) {
		RootManager.instance.currentRoot.addChild(feedbackWindow);
	}
	
	public function show(experiment:Experiment) {
		this.experiment = experiment;
		//nothing needed here as we have a getter for instance that generates an instance and adds it to screen if it is not there already.
	}
	
	
}

