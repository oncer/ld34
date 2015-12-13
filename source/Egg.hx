package;

import flixel.*;
using flixel.util.FlxSpriteUtil;

class Egg extends flixel.FlxSprite
{
	public var zoom:Float;

	public var size(get, set):Float;
	public function get_size():Float {
		return scale.x;
	}
	public function set_size(Value:Float):Float {
		scale.x = scale.y = Value;
		return Value;
	}

	public function create():Void {
		loadGraphic("assets/images/egg01.png");
		origin.x = width / 2;
		origin.y = height - 2;
		offset = origin;

		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}
}