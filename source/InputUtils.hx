package;
import lime.ui.Touch;
import flixel.FlxG;

class InputUtils
{
	public static function justPressed():Bool {
		var key = FlxG.keys.justPressed.SPACE;
		var mouse = FlxG.mouse.justPressed;
		var touched = false;
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				touched = true;
			}
		}
		
		return key || touched || mouse;
	}
	
	public static function pressed():Bool {
		var key = FlxG.keys.pressed.SPACE;
		var mouse = FlxG.mouse.pressed;
		var touched = false;
		for (touch in FlxG.touches.list)
		{
			if (touch.pressed)
			{
				touched = true;
			}
		}
		
		return key || touched || mouse;
	}
}