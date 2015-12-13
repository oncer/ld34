package;

import flixel.*;
using flixel.util.FlxSpriteUtil;
import flixel.group.*;
import flixel.util.*;

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
		loadGraphic("assets/images/egg01.png", true, 96, 96);
		animation.add("types", [0, 1, 2], 0, false);
		origin.set(width/2, height);
		offset.set(origin.x, origin.y);
	}
	
	public function vibrate(x:Float, y:Float, strength:Float):Void {
		this.x = Std.int(x + strength * FlxRandom.float());
		this.y = Std.int(y + strength * FlxRandom.float());
	}
}