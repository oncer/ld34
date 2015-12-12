package;

import flixel.*;
using flixel.util.FlxSpriteUtil;

class Egg extends flixel.FlxSprite
{
	public var size(get, set):Float;
	public function get_size():Float {
		return scale.x;
	}
	public function set_size(Value:Float):Float {
		scale.x = scale.y = Value;
		return Value;
	}

	public function create():Void {
		makeGraphic(32, 48, 0x00000000);
		drawEllipse(0,0,32,48,0xffffffff);

		//animation.add("idle", [0, 1, 2, 3], 10, true);
	}
}