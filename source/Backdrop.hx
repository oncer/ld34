package;

import flixel.*;
import flixel.util.*;
import flixel.group.*;

import openfl.Assets;

class Backdrop extends FlxGroup
{
	public static inline var HORIZON:Float = 1731/2048;
	public var zoom:Float;
	private var img:Array<FlxSprite>;
	private var drawIdx:Int;

	private static var images:Array<String> = [
		"assets/images/backdrop02.png",
		"assets/images/backdrop03.png",
		"assets/images/backdrop04.png",
		"assets/images/backdrop05.png",
		"assets/images/backdrop06.png",
		"assets/images/backdrop07.png",
		"assets/images/backdrop08.png",
		"assets/images/backdrop09.png",
		"assets/images/backdrop10.png",
		"assets/images/backdrop11.png",
		"assets/images/backdrop12.png",
		"assets/images/backdrop13.png",
		"assets/images/backdrop14.png",
		"assets/images/backdrop15.png",
		"assets/images/backdrop16.png",
		"assets/images/backdrop17.png",
		"assets/images/backdrop18.png",
		"assets/images/backdrop01.png"
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
		img = new Array<FlxSprite>();
		var path:String;
		var i:Int = images.length - 1;
		while (i >= 0) {
			var spr:FlxSprite = new FlxSprite();
			imgload(spr, i);
			img.push(spr);
			add(spr);
			i--;
		}
		zoom = 1;
		drawIdx = 0;
	}

	// zoom factor: 2048/2048 ... 480/2048

	public override function update():Void
	{
		var spr:FlxSprite;
		var zf:Int = 1<<(img.length - 1);
		if (zoom < 480/(2048*(1<<img.length - 1))) {
			zoom += 480/1024;
		}
		for (spr in img) {
			spr.scale.x = spr.scale.y = zoom * zf;
			zf >>= 1;
		}
		drawIdx = 0;
		zf = 1<<(img.length -1);
		var i:Int = 0;
		for (i in 0...img.length) {
			if (zoom > 480/(2048*zf)) {
				drawIdx = i;
			}
			zf >>= 1;
		}
		//zoom*=0.99;//DEBUG!
	}

	public override function draw():Void
	{
		img[drawIdx].draw();
	}
}
