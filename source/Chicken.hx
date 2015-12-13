package;

import flixel.*;
import flixel.util.*;
using flixel.util.FlxSpriteUtil;

class Chicken extends FlxSprite {

	private var rocketfire:FlxSprite;
	private var explosion:FlxSprite;

	private var _zoom:Float = 1;
	public var zoom(get,set):Float;
	public function set_zoom(Value:Float):Float
	{
		var scaleOriginY:Float = 480 * Backdrop.HORIZON;
		y = scaleOriginY + (y - scaleOriginY) * Value/_zoom;
		_zoom = Value;
		scale.set(Value, Value);
		rocketfire.scale.set(scale.x, scale.y);
		return Value;
	}

	public function get_zoom():Float {
		return _zoom;
	}

	public function create():Void {
		loadGraphic("assets/images/chicksheet.png", true, 64, 64);
		createIndividual(0);
		animation.play("idle");
		offset = new FlxPoint(32, height);
		origin = offset;
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		facing = FlxObject.RIGHT;

		rocketfire = new FlxSprite();
		rocketfire.loadGraphic("assets/images/rocketfire.png", true, 32, 48);
		rocketfire.animation.add("fire", [0,1,2,3], 7, true);
		rocketfire.animation.play("fire");
		rocketfire.offset.set(16, 0);
		rocketfire.origin.set(16, 0);
		rocketfire.kill();

		explosion = new FlxSprite();
		explosion.loadGraphic("assets/images/explosion.png", true, 64, 64);
		explosion.animation.add("explode", [0,1,2,3,4,5,7,8], 15, false);
		explosion.offset.set(32, 16);
		explosion.origin.set(32, 16);
		explosion.kill();

		zoom = 1;
	}
	
	public function createIndividual(type:Int = -1) {
		if (type < 0)
			type = FlxRandom.intRanged(0, 21);
		animation.destroyAnimations();
		var offset = 6 * type;
		animation.add("idle", [0+offset,1+offset], 7, true);
		animation.add("prepare", [2+offset], 0, false);
		animation.add("poop", [3+offset], 0, false);
		animation.add("wiggle", [4+offset, 5+offset], 10, true);
	}

	public function rocket():Void
	{
		explosion.x = x;
		explosion.y = y;
		explosion.revive();
		explosion.animation.play("explode");
		rocketfire.x = x;
		rocketfire.y = y;
		rocketfire.revive();
	}

	public function rocketOff():Void
	{
		explosion.kill();
		rocketfire.kill();
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
		explosion.update();
		if (explosion.animation.finished) explosion.kill();
	}

	public override function draw():Void {
		if (rocketfire.exists) rocketfire.draw();
		super.draw();
		if (explosion.exists) explosion.draw();
	}
}
