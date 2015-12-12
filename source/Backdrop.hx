package;

import flixel.*;
import flixel.util.*;
import flixel.group.*;

import openfl.Assets;

class Backdrop extends FlxGroup
{
	public static inline var HORIZON:Float = 1726/2048;
	private var zoom:Float;
	private var img0:FlxSprite;

	private static var images:Array<String> = [
		"assets/images/background1.png",
		"assets/images/background2.png"
	];

	public static function imgload(spr:FlxSprite, id:Int):Void
	{
		spr.loadGraphic(images[id]);
		spr.origin.x = spr.width * 0.5;
		spr.origin.y = spr.height * HORIZON;
		spr.offset.x = spr.width * 0.5;
		spr.offset.y = spr.height * HORIZON;
		spr.x = 480 * 0.5;
		spr.y = 480 * HORIZON;
	}

	public function init():Void
	{
		img0 = new FlxSprite(0, 0);
		add(img0);
		
		imgload(img0, 0);
		zoom = 1;
	} 

	public override function update():Void
	{
		img0.scale.x = img0.scale.y = zoom;
		zoom *= 0.99;
		if (zoom < 480/2048) {
			zoom += 480/1024 - 480/2048;
			
			imgload(img0, 1);
		}
		trace(zoom);
	}
}