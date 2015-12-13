package;

import flixel.*;
import flixel.util.*;
using flixel.util.FlxSpriteUtil;

class Chicken extends FlxSprite {

	private var rocketfire:FlxSprite;

	public var zoom:Float;

	public function create():Void {
		loadGraphic("assets/images/chicken01.png", true, 64, 64);
		animation.add("idle", [0,1], 7, true);
		animation.add("prepare", [2], 0, false);
		animation.add("poop", [3], 0, false);
		animation.add("wiggle", [4, 5], 10, true);
		animation.play("idle");
		offset = new FlxPoint(32, 59);
		origin = offset;
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		facing = FlxObject.RIGHT;

		rocketfire = new FlxSprite();
		rocketfire.offset.x = 16;
		rocketfire.origin.x = 16;
		rocketfire.loadGraphic("assets/images/rocketfire.png", true, 32, 48);
		rocketfire.animation.add("fire", [0,1,2,3], 7, true);
		rocketfire.animation.play("fire");
		rocketfire.kill();

		zoom = 1;
	}

	public function rocket():Void
	{
		rocketfire.x = x;
		rocketfire.y = y;
		rocketfire.revive();
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
		rocketfire.x = x;
		rocketfire.y = y;
		rocketfire.update();
	}

	public override function draw():Void {
		if (rocketfire.exists) rocketfire.draw();
		super.draw();
	}
}
