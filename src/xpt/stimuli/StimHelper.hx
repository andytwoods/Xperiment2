package xpt.stimuli;
import haxe.Constraints.FlatEnum;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import thx.Arrays;
import thx.Ints;
import xpt.stimuli.Stimulus;
import xpt.tools.XRandom;
import xpt.tools.XTools;


class StimHelper {
    public static function shuffle(list:Array<Stimulus>, fixedProps:Array<String> = null) {
		
        var fixedValues:Map<String, Array<String>> = null;
        if (fixedProps != null) {
            fixedValues = new Map<String, Array<String>>();
            for (propName in fixedProps) {
                var valueList:Array<String> = new Array<String>();
                for (s in list) {
                    var propValue:String = s.get(propName);
                    valueList.push(propValue);
                }
                fixedValues.set(propName, valueList);
                
            }
        }
       
		
        XRandom.shuffle(list);
	
		
        if (fixedValues != null) {
            for (key in fixedValues.keys()) {
                var valueList:Array<String> = fixedValues.get(key);
                var n:Int = 0;
                for (s in list) {
                    s.set(key, valueList[n]);
                    n++;
                    s.updateComponent();
                }
            }
        }
		

    }
    
    public static function shuffleArrangement(list:Array<Stimulus>, fixedProps:Array<String> = null) {
        if (fixedProps == null) {
            fixedProps = [];
        }
        //fixedProps = fixedProps.concat(['x', 'y', 'horizontalAlign', 'verticalAlign', 'marginLeft', 'marginTop', 'marginRight', 'marginBottom']);
        shuffle(list, fixedProps);
    }
	
	static public function arrange(stims:Array<Stimulus>) 
	{
		for (prop in ['x','y']) {
			arrange_prop(prop, stims);
		}
	}
	
	
	
	static private function getDimensions(count:Int, bounding_box:Rectangle):Array<Int> {
	
		if (count == 1) return [1, 1];
		else if (count == 2) {
			if (bounding_box.width > bounding_box.height) return [2, 1];
			else return [1, 2];
		}
		
		var list = new Array<Int>();
		for (i in 0...count+1) {
			list.push(i);
		}

		var fill_tuple_manager = new Fill_tuple_manager();
		for (i in list) {
			for (j in list) {
				if (i * j >= count) {
					fill_tuple_manager.add(i, j);
				}
			}
		}
		var best = fill_tuple_manager.find_closest(bounding_box.width / bounding_box.height, count);
		
		return best;
	}
	
	
	
	static public function arrange_in_box(bounding_box:Rectangle, stims:Array<Stimulus>) 
	{
		
		var dimensions:Array<Int> = getDimensions(stims.length, bounding_box);
		var cols = dimensions[0];
		var rows = dimensions[1];
		
		var col_gap:Float = bounding_box.width / cols;
		var row_gap:Float = bounding_box.height / rows;
		
		var point:Point;
		var positions = new Array<Point>();
		
		
		for (col in 0...cols) {
			for (row in 0...rows) {
				point = new Point(col * col_gap, row * row_gap);
				positions.push(point);
			}
		}
		
		XRandom.shuffle(positions);
		
		var margin:Int = 20;
		
		var stimWidth_minus_colGap;
		var stimHeight_minus_rowGap;

		for (stim in stims) {
			point = positions.shift();
			
			stimWidth_minus_colGap = col_gap - stim.component.width - margin;
			stimHeight_minus_rowGap = row_gap - stim.component.height - margin;
		
		
			if (stimWidth_minus_colGap < 0 || stimHeight_minus_rowGap < 0) {
			
				//establish the max resize factor needed
				var resize_factor:Float;
				if (stimWidth_minus_colGap < stimHeight_minus_rowGap) {
					resize_factor = col_gap / ( stim.component.width + margin);
				}
				else {
					resize_factor = row_gap / (stim.component.height + margin);
				}
				stim.component.width *= resize_factor;
				stim.component.height *= resize_factor;
			}
			
			stim.component.x = bounding_box.x + Std.int(point.x) + (col_gap - stim.component.width) * .5;
			stim.component.y = bounding_box.y + Std.int(point.y) + (row_gap - stim.component.height) * .5;
		}
		
	}
	
	static private function arrange_prop(prop:String, stims:Array<Stimulus>) 
	{
		var propsArr:Array<Int> = new Array<Int>();
		for (stim in stims) {
			propsArr.push(Reflect.getProperty(stim.component, prop));
		}
		var max:Int = ArrayInts.max(propsArr);
		var min:Int = ArrayInts.min(propsArr);
			
		var overall_gap:Int = max - min;
		
		var gap_per_stim:Float = overall_gap / (stims.length -1);
		
		var positions:Array<Int> = new Array<Int>();
		
		for (i in 0...stims.length) {
			positions.push(Std.int(i * gap_per_stim) + min);
		}

		XRandom.shuffle(positions);
		
		for (stim in stims) {
			Reflect.setProperty(stim.component, prop,  positions.shift());
		}
	}
}

class Fill_tuple_manager {
	
	var fill_tuples = new Array<Fill_tuple>();
	
	public function new() {
		
	}
	
	public function add(a:Int, b:Int) {
		fill_tuples.push(new Fill_tuple(a, b));
	}
	
	public function find_closest(width_div_height:Float, count:Int):Array<Int> {
	
		var tuple_ratio:Float;
		for (f in fill_tuples) {
			tuple_ratio = f.a / f.b;
			f.distance = Math.abs(tuple_ratio - width_div_height);
			f.count_distance = Math.abs(f.a * f.b - count);
			f.combined = f.distance * f.count_distance;
		}
		
		fill_tuples.sort(function(a:Fill_tuple, b:Fill_tuple):Int {
			if (a.count_distance < b.count_distance) return -1;
			if (a.count_distance > b.count_distance) return 1;
			return 0;
		});

		var best:Float = fill_tuples[0].count_distance;
		
		fill_tuples = fill_tuples.filter(function(f) { 
			return f.count_distance <= best+4;
		} );
		
		
		fill_tuples.sort(function(a:Fill_tuple, b:Fill_tuple):Int {
			if (a.distance < b.distance) return -1;
			if (a.distance > b.distance) return 1;
			return 0;
		});
	
		return fill_tuples[0].output();
	}
	
	public function dispose() {
		fill_tuples = null;
	}
	
}

class Fill_tuple {
	public var a:Int;
	public var b:Int;
	public var distance:Float;
	public var count_distance:Float;
	public var combined:Float;
	
	public function output():Array<Int> {
		return [a, b];	
	}
	
	public function new(a:Int, b:Int) {
		this.a = a;
		this.b = b;
	}
	
	public function check_mirror(x:Int, y:Int):Bool {
		if (a == x && b == y) return true;
		if (a == y && b == x) return true;
		return false;
	}
	
	
}