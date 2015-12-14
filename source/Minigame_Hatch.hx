package;

import flixel.*;
import flixel.util.FlxTimer;
import flixel.effects.particles.*;

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
	private var ok_hit:Bool; //if hit was good enough not to play bad sound
	
	private var rotateStrength:Float;
	private var rotateTime:Float;
	
	private var cracks:FlxSprite;
	private var particles:FlxEmitter;

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
		
		particles=new FlxEmitter();
        particles.makeParticles("assets/images/egg01_particles.png", 200, 16, true, 0);
        particles.setRotation(0, 360);
        particles.setYSpeed(-300, 150);
        particles.setXSpeed( -150, 150);
		particles.setAlpha(1, 1, 0, 0);
		particles.setScale(0.8, 2.5, 0, 0.2);
        particles.gravity = 300;
		state.add(particles);
	}
	public function init():Void
	{
		timer = new FlxTimer(1, timerFinished, 0);
		FlxG.sound.play("assets/sounds/circle.wav");
		iter = 0;
		score = 0;
		
		state.egg.set_size(Egg.SIZE_HATCH);
		state.egg.x = 240;
		state.egg.y = 480 * Backdrop.HORIZON;
		
		goal.x = state.egg.x;
		goal.y = state.egg.y - (state.egg.height*0.5) * state.egg.scale.y;
		circle.x = goal.x;
		circle.y = goal.y;
		circle.scale.set(3, 3);
		circle.alpha = 0;
		goal.alpha = 0;
		
		goal.revive();
		circle.revive();
		cracks.revive();
		
		cracks.scale.set(state.egg.scale.x, state.egg.scale.y);
		cracks.x = state.egg.x;
		cracks.y = state.egg.y;
		cracks.animation.frameIndex = 0;
		
		particles.x = state.egg.x - state.egg.width / 2 * state.egg.scale.x * 0.5;
		particles.y = state.egg.y - state.egg.height * state.egg.scale.y * 0.75 * 1.1;
		particles.setSize(Std.int(state.egg.width* state.egg.scale.x * 0.5), Std.int(state.egg.height* state.egg.scale.y * 0.75));

		var particle:FlxParticle;
        for (particle in particles.members) {
        	particle.x = particles.x + Math.cos(Math.random()) * particles.width;
        	particle.y = particles.y + Math.sin(Math.random()) * particles.height;
        }
		
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
		timer.cancel();
	}

	public function update():Void
	{
		if (goal.alpha < 1) {
			goal.alpha = Math.min(1, goal.alpha + 0.0125);
		}

		var p = timer.progress;
		var s = (1 - p) * 2.25 + 0.5; //circle scale: 3 ... 0.5
		var max_alpha_pos = 1 - (1 - 0.5) / 2.25;
		var line_d = 1 / (1 - max_alpha_pos);
		var a = 0.0;
		if (p < max_alpha_pos)
			a = p / max_alpha_pos;
		else
			a = line_d  - p * line_d;
		circle.scale.x = s;
		circle.scale.y = s;
		circle.alpha = a;

		if (InputUtils.justPressed() && iter <= 2) {
			ok_hit = p < max_alpha_pos ? a > 0.9 : a > 0.6;
			timer.complete(timer);
			score += a / 3;
			trace(a/3);
			rotateStrength = score;
			//FlxG.cameras.flash(0xbfffffff, 0.5, null, true);
			state.egg.pulse(a * a);
		}
		
		rotateTime += rotateStrength;
		var r = Math.sin(rotateTime * 0.85);
		state.egg.angle = r * rotateStrength * 15;
		
		state.egg.vibrate(240, 480 * Backdrop.HORIZON, 3 * rotateStrength);
		
		
		cracks.angle = state.egg.angle;
		cracks.x = state.egg.x;
		cracks.y = state.egg.y;
		cracks.scale.x = state.egg.scale.x;
		cracks.scale.y = state.egg.scale.y;

		if (state.stars.finished) {
			state.nextMinigame();
		}
	}
	
	public function timerFinished(FlxTimer):Void {
		trace ("Timer done: " + iter + " Hit ok: " + ok_hit);
		
		++iter;
		cracks.animation.frameIndex = Std.int(Math.min(2, iter));
		if (iter <= 3 && !ok_hit) {
			FlxG.sound.play("assets/sounds/fail.wav", 0.7); //TODO Neg sound
		}
		ok_hit = false;
		if (iter < 3) {
			// Start next iteration
			timer.reset();
			FlxG.sound.play("assets/sounds/circle.wav");
			FlxG.sound.play("assets/sounds/crack.wav");
		} else if (iter == 3) {
			timer.cancel();
			FlxG.sound.play("assets/sounds/plop.wav");
			// Last iteration done
			// ...
			state.stars.setScore(2, (score * score) / 0.43);
			//state.stars.finalScore();
			goal.kill();
			circle.kill();	
			particles.start(true, 1, 0, 0);
			state.egg.kill();
			cracks.kill();
			
			// lay chikken
			var chicken_x = 480 * 0.5;
			var chicken_start_y = 480 * Backdrop.HORIZON;
			state.chicken.revive();
			state.chicken.x = chicken_x;
			state.chicken.y = chicken_start_y;
			state.chicken.scale.x = 1;
			state.chicken.scale.y = 1;
			state.chicken.createNextChicken();
			state.chicken.playAnimation("idle");
		}
		
	}
}
