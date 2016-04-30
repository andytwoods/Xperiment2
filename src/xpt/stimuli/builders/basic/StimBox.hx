package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimBox extends StimulusBuilder {
	var box:Box;
	
    public function new() {
        super();
		
    }
    
    private override function createComponentInstance():Component {
        return new Component();
    }
    
	private override function applyProperties(c:Component) {
        super.applyProperties(c);
		
		if (box == null) {
			box = new Box();
			box.percentWidth = 100;
			box.percentHeight = 100;
			box.style.backgroundColor = getColor('color', 0xffffff);
			box.style.borderColor = getInt('borderColor', 0x000000);
			box.style.borderAlpha = getFloat('borderAlpha', 1);
			box.style.backgroundAlpha = getFloat('alpha', 1);
			box.style.borderSize = getInt('borderSize', 0);
			box.style.cornerRadius = getInt('cornerRadius', 0);
			box.verticalAlign = "center";
			c.addChild(box);			
		}
	}
	
}