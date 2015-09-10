package xpt2.core.entities;

import xpt2.core.stimuli.Button;
import xpt2.core.stimuli.Image;
import xpt2.core.stimuli.Label;

class StimulasFactory {
	public static function createStimulas(type:String):Stimulas {
		switch (type) {
			case "button":
				return new Button();
			case "label":
				return new Label();
			case "image":
				return new Image();
		}
		return null;
	}
}