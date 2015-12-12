package;

import flixel.*;
import flixel.util.*;
using flixel.util.FlxSpriteUtil;

class Chicken extends FlxSprite {

	public function create():Void {
		loadGraphic("assets/images/chicken01.png", true, 64, 64);
		animation.add("idle", [0,1], 7, true);
		animation.add("prepare", [2], 0, false);
		animation.add("poop", [3], 0, false);
		animation.add("wiggle", [4, 5], 15, true);
		animation.play("idle");
		offset = new FlxPoint(32, 55);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		facing = FlxObject.RIGHT;
		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}
	
	public function vibrate(x:Float, y:Float, strength:Float):Void {
		this.x = Std.int(x + strength * FlxRandom.float());
		this.y = Std.int(y + strength * FlxRandom.float());
	}
	
	public function playAnimation(ani:String) {
		animation.play(ani);
	}

	public override function update():Void {
		super.update();
	}

	public override function draw():Void {
		super.draw();
	}
}
