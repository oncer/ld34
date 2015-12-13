package;

import flixel.*;
import flixel.util.FlxTimer;

enum HatchSubstate {
	ZoomAway;
	CrackEgg;
}

class Minigame_Hatch implements Minigame {
	private var state:PlayState;
	private var substate:HatchSubstate;
	private var timer:FlxTimer;
	private var goal:FlxSprite;
	private var circle:FlxSprite;
	private var iter:Int;
	private var score:Float;
	
	private var rotateStrength:Float;
	private var rotateTime:Float;
	
	private var cracks:FlxSprite;

	public function new():Void
	{
		state = cast(FlxG.state, PlayState);
		
		goal = new FlxSprite(state.egg.x, state.egg.y, "assets/images/circle.png");
		goal.centerOrigin();
		goal.offset.set(goal.origin.x, goal.origin.y);
		goal.alpha = 0.5;
		circle = new FlxSprite(state.egg.x, state.egg.y, "assets/images/circle.png");
		circle.centerOrigin();
		circle.offset.set(circle.origin.x, circle.origin.y);
		
		state.add(goal); goal.kill();
		state.add(circle); circle.kill();
		
		cracks = new FlxSprite();
		cracks.loadGraphic("assets/images/crack.png", true, 96, 96);
		cracks.animation.add("crack", [0, 1, 2], 0, false);
		cracks.animation.frameIndex = 0;
		state.add(cracks);
		cracks.offset.set(state.egg.offset.x, state.egg.offset.y);
		cracks.origin.set(state.egg.origin.x, state.egg.origin.y);
	}
	public function init():Void
	{
		timer = new FlxTimer(1, timerFinished, 0);
		iter = 0;
		score = 0;
		
		state.egg.set_size(0.33);
		state.egg.x = 240;
		state.egg.y = 480 * Backdrop.HORIZON;
		
		goal.x = state.egg.x;
		goal.y = state.egg.y - 16;
		circle.x = goal.x;
		circle.y = goal.y;
		
		goal.revive();
		circle.revive();
		cracks.revive();
		
		cracks.scale.set(state.egg.scale.x, state.egg.scale.y);
		cracks.x = state.egg.x;
		cracks.y = state.egg.y;
		cracks.animation.frameIndex = 0;
		
		rotateStrength = 0;
		rotateTime = 0;
	
		// Debug
		state.egg.revive();
		state.chicken.kill();
	}
	
	public function destroy():Void
	{
		goal.kill();
		circle.kill();	
		cracks.kill();
		state.egg.angle = 0;
	}

	public function update():Void
	{
		var p = timer.progress;
		var s = (1 - p) * 2.25 + 0.75; //circle scale: 2 ... 0.1
		var max_alpha_pos = 1 - (1 - 0.75) / 2.25;
		var line_d = 1 / (1 - max_alpha_pos);
		var a = 0.0;
		if (p < max_alpha_pos)
			a = p / max_alpha_pos;
		else
			a = line_d  - p * line_d;
		circle.scale.x = s;
		circle.scale.y = s;
		circle.alpha = a;

		if (FlxG.keys.justPressed.SPACE) {
			timer.complete(timer);
			score += a / 3;
			rotateStrength = score;
		}
		
		rotateTime += rotateStrength;
		var r = Math.sin(rotateTime * 0.85);
		state.egg.angle = r * rotateStrength * 15;
		
		state.egg.vibrate(240, 480 * Backdrop.HORIZON, 3 * rotateStrength);
		
		
		cracks.angle = state.egg.angle;
		cracks.x = state.egg.x;
		cracks.y = state.egg.y;
	}
	
	public function timerFinished(FlxTimer):Void {
		trace ("Timer iteration finished: " + iter);
		
		++iter;
		cracks.animation.frameIndex = Std.int(Math.min(2, iter));
		if (iter < 3) {
			// Start next iteration
			timer.reset();
		} else if (iter == 3) {
			timer.cancel();
			// Last iteration done
			// ...
			state.stars.setScore(2, Math.sqrt(score * 1.5)); // sqrt score bc hard *1.5 to help
			//state.stars.finalScore();
			goal.kill();
			circle.kill();	
		}
		
	}
}
