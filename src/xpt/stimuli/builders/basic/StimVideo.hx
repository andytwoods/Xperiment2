package xpt.stimuli.builders.basic;

import flash.display.BitmapData;
import flash.geom.Matrix;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import openfl.utils.ByteArray;
import thx.Maps;
import thx.Objects;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import xpt.preloader.Preloader;
import xpt.tools.XTools;


class StimVideo extends StimulusBuilder {
	
	#if html5
		var my_player:Dynamic;
	#end
	
	var added:Bool = false;
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Image();
	}
	
	
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
       var resource:String = get("resource");
	   
	   if (resource != null) {
		   if(resource.indexOf('http')==-1) resource = PathTools.fixPath(resource);
			html_video(resource);
		}
		
		super.onAddedToTrial();
    }
	
	public override function onRemovedFromTrial() {
		#if html5
			untyped my_player.dispose();
			my_player = null;
		#end
		super.onRemovedFromTrial();
	}
	
	function html_video(url:String) {

		#if html5
			function callback(_player, _video_element) {
				my_player = _player;
				untyped _video_element.style.zIndex = 1000;
				untyped my_player.on("ended", function() { my_player.hide(); _video_element.style.zIndex = 0; _video_element.style.visibility = 'hidden'; } );
			}
			
			untyped x_utils.html_video(url, callback);

		#end	
	}

	
	
}