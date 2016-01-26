package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.selection.ListSelector;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.data.JSONDataSource;
import haxe.ui.toolkit.events.UIEvent;
import xpt.stimuli.StimulusBuilder;


class StimComboBox extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
        var list:ListSelector = new ListSelector();
        list.addEventListener(UIEvent.CHANGE, function(e) {
           onStimValueChanged(list.text); 
        });
		return list;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var list:ListSelector = cast c;
		
		var data:String = get("data");
		if (data != null) {
			var ds:JSONDataSource = new JSONDataSource();
			ds.createFromResource(data);
			list.dataSource = ds;
		} else {
			var labels:String = get("labels");
			var values:String = get("values");
			var icons:String = get("icons");
			
			var labelsArray:Array<String> = labels.split(",");
			var valuesArray:Array<String> = labelsArray;
			if (values != null) {
				valuesArray = values.split(",");
			}
			var iconsArray:Array<String> = null;
			if (icons != null) {
				iconsArray = icons.split(",");
			}
			
			for (n in 0...labelsArray.length) {
				var label:String = labelsArray[n];
				var value:String = valuesArray[n];
				var icon:String = null;
				if (iconsArray != null) {
					icon = iconsArray[n];
				}
				
				var o = {
					text: label,
					value: value,
					icon: icon
				}
				
				list.dataSource.add(o);
			}
		}
		
		
		var fontSize:Int = getInt("fontSize");
		if (fontSize  != -1) {
		}
		
	}
	
}