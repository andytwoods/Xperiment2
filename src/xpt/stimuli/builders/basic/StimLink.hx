package xpt.stimuli.builders.basic;
import haxe.ui.toolkit.controls.Link;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import xpt.stimuli.StimulusBuilder;

class StimLink extends StimulusBuilder {
    
	private var linkUrl:Text;
	private var link:Link;
	
	public function new() {
        super();
    }
    
    private override function createComponentInstance():Component {
        return new Link();
    }
    
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
        link = cast c;
		
		
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
		
		
/*
		if (linkUrl == null) {
			linkUrl = new Text();
		link.addChild(linkUrl);
		linkUrl.autoSize = true;
		linkUrl.text = link.url;
		linkUrl.selectable = true;
		linkUrl.style.textAlign = 'center';
		linkUrl.visible = false;
		
		link.addEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
		link.addEventListener(MouseEvent.MOUSE_OUT, mouseOutL);	
		}
		*/
	
    }
	
	/*private function mouseOutL(e:MouseEvent):Void 
	{
		if(linkUrl!=null)	linkUrl.visible = false;
	}
	
	private function mouseOverL(e:MouseEvent):Void 
	{
		
		if (linkUrl != null) {
			linkUrl.y = 100;		
			linkUrl.visible = true;
		}
	
	}
	
	
	override public function onAddedToTrial() {
		super.onAddedToTrial();
		 
    }
    
    override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
		if(linkUrl!=null){
			link.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverL);
			link.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutL);
			linkUrl.parent.removeChild(linkUrl);
			linkUrl = null;
		}
    }*/
}