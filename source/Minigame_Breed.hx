package;

import flixel.*;
import flixel.util.*;

class Minigame_Breed implements Minigame {
	private var state:PlayState;
	private var dbgSlider:FlxSprite;

	private var size:Float;
	private var temperature:Float; // -1 . 0 . 1
	private var tchange:Float; // temperature change
	private var echange:Float; // egg size change

	private var timer:FlxTimer; // egg timer

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

		dbgSlider = new FlxSprite(240, 450);
		dbgSlider.makeGraphic(20, 20, 0xffffff00);
		dbgSlider.offset.x = 10;
		dbgSlider.offset.y = 10;

		state.chicken.x = 240;
		state.chicken.y = 480 * Backdrop.HORIZON;
		state.add(dbgSlider);

		state.egg.size = 0.33;

		timer = new FlxTimer(10); // 10 seconds?!
	}

	public function destroy():Void
	{
		state.remove(dbgSlider);
	}

	public function update():Void
	{
		state.chicken.y = 480 * Backdrop.HORIZON - state.egg.offset.y * state.egg.size;

		temperature = Math.min(1, Math.max(-1, temperature + tchange));
		temperature -= 0.03*(1.0 - 0.6*temperature*temperature);

		echange = (1 - Math.abs(temperature)) * 0.003;
		state.egg.size += echange;

		if (FlxG.keys.pressed.SPACE) {
			tchange += 0.001;
		} else {
			tchange -= 0.001;
		}
		tchange = Math.max(-0.05, Math.min(0.05, tchange));

		dbgSlider.x = temperature * 240 + 240;

		if (timer.finished) {
			state.nextMinigame();
		}
	}
}
