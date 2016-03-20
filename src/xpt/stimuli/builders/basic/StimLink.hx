package xpt.stimuli.builders.basic;
import haxe.ui.toolkit.controls.Link;
import haxe.ui.toolkit.core.Component;
import openfl.display.Sprite;
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
		
		#if html5 
			var s:Sprite = new Sprite();
			s.useHandCursor = true;
			s.buttonMode =  true;
			
			s.graphics.beginFill(0xffffff, 0);
			s.graphics.drawRect(0, 0, link.width, link.height);
			link.sprite.addChildAt(s, 0);		
		#end
		

        if (get("url") != null) {
            link.url = get("url");
        }
		
    }
}