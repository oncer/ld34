package;

import flixel.*;
import flixel.util.*;
import flixel.ui.FlxBar;

enum BreedSubstate {
	Breed;
	//TimeUp;
	FlyZoom;
}

class Minigame_Breed implements Minigame {
	private var state:PlayState;
	private var thermoSlider:FlxSprite;
	private var thermoInd:FlxSprite;

	private var size:Float;
	private var temperature:Float; // -1 . 0 . 1
	private var tchange:Float; // temperature change
	private var echange:Float; // egg size change

	private var timer:FlxTimer; // egg timer
	private var sndTimer:FlxTimer; // tick timer
	private var timebar:FlxBar;
	private var timeremaining:Float;
	
	private var substate:BreedSubstate;

	private var zoomInitial:Float;
	private var zoomTargetChicken:Float;
	private var zoomTargetBG:Float;
	private var finalEggSize:Float;

	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
	}

	public function init():Void
	{
		size = 1;
		temperature = 0;
		tchange = 0.05;
		substate = BreedSubstate.Breed;

		FlxG.watch.add(this, "temperature");
		FlxG.watch.add(this, "tchange");		
		FlxG.watch.add(this, "size");
		
		
		timer = new FlxTimer(10); // 10 seconds?!
		sndTimer = new FlxTimer(0.5, function(t:FlxTimer) { FlxG.sound.play("assets/sounds/tick.wav"); }, 19);

		thermoSlider = new FlxSprite(240, 440, "assets/images/thermometer.png");
		thermoSlider.offset.x = 144;
		thermoSlider.origin.x = 144;
		thermoInd = new FlxSprite(240, 410, "assets/images/thermometer_indicator.png");
		thermoInd.offset.x = 16;
		thermoInd.origin.x = 16;
		timebar = new FlxBar(240 - 144, 420, FlxBar.FILL_HORIZONTAL_INSIDE_OUT, 288, 16, this, "timeremaining", 0, 1, false);
		timebar.createImageBar(null, "assets/images/timebar.png", 0x00000000);
		timeremaining = 1;
		state.add(timebar);
		state.add(thermoSlider);
		state.add(thermoInd);

		state.chicken.x = 240;
		state.chicken.y = 480 * Backdrop.HORIZON;

		state.egg.size = 0.33;
	}

	public function destroy():Void
	{
		state.remove(thermoSlider);
		state.remove(thermoInd);
		state.remove(timebar);
		timer.cancel();
		sndTimer.cancel();
		state.chicken.zoom = 1;
		state.chicken.velocity.y = 0;
		state.chicken.rocketOff();
	}

	public function update():Void
	{
		if (substate == BreedSubstate.Breed) {
			var cur_chicken_y = 480 * Backdrop.HORIZON - state.egg.offset.y * state.egg.size + 3;

			temperature = Math.min(1, Math.max(-1, temperature + tchange));
			if (temperature < -0.99 && FlxG.keys.pressed.SPACE) tchange = Math.max(0, tchange); //added keypress necessary --> slider can go all the way to the left
			if (temperature > 0.99 && !FlxG.keys.pressed.SPACE) tchange = Math.min(0, tchange); //.. same for other side
			temperature -= 0.03*(1.0 - temperature*temperature);

			echange = Math.max(0, (1 - 2 * Math.abs(temperature))) * 0.004; //changed --> bad temperatures no growth
			echange = echange * (state.egg.animation.frameIndex + 1) * 0.333;
			state.egg.size += echange;

			if (FlxG.keys.pressed.SPACE) {
				state.chicken.vibrate(240, cur_chicken_y, 2); //Loltest
				tchange += 0.001;
			} else {
				state.chicken.x = 240;
				state.chicken.y = cur_chicken_y;
				tchange -= 0.001;
			}
			tchange = Math.max(-0.05, Math.min(0.05, tchange));

			thermoInd.x = temperature * 136 + 240;
			
			timeremaining = 1 - timer.progress;
			if (timer.finished) {
				substate = BreedSubstate.FlyZoom;
				state.chicken.playAnimation("idle");
				zoomInitial = state.bg.zoom;
				finalEggSize = state.egg.size;
				zoomTargetChicken = Egg.SIZE_HATCH / finalEggSize;
				zoomTargetBG = state.bg.zoom * Egg.SIZE_HATCH / finalEggSize;
				timer.start(3);
				state.chicken.rocket();
				FlxG.sound.play("assets/sounds/timer.wav");
				FlxG.sound.play("assets/sounds/rocket.wav");
				FlxG.sound.play("assets/sounds/hngh.wav");//bogogck
				timebar.kill();
				state.stars.setScore(1, (state.egg.size / 2.25) * (state.egg.size / 2.25)); // squared score
			}
			
			if (FlxG.keys.justPressed.SPACE) {
				state.chicken.playAnimation("wiggle");
				FlxG.sound.play("assets/sounds/wiggle.wav");
			}
			else if (FlxG.keys.justReleased.SPACE) state.chicken.playAnimation("idle");
		} else if (substate == BreedSubstate.FlyZoom) {
			//TODO fly
			var f:Float = (timer.finished) ? 1.0 : timer.progress;
			state.chicken.velocity.y = Math.min(-300, Math.max(-1000, state.chicken.velocity.y - 1));
			state.egg.size = finalEggSize + (Egg.SIZE_HATCH - finalEggSize) * f;
			state.chicken.zoom = 1 + (zoomTargetChicken - 1) * f;
			state.bg.zoom = zoomInitial + (zoomTargetBG - zoomInitial) * f;
			if (timer.finished) {
				state.nextMinigame();
			}
			//TODO zoom at constant speed (get zoomtime from current eggscale~ scale 1.5 needs less time than scale 2.5)
			//-- chicken getting smaller
			//-- bg zoom
			//TODO after zoom:
			//-- kill() chicken
			//-- state.nextMinigame();
		}

	}
}
