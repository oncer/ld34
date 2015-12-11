package;

import flixel.*;
using flixel.util.FlxSpriteUtil;

class Egg extends flixel.FlxSprite {

	private var temperature:Float; // -1 . 0 . 1
	private var tchange:Float; // temperature change
	private var size:Float; // start with 1

	private var asliufagder:FlxSprite;

	public function create():Void {
		size = 1;
		temperature = 0;
		tchange = 0;
		makeGraphic(32, 48, 0x00000000);
		drawEllipse(0,0,32,48,0xffffffff);

		asliufagder = new FlxSprite(240, 400);
		asliufagder.makeGraphic(20, 20, 0xffffff00);


		FlxG.watch.add(this, "temperature");
		FlxG.watch.add(this, "tchange");		
		FlxG.watch.add(this, "size");
		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}

	public override function update():Void {
		super.update();
		tchange = Math.max(-0.01, tchange - 0.001);
		temperature = Math.min(1, Math.max(-1, temperature + tchange));

		if (FlxG.keys.justPressed.SPACE) {
			breed();
		}

		adjustSize();
		asliufagder.x = temperature * 240 + 240 - 10;
	}

	public override function draw():Void {
		super.draw();
		asliufagder.draw();
	}

	private function adjustSize():Void {
		var f:Float = 0;
		if (temperature > 0) {
			f = 1 - temperature;
		} else {
			f = 1 + temperature;
		}
		size += f * 0.0025;
		scale.x = scale.y = size;
	}

	public function breed():Void {
		tchange += 0.04;
	}
}