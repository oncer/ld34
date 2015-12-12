package;

import flixel.*;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;


enum LaySubstate {
	WaitForInput;
	WaitForPlop;
	PlopEgg;
	WaitForNextGame;
}

class Minigame_Lay implements Minigame {
	private var state:PlayState;
	private var powerbar:FlxBar;
	private var powerbar_fg:FlxSprite;
	private var powerbar_bg:FlxSprite;
	private var power:Float;
	private var time:Float;
	private var substate:LaySubstate;
	private var timer:FlxTimer;
	
	private var chicken_x:Float = 240;
	private var chicken_start_y:Float = 405;
	private var chicken_end_y:Float = 405-32;


	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
		var pb_w = 32;
		var pb_h = 128;
		powerbar = new FlxBar(240-pb_w/2.0, 200-pb_h/2.0, FlxBar.FILL_BOTTOM_TO_TOP, pb_w, pb_h, this, "power", 0, 1, false);
		//powerbar_fg = new FlxSprite(0,0,)
		//powerbar.createGradientBar([0xffffffff,0xffffffff], [0xffff0000, 0xff00ff00], 1, 90, false, 0xffffffff);
		powerbar.createImageBar("assets/images/powerbar_bg.png", "assets/images/powerbar_fg.png");
		powerbar.kill();
		state.add(powerbar);
		timer = new FlxTimer();
	}
	public function init():Void
	{
		power = 0;
		time = 0;
		substate = LaySubstate.WaitForInput;
		state.egg.x = 240;
		state.egg.y = 405;
		state.egg.kill();
		state.chicken.x = chicken_x;
		state.chicken.y = chicken_start_y;
		powerbar.revive();
	}

	public function update():Void
	{
		
		if (substate == LaySubstate.WaitForInput)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				substate = LaySubstate.WaitForPlop;
				trace("Pooppower: " + power);
				
				
				//Init timer for pause before laying egg
				timer.start(0.5, this.layEgg);
				state.chicken.playAnimation("prepare");
				trace("...");
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
		else if (substate == LaySubstate.PlopEgg)
		{
			var a = timer.progress;
			var cur_y = (1 - a) * chicken_start_y + a * chicken_end_y;
			state.chicken.vibrate(chicken_x, cur_y, 3.0);
		}
	}
	
	private function layEgg(Timer:FlxTimer):Void
	{
		//SOUND
		trace("<PFFFWRLT!>");
		FlxG.sound.play("assets/sounds/fart.wav");
		state.chicken.playAnimation("poop");
		//start timer for egglaying
		timer.start(0.3, this.layEggDone); // Laying animation duration
		substate = LaySubstate.PlopEgg;
		state.egg.revive();
		
		//Hacky egg scale: TODO add method in egg for setting scale while remaining in place! also add public param for min and max scale
		state.egg.size = 0.33;
	}
	
	private function layEggDone(Timer:FlxTimer):Void
	{
		trace("Wait a bit for next minigame..");
		timer.start(0.5, this.startNextGame); // Pause duration
		// hard set end position
		state.chicken.x = chicken_x; 
		state.chicken.y = chicken_end_y;
		state.chicken.playAnimation("idle");
		substate = LaySubstate.WaitForNextGame;
	}
	
	private function startNextGame(Timer:FlxTimer):Void
	{
		trace("Starting next minigame..");
		state.nextMinigame();
	}
	
	public function destroy():Void
	{
		powerbar.kill();
		state.egg.revive();
		timer.cancel();
	}
}
