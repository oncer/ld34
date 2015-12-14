package;

import flixel.*;
import flixel.system.FlxSound;
import flixel.util.*;
import flixel.group.*;

import openfl.Assets;

class Backdrop extends FlxGroup
{
	public static inline var HORIZON:Float = 1731/2048;
	public var zoom:Float;
	private var img:Array<FlxSprite>;
	private var drawIdx:Int;
	private var music1:FlxSound;
	private var music2:FlxSound;
	private var switchTimer:FlxTimer;
	private var musicState:Int;
	private var switching:Bool;

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
		
		music1 = FlxG.sound.play("assets/music/bgm.wav", 1, true);
		music2 = FlxG.sound.play("assets/music/bgm2.wav", 0, true);
		musicState = 1;
		switchTimer = new FlxTimer(1, switchMusic);
		switchTimer.cancel();
		switching = false;
	}
	
	private function switchMusic(t:FlxTimer):Void {
		musicState = 3 - musicState; // 2..1..2
		switching = false;
		if (musicState == 1) {
			music1.volume = 1;
			music2.volume = 0; 
		} else {
			music1.volume = 0;
			music2.volume = 1; 
		}
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
		//zoom *= 0.99;//DEBUG!
		//if (FlxG.keys.pressed.W) trace (zoom);
		if (!switching) {
			if ((zoom < 0.000023) && musicState == 2) {
				switchTimer.reset();
				switching = true;
			}
			else if (zoom < 0.008 && zoom > 0.000023 && musicState == 1) {
				switchTimer.reset();
				switching = true;
			}
		} else {
			var a = switchTimer.progress;
			if (musicState == 2)
				a = 1 - a;
			music1.volume = 1 - a;
			music2.volume = a;
		}
	}

	public override function draw():Void
	{
		img[drawIdx].draw();
	}
}
