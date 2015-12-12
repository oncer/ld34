package;

import flixel.*;

class Minigame_Breed implements Minigame {
	private var state:PlayState;
	private var dbgSlider:FlxSprite;

	private var size:Float;
	private var temperature:Float; // -1 . 0 . 1
	private var tchange:Float; // temperature change

	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
	}

	public function init():Void
	{
		size = 1;
		temperature = 0;
		tchange = 0;

		FlxG.watch.add(this, "temperature");
		FlxG.watch.add(this, "tchange");		
		FlxG.watch.add(this, "size");

		dbgSlider = new FlxSprite(240, 400);
		dbgSlider.makeGraphic(20, 20, 0xffffff00);

		state.add(dbgSlider);
	}

	public function destroy():Void
	{
		state.remove(dbgSlider);
	}

	public function update():Void
	{
		tchange = Math.max(0, tchange - 0.0005);
		temperature = Math.min(1, Math.max(-1, temperature + tchange));
		temperature -= (temperature + 1) * 0.001;

		if (FlxG.keys.justPressed.SPACE) {
			tchange = Math.min(0.02, tchange + 0.01 - temperature * 0.005);
		}

		dbgSlider.x = temperature * 240 + 240 - 10;
	}
}
