package;

import flixel.*;
import flixel.ui.FlxBar;

class Minigame_Lay implements Minigame {
	private var state:PlayState;
	private var powerbar:FlxBar;
	private var power:Float;
	//add barsprite to state in init and remove in destroy

	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
		powerbar = new FlxBar(0, 240, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10, this, "power", 0, 100, false);
		powerbar.createGradientBar([0xff005555], [0xffff0000, 0xff00ff00], 2, 180, false, 0xffffffff);
		powerbar.kill();
	}
	public function init():Void
	{
		power = 0;
		powerbar.revive();
	}

	public function update():Void
	{
		power += 0.01;
		power = power % 100;
	}
	
	public function destroy():Void
	{
		//powerbar.kill();
		
	}
}
