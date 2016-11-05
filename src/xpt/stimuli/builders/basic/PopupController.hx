package xpt.stimuli.builders.basic;

import flash.events.Event;
import flash.text.TextField;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.KeyboardEvent;
import thx.Strings;
import xpt.experiment.Experiment;
import flash.events.TimerEvent;
import flash.utils.Timer;
import xpt.tools.SaveFile;
import xpt.tools.XTools;
import xpt.preloader.Preloader;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/popup-window.xml"))
class PopupController extends XMLController {
	private var ICONS:Map<String, String> = [
		"ERROR" => "img/icons/exclamation-red.png",
		"SUCCESS" => "img/icons/success.png"
	];
	
	var attempts:Int = 10;
	
	public function new(params:Map<String,Dynamic>) {	
		//info.text = params.get('text');
		//if(info.text=='') 
		//cant use as breaks in html
		//if (params.exists('fontSize')) info.style.fontSize = params.get('fontSize');
		
	}
	
	public function resize(width:Float, height:Float ) {
			popup.width = width;
			popup.height = height;	
			//info.percentWidth = 100;
	}
	
	public function setResource(image_resource:String) {
		ImageHelper.handleImageLoading(image, null, image_resource, 1, function(image_resource:String) {
			attempts --;
			if (attempts > 0) {
				setResource(image_resource);
				return;
			}
			
			Preloader.instance.callbackWhenLoaded(image_resource, function() {
					setResource(image_resource);
				}
			);	
		}, function(){
			image.x = popup.width * .5 - image.width * .5;
			image.y = popup.height * .5 - image.height * .5;
		});	
	}
	

	
	
	public function center() {
		var cx:Float = RootManager.instance.currentRoot.width;
		var cy:Float = RootManager.instance.currentRoot.height;
		
		popup.x = (cx - popup.width)*.5;
		popup.y = (cy - popup.height)*.5;
		
		popup.style.alpha = .85;
		popup.onMouseOver = function(e) {
			popup.style.alpha = 1;
		}
		popup.onMouseOut = function(e) {
			popup.style.alpha = .85;
		}
	}
	
	
}