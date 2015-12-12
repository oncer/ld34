package;

import flixel.*;
import flixel.ui.FlxBar;

enum LaySubstate {
	WaitForInput;
	PlopEgg;
}

class Minigame_Lay implements Minigame {
	private var state:PlayState;
	private var powerbar:FlxBar;
	private var power:Float;
	private var time:Float;
	private var substate:LaySubstate;
	//405
	


	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
		var pb_w = 16;
		var pb_h = 96;
		powerbar = new FlxBar(240-pb_w/2.0, 240-pb_h/2.0, FlxBar.FILL_BOTTOM_TO_TOP, pb_w, pb_h, this, "power", 0, 1, false);
		powerbar.createGradientBar([0xffffffff,0xffffffff], [0xffff0000, 0xff00ff00], 1, 90, false, 0xffffffff);
		powerbar.kill();
		state.add(powerbar);
	}
	public function init():Void
	{
		power = 0;
		time = 0;
		substate = LaySubstate.WaitForInput;
		powerbar.revive();
	}

	public function update():Void
	{
		//DEBUG
		if (FlxG.keys.justPressed.R)
		{
			destroy();
			init();
			return;
		}
		
		if (substate == LaySubstate.WaitForInput)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				substate = LaySubstate.PlopEgg;
				trace("Pooppower: " + power);
				
				
				//init timer for sound/animation/..nextminigame
			}
			else 
			{
				/*
				power += 0.03333;
				power = power % 1;
				*/
				time += 0.05;
				power = 1 - Math.abs(Math.sin(time));
			}
		}
	}
	
	public function destroy():Void
	{
		powerbar.kill();
	}
}
