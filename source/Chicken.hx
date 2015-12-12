package;

import flixel.*;
import flixel.util.*;
using flixel.util.FlxSpriteUtil;

class Chicken extends FlxSprite {

	public function create():Void {
		loadGraphic("assets/images/chicken01.png", true, 64, 64);
		animation.add("idle", [0,1,2,1], 10, true);
		animation.play("idle");
		offset = new FlxPoint(32, 55);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		facing = FlxObject.RIGHT;
		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}

	public override function update():Void {
		super.update();
	}

	public override function draw():Void {
		super.draw();
	}
}
