package;

import flixel.*;
import flixel.util.*;
import flixel.ui.FlxBar;

class Minigame_Breed implements Minigame {
	private var state:PlayState;
	private var thermoSlider:FlxSprite;
	private var thermoInd:FlxSprite;
	private var rocketfire:FlxSprite;

	private var size:Float;
	private var temperature:Float; // -1 . 0 . 1
	private var tchange:Float; // temperature change
	private var echange:Float; // egg size change

	private var timer:FlxTimer; // egg timer
	private var timer_gfxbg:FlxSprite;
	private var timer_gfxfg:FlxSprite;
	
	private var substate:Int; // breeding | chicken flying away & zooming

	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
	}

	public function init():Void
	{
		size = 1;
		temperature = 0;
		tchange = 0.05;
		substate = 0;

		FlxG.watch.add(this, "temperature");
		FlxG.watch.add(this, "tchange");		
		FlxG.watch.add(this, "size");

		thermoSlider = new FlxSprite(240, 440, "assets/images/thermometer.png");
		thermoSlider.offset.x = 144;
		thermoSlider.origin.x = 144;
		thermoInd = new FlxSprite(240, 410, "assets/images/thermometer_indicator.png");
		thermoInd.offset.x = 16;
		thermoInd.origin.x = 16;
		rocketfire = new FlxSprite();
		rocketfire.offset.x = 16;
		rocketfire.origin.x = 16;
		rocketfire.loadGraphic("assets/images/rocketfire.png", true, 32, 48);
		rocketfire.animation.add("fire", [0,1,2,3], 7, true);
		rocketfire.animation.play("fire");
		rocketfire.kill();
		timer_gfxbg = new FlxSprite(380, 96, "assets/images/eggtimer.png");
		timer_gfxbg.centerOrigin();
		timer_gfxbg.centerOffsets(true);
		timer_gfxfg = new FlxSprite(396, 128);
		timer_gfxfg.loadRotatedGraphic("assets/images/eggtimer_indicator.png", 180); //180 precomputed rotations
		timer_gfxfg.centerOrigin();
		timer_gfxfg.centerOffsets(true);
		state.add(thermoSlider);
		state.add(thermoInd);
		state.add(rocketfire);
		state.add(timer_gfxbg);
		state.add(timer_gfxfg);

		state.chicken.x = 240;
		state.chicken.y = 480 * Backdrop.HORIZON;

		state.egg.size = 0.33;

		timer = new FlxTimer(10); // 10 seconds?!
		new FlxTimer(1, function(t:FlxTimer) { FlxG.sound.play("assets/sounds/tick.wav"); }, 9);
	}

	public function destroy():Void
	{
		state.remove(thermoSlider);
		state.remove(thermoInd);
		state.remove(rocketfire);
		state.remove(timer_gfxbg);
		state.remove(timer_gfxfg);
	}

	public function update():Void
	{
		if (substate == 0) {
			var cur_chicken_y = 480 * Backdrop.HORIZON - state.egg.offset.y * state.egg.size;

			temperature = Math.min(1, Math.max(-1, temperature + tchange));
			if (temperature < -0.99 && FlxG.keys.pressed.SPACE) tchange = Math.max(0, tchange); //added keypress necessary --> slider can go all the way to the left
			if (temperature > 0.99 && !FlxG.keys.pressed.SPACE) tchange = Math.min(0, tchange); //.. same for other side
			temperature -= 0.03*(1.0 - temperature*temperature);

			echange = Math.max(0, (1 - 2 * Math.abs(temperature))) * 0.004; //changed --> bad temperatures no growth
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
			
			timer_gfxfg.angle = 360 * timer.progress;
			
			if (timer.finished) {
				substate = 1;
				rocketfire.x = state.chicken.x;
				rocketfire.y = state.chicken.y;
				rocketfire.revive();
				FlxG.sound.play("assets/sounds/timer.wav");
				FlxG.sound.play("assets/sounds/rocket.wav");
				FlxG.sound.play("assets/sounds/hngh.wav");//bogogck
				timer_gfxbg.kill();
				timer_gfxfg.kill();
				state.stars.setScore(1, (state.egg.size / 2.25) * (state.egg.size / 2.25)); // squared score
			}
			
			if (FlxG.keys.justPressed.SPACE) {
				state.chicken.playAnimation("wiggle");
				FlxG.sound.play("assets/sounds/wiggle.wav");
			}
			else if (FlxG.keys.justReleased.SPACE) state.chicken.playAnimation("idle");

		} else {
			//TODO fly
			state.chicken.playAnimation("idle");
			state.chicken.y -= 5;
			rocketfire.y -= 5;
			//TODO zoom at constant speed (get zoomtime from current eggscale~ scale 1.5 needs less time than scale 2.5)
			//-- chicken getting smaller
			//-- bg zoom
			//TODO after zoom:
			//-- kill() chicken
			//-- state.nextMinigame();
		}

	}
}
