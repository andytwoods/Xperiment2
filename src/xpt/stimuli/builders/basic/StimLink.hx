package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import openfl.events.MouseEvent;
import openfl.net.URLRequest;
import openfl.Lib;

class StimLink extends StimButton {
    

	public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		listenClick();
	}
	
	override private function onClick(e:MouseEvent) {
        var url:String = get("url");
		Lib.getURL(new URLRequest(url));
	}
	
}
