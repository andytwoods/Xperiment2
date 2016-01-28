package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimBox extends StimulusBuilder {
    public function new() {
        super();
    }
    
    private override function createComponentInstance():Component {
        return new Component();
    }
    
	private override function applyProperties(c:Component) {
        super.applyProperties(c);
	}
}