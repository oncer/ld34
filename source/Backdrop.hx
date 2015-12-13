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

	private static var images:Array<String> = [
		"assets/images/backdrop01.png",
		"assets/images/backdrop02.png",
		"assets/images/backdrop03.png"
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
	}

	// zoom factor: 2048/2048 ... 480/2048

	public override function update():Void
	{
		var spr:FlxSprite;
		var zf:Int = 1<<(img.length - 1);
		for (spr in img) {
			spr.scale.x = spr.scale.y = zoom * zf;
			zf >>= 1;
		}
	}
}
