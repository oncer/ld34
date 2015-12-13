package;

import flixel.*;
using flixel.util.FlxSpriteUtil;

class Egg extends flixel.FlxSprite
{
	public static inline var SIZE_LAY = 0.33;
	public static inline var SIZE_HATCH = 0.75;
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

		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}
}