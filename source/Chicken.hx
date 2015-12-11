package;

import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;

class Chicken extends FlxSprite {

	public function create():Void {
		makeGraphic(64, 64, 0x00000000);
		drawEllipse(0,0,64,64,0xff00ffff);
		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}

	public override function update():Void {
		super.update();
	}

	public override function draw():Void {
		super.draw();
	}
}
