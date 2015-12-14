package;

import flixel.*;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;


enum LaySubstate {
	WaitForInput; 		// Power bar charging --> Wait for space key
	Prepare; 			// Short delay before laying the egg (chicken looks)
	Poop; 				// Laying egg (egg appears and chicken moves)
	WaitForNextGame; 	// Short delay before starting next game
}

class Minigame_Lay implements Minigame {
	private var state:PlayState;
	
	private var powerbar:FlxBar;
	private var powerbar_best:FlxSprite;
	private var power:Float;
	private var time:Float;
	
	private var substate:LaySubstate;
	private var timer:FlxTimer;
	
	// Constants
	// speed
	private var power_dt:Float = 0.05;
	// positions
	private var chicken_x:Float = 480 * 0.5;
	private var chicken_start_y:Float = 480 * Backdrop.HORIZON;
	private var chicken_end_y:Float;
	// durations
	private var dur_prepare:Float = 0.75;
	private var dur_poop:Float = 0.5;
	private var dur_delaynext:Float = 0.5;


	public function new():Void
	{
		// Get playstate
		state = cast(FlxG.state, PlayState);
		// Create and position powerbar
		var pb_w = 48;
		var pb_h = 128;
		powerbar = new FlxBar(240-pb_w/2.0, 200-pb_h/2.0, FlxBar.FILL_BOTTOM_TO_TOP, pb_w, pb_h, this, "power", 0, 128, false);
		powerbar.createImageBar("assets/images/powerbar_bg.png", "assets/images/powerbar_fg.png");
		powerbar_best = new FlxSprite(240 - pb_w / 2.0, 200 - pb_h / 2.0, "assets/images/powerbar_white.png");
		powerbar.kill();
		state.add(powerbar);
		state.add(powerbar_best);
		// Create timer
		timer = new FlxTimer();
	}

	public function init():Void
	{
		state.stars.reset();
		//Reset vars, chicken & egg position, visibilities, state
		power = 0;
		time = 0;
		substate = LaySubstate.WaitForInput;
		state.egg.x = 240;
		state.egg.y = 480 * Backdrop.HORIZON;
		state.egg.kill();
		state.chicken.revive();
		state.chicken.x = chicken_x;
		state.chicken.y = chicken_start_y;
		chicken_end_y = state.egg.y - state.egg.offset.y * Egg.SIZE_LAY + 3;
		powerbar.revive();
		powerbar_best.visible = false;
		powerbar_best.revive();

		powerbar.alpha = 0;
	}

	public function update():Void
	{
		
		if (powerbar.alpha < 1) {
			powerbar.alpha += 0.05;
			time = 0;
		} else {
			time += power_dt;
		}

		if (substate == LaySubstate.WaitForInput) // powerbar charging
		{
			if (InputUtils.justPressed())
			{
				substate = LaySubstate.Prepare;
				//trace("PooPower: " + power);
				
				
				if (power > 122) // round up
					power = 128;
				if (power >= 127) // visualize perfect score
					powerbar_best.visible = true;
				else
					powerbar_best.visible = false;
				powerbar.currentValue = power;

				// Set egg color
				var eggtype = 0;
				if (power >  100)
					eggtype = 1;
				if (power >= 127)
					eggtype = 2;
				state.egg.animation.frameIndex = eggtype;
	
				// Start timer for prepare duration
				timer.start(dur_prepare, this.layEgg);
				state.chicken.playAnimation("prepare");
				
				// HNGGGH
				FlxG.sound.play("assets/sounds/hngh.wav");
				
				state.stars.setScore(0, (power / 128) * (power / 128)); // squared score
			}
			else 
			{
				// Charge power-bar
				/*
				// Linear
				power += power_dt;
				power = power % 1;
				*/
				//if (power < dt && powerbar_sound_canplay) {
				//FlxG.sound.play("assets/sounds/powerbar.wav");
				//	powerbar_sound_canplay = false;
				//} else if (power > 0.5)
				//	powerbar_sound_canplay = true;
				power = 1 - Math.abs(Math.cos(time)); // Fast at top
				power = Math.round(power * 128);
				//trace (power);
				
				if (power > 122) // round up
					power = 128;
				if (power >= 127) // visualize perfect score
					powerbar_best.visible = true;
				else
					powerbar_best.visible = false;
				powerbar.currentValue = power;
			}
		}
		else if (substate == LaySubstate.Prepare)
		{
			// Jitter while laying egg
			state.chicken.vibrate(chicken_x, chicken_start_y, 3.0);
		}
		else if (substate == LaySubstate.Poop)
		{
			// Move chicken while laying egg
			var t = timer.progress; // 0..1
			var a = t;//Math.max(0, t * 1.5 - 0.5); // 0..1 --> -0.2 .. 0 ... 1 --> 0 .. 0 ... 1
			var cur_y = (1 - a) * chicken_start_y + a * chicken_end_y;
			state.chicken.y = cur_y;
		}
	}
	
	private function layEgg(Timer:FlxTimer):Void
	{
		// Poop sound / animation / state
		substate = LaySubstate.Poop;
		FlxG.sound.play("assets/sounds/fart.wav");
		state.chicken.playAnimation("poop");
		state.chicken.fart();

		// Start timer for laying duration
		timer.start(dur_poop, this.layEggDone); // Laying animation duration
		
		// Show egg at initial small scale
		state.egg.revive();
		state.egg.size = Egg.SIZE_LAY;
	}
	
	private function layEggDone(Timer:FlxTimer):Void
	{
		substate = LaySubstate.WaitForNextGame;
		
		trace("Pausing before next game..");
		timer.start(dur_delaynext, this.startNextGame); // Pause duration
		
		// Hard set chicken end position
		state.chicken.x = chicken_x; 
		state.chicken.y = chicken_end_y;
		state.chicken.playAnimation("idle");
	}
	
	private function startNextGame(Timer:FlxTimer):Void
	{
		trace("Starting next minigame..");
		state.nextMinigame();
	}
	
	public function destroy():Void
	{	
		// Cleanup for debug and next game
		state.chicken.playAnimation("idle");
		powerbar.kill();
		powerbar_best.kill();
		state.egg.revive();
		timer.cancel();
	}
}
