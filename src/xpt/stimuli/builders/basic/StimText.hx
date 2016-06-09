package xpt.stimuli.builders.basic;

import flash.display.Sprite;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XTools;

class StimText extends StimulusBuilder {
	
	#if html5	
		private var pixel:Sprite;
	#end
	var text:Text;
		
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Text();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		text = cast c;
		text.text = get("text");
		var bg = getColor('background', -1);
		if(bg!=-1){
			text.style.backgroundColor = bg;			
		} 
		
		text.wrapLines = true;
		text.multiline = true;
		if (get("textAlign") != null) {
			text.textAlign = get("textAlign");
		}
	}
	
	
		public override function onAddedToTrial() {
			#if html5
				if (text.sprite.stage != null) {
					XTools.delay(50, function(){
						if (text.sprite.stage.contains(pixel)) text.sprite.stage.removeChild(pixel);
						pixel = new Sprite();
						pixel.graphics.drawRect(0, 0, 1, 1);
						text.sprite.addChild(pixel);
					});
				}
			#end
		super.onAddedToTrial();
    }
    

}