package xpt.ui.custom;

import flash.display.Sprite;
import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import Thx.ArrayInts;
import xpt.tools.XTools;

class DrawBox extends Box {
	private var labels1:Array<Text>;
	private var lineWidth:Int;
	private var lineColour:Int;
	public var offsetX:Float = 30;
	public var line:PointLine;
	public var lines:Array<PointLine>;

	
	public function new(width:Int = -1, col:Int =-1) {
		
		if (width == -1) lineWidth = _baseStyle.borderSize;
		else lineWidth = width;
		if (col == -1) lineColour =  _baseStyle.borderColor;
		
		line = new PointLine();
		lines = new Array<PointLine>();
		lines.push(line);
		
		super();
	}
	
	public override function paint():Void {

		_sprite.graphics.clear();
		_sprite.graphics.beginFill(0x000000, 0.1);

		_sprite.graphics.drawRect(0, 0, _width, _height);
		_sprite.graphics.lineStyle(lineWidth, lineColour, 1);	
		
		var next:Point;
		var point:Point;
		var currentLine:PointLine;		
		
		for(line in lines){		
			if (line.length() > 1) {
				point = line.first();
				
				for (i in 1...line.length()) {
					next = line.get(i);
					_sprite.graphics.moveTo(point.x, point.y);
					_sprite.graphics.lineTo(next.x, next.y);
					point = next;
				}
			}
		}
	}
	
	public function check_intersects(y_ratio:Float, x_offset):Point {
		var my_y:Float = y_ratio * this.height;
		var line1:Point = new Point(x_offset, my_y);
		var line2:Point = new Point(this.width - x_offset, my_y);
		if (line.length() < 2) return null;
		var current = line.first();
		var next:Point;
		var intersection:Point = null;
		for (i in 1...line.length()) {
			next = line.get(i);
			intersection = XTools.lineIntersectLine(line1, line2, current, next);
			if (intersection != null) break;
			current = next;
		}
		return intersection;
	}
	
	public function check_lines_intersect():Point {
		if (lines.length < 2) {
			return null;
		}
		var width_int = Std.int(width);
		var height_int = Std.int(height);
		
		var first:BitmapData = lines[lines.length - 2].getBitmapData(width_int, height_int);
		var second:BitmapData = lines[lines.length -1].getBitmapData(width_int, height_int);
		
		if (first == null || second == null) {
			return null;
		}
		
		//http://stackoverflow.com/questions/5272155/iterating-each-pixel-of-a-bitmap-image-in-actionscript
		//stores the width and height of the image

		
		var xs:Array<Int> = [];
		var ys:Array<Int> = [];
		var _x:Int, _y:Int, first_col:Int, second_col:Int;
		
		var border:Int = 3;
		
		for (_x in border...width_int - 1 - border) {
			for(_y in border...height_int-1 - border){
				
				first_col = first.getPixel( _x, _y );
				second_col = second.getPixel( _x, _y ) ;
				
				if (first_col == second_col && first_col == 0xffffff) {
					xs.push(_x);
					ys.push(_y);
				}
			}
		}
		
		if (xs.length == 0) {
			return null;
		}

		var av:Point = new Point(ArrayInts.average(xs), ArrayInts.average(ys));
	
		//_sprite.graphics.moveTo(av.x, av.y);
		//_sprite.graphics.drawCircle(av.x, av.y, 5);
		//moveOver(100, 0);
		return av;
	}
	
	

	public function moveOver(by_x:Float, by_y:Float) {
		for (line in lines) {
			line.moveOver(by_x, by_y);
		}
		paint();
	}
	
	public function reset(point:Point = null) {
		line.reset();
		if(point!=null) line.push(point);
	}
	
	public function nextLine(point:Point) {
		line = new PointLine();
		if (point != null) line.push(point);
		lines.push(line);
	}
	
	public function keep(remainingLines:Int) {
		while (lines.length >= remainingLines) {
			lines.shift().kill();
		}
	}
	
	public function addPoint(point:Point) {
		if (line.length() == 0) {
			line.push(point);
			return;
		}
		if (line.last().equals(point) == false) {
			line.push(point);
			paint();
		}
	}
	
	public function kill() {
		keep(0);
		lines = null;
	}


}

class PointLine {
	
	public var line:Array<Point> = new Array<Point>();
	
	var bitmapdata:BitmapData;
		
	public function new() {
	}
	
	public function moveOver(by_x:Float, by_y:Float) {
		
		for (point in line) {
			point.x += by_x;
			point.y += by_y;
		}
	}
	
	public function getBitmapData(width:Int, height:Int) {
		if (line.length < 2) return null;
		if (bitmapdata != null) return bitmapdata;
		bitmapdata = new BitmapData(width, height, false, 0x000000);
	
		var spr:Sprite = new Sprite();
		spr.graphics.beginFill(0x000000,1);
		spr.graphics.drawRect(0, 0, width, height);
		spr.graphics.lineStyle(3, 0xffffff);
		
		var next:Point;
		var point:Point;
		point = line[0];
		for (i in 1...line.length) {
			next = line[i];
			spr.graphics.moveTo(point.x, point.y);
			spr.graphics.lineTo(next.x, next.y);
			point = next;
		}
		
		bitmapdata.draw(spr);	
		return bitmapdata;
	}
	
	
	
	public function reset() {
		line = new Array<Point>();
	}
	
	public function first() {
		return line[0];
	}
	
	public function last() {
		return line[line.length - 1];
	}
	
	public function get(i:Int):Point {
		return line[i];
	}
	
	public function length():Int {
		return line.length;
	}
	
	public function push(point:Point) {
		line.push(point);
	}
	
	public function kill() {
		line = null;
	}
	
}