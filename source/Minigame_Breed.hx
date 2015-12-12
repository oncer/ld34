package;

import flixel.*;
import flixel.util.*;

class Minigame_Breed implements Minigame {
	private var state:PlayState;
	private var thermoSlider:FlxSprite;
	private var thermoInd:FlxSprite;

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
		temperature = 0.5;
		tchange = 0;

		FlxG.watch.add(this, "temperature");
		FlxG.watch.add(this, "tchange");		
		FlxG.watch.add(this, "size");

		thermoSlider = new FlxSprite(240, 440, "assets/images/thermometer.png");
		thermoSlider.offset.x = 144;
		thermoSlider.origin.x = 144;
		thermoInd = new FlxSprite(240, 410, "assets/images/thermometer_indicator.png");
		thermoInd.offset.x = 16;
		thermoInd.origin.x = 16;
		//thermoInd.offset = thermoInd.origin;
		state.add(thermoSlider);
		state.add(thermoInd);

		state.chicken.x = 240;
		state.chicken.y = 480 * Backdrop.HORIZON;

		state.egg.size = 0.33;

		timer = new FlxTimer(10); // 10 seconds?!
	}

	public function destroy():Void
	{
		state.remove(thermoSlider);
		state.remove(thermoInd);
	}

	public function update():Void
	{
		state.chicken.y = 480 * Backdrop.HORIZON - state.egg.offset.y * state.egg.size;

		temperature = Math.min(1, Math.max(-1, temperature + tchange));
		if (temperature < -0.99 && FlxG.keys.pressed.SPACE) tchange = Math.max(0, tchange); //added keypress necessary --> slider can go all the way to the left
		temperature -= 0.03*(1.0 - temperature*temperature);

		echange = (1 - Math.abs(temperature)) * 0.003;
		state.egg.size += echange;

		if (FlxG.keys.pressed.SPACE) {
			tchange += 0.001;
		} else {
			tchange -= 0.001;
		}
		tchange = Math.max(-0.05, Math.min(0.05, tchange));

		thermoInd.x = temperature * 136 + 240;
		trace (thermoInd.x);

		if (timer.finished) {
			state.nextMinigame();
		}
	}
}
