package;

import flixel.*;
import flixel.util.*;
import flixel.group.*;

class Backdrop extends FlxGroup
{
	public static inline var HORIZON:Float = 1726/2048;
	private var zoom:Float;
	private var img:FlxSprite;
	public function init():Void
	{
		img = new FlxSprite(0, 0);
		img.loadGraphic("assets/images/background.png");
		add(img);
		img.origin.x = img.width * 0.5;
		img.origin.y = img.height * HORIZON;
		img.offset.x = img.width * 0.5;
		img.offset.y = img.height * HORIZON;
		img.x = 480 * 0.5;
		img.y = 480 * HORIZON;
		img.offset.x = img.width * 0.5;
		img.offset.y = img.height * HORIZON;

		zoom = 1;
	}

	public override function update():Void
	{
		img.scale.x = img.scale.y = zoom;
	}
}