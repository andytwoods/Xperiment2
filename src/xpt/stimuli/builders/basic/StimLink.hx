package xpt.stimuli.builders.basic;
import haxe.ui.toolkit.controls.Link;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimLink extends StimulusBuilder {
    public function new() {
        super();
    }
    
    private override function createComponentInstance():Component {
        return new Link();
    }
    
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
        
        var link:Link = cast c;
        if (get("url") != null) {
            link.url = get("url");
        }
    }
}