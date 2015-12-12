package;

import flixel.*;

enum HatchSubstate {
	ZoomAway;
	CrackEgg;
}

class Minigame_Hatch implements Minigame {
	private var state:PlayState;
	private var substate:HatchSubstate;

	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
	}
	public function init():Void
	{

	}
	
	public function destroy():Void
	{
		
	}

	public function update():Void
	{
	}
}
