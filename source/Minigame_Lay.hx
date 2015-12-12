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
		pb_w = 128;
		pb_h = 16;
		powerbar = new FlxBar(240-pb_w/2f, 240-pb_h/2, FlxBar.FILL_LEFT_TO_RIGHT, pb_w, pb_h, this, "power", 0, 100, false);
		powerbar.createGradientBar([0xffffffff,0xffffffff], [0xffff0000, 0xff00ff00], 2, 180, false, 0xffffffff);
		powerbar.kill();
		state.add(powerbar);
	}
	public function init():Void
	{
		power = 0;
		powerbar.revive();
	}

	public function update():Void
	{
		power += 0.5;
		power = power % 100;
	}
	
	public function destroy():Void
	{
		powerbar.kill();
	}
}
