package;

import flixel.*;
using flixel.util.FlxSpriteUtil;
import flixel.group.*;
import flixel.util.*;

class Egg extends flixel.FlxSprite
{
	public static inline var SIZE_LAY = 0.33;
	public static inline var SIZE_HATCH = 0.75;
	private var pulseTimer:FlxTimer;
	private var pulseStrength:Float;
	private var goalSize:Float;

	public var size(get, set):Float;
	public function get_size():Float {
		return scale.x;
	}
	public function set_size(Value:Float):Float {
		scale.x = scale.y = Value;
		return Value;
	}

	public function create():Void {
		loadGraphic("assets/images/egg01.png", true, 96, 96);
		animation.add("types", [0, 1, 2], 0, false);
		origin.set(width/2, height);
		offset.set(origin.x, origin.y);
		pulseTimer = new FlxTimer();
		pulseTimer.cancel();
		pulseStrength = 0;
	}
	
	public function vibrate(x:Float, y:Float, strength:Float):Void {
		this.x = Std.int(x + strength * FlxRandom.float());
		this.y = Std.int(y + strength * FlxRandom.float());
	}
	
	public function pulse(strength:Float) {
		pulseTimer.start(0.125);
		pulseStrength = strength;
	}
	
	public override function update():Void {
		if (!pulseTimer.finished) {
			var s = pulseTimer.progress;
			if (s < 0.1)
				s = 1 + 0.5 * s / 0.08;
			else
				s = 1.5 - 0.5 * (s - 0.08) / (1 - 0.08);
			scale.x = (1 + (s - 1) * pulseStrength) * SIZE_HATCH;
			scale.y = scale.x;
		}
	}
}