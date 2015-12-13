package;

import flixel.*;
using flixel.util.FlxSpriteUtil;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;

class Stars extends flixel.group.FlxGroup
{
	private var bars:Array<FlxBar>;
	private var timers:Array<FlxTimer>;
	private var scores:Array<Float>;
	private var values:Array<Float>;
	private var prevvalues:Array<Float>;

	public function create(x:Float, y:Float):Void {
		var star_w = 64;
		var star_h = 64;
		var dist = 16;
		var total_w = star_w * 3 + dist * 2;
		var start_x = x - total_w / 2;
		var start_y = y - star_h / 2;
		
		bars = [new FlxBar(start_x, start_y, FlxBar.FILL_BOTTOM_TO_TOP, star_w, star_h, null, "", 0, 1, false),
				new FlxBar(start_x + star_w + dist, start_y, FlxBar.FILL_BOTTOM_TO_TOP, star_w, star_h, null, "", 0, 1, false),
				new FlxBar(start_x + 2 * (star_w + dist), start_y, FlxBar.FILL_BOTTOM_TO_TOP, star_w, star_h, null, "", 0, 1, false)];
		timers = [new FlxTimer(null), new FlxTimer(null), new FlxTimer(null)];
		values = [0, 0, 0];
		scores = [0, 0, 0];
		prevvalues = [0, 0, 0];
		
		for (i in 0 ... bars.length) {
			bars[i].createImageBar("assets/images/star_bg.png", "assets/images/star_fg.png");
			bars[i].currentValue = 0;
			add(bars[i]);
			timers[i].active = false;
		}
	}
	
	public function reset():Void {
		for (i in 0 ... bars.length) {
			bars[i].currentValue = 0;
			timers[i].cancel();
			//bars[i].scale.set(0.9, 0.9);
		}
		values = [0, 0, 0];
		scores = [0, 0, 0];
		prevvalues = [0, 0, 0];
	}
	
	public function setScore(i:Int, score:Float):Void
	{
		remove(bars[i]);
		add(bars[i]);
		score = Math.min(1, Math.max(0, score)); // limit score to 0..1
		scores[i] = score;
		// scale for gfx, bc border counts to bar!
		var val = score * 0.85;
		prevvalues[i] = values[i];
		values[i] = val;
		timers[i].start(1);
		timers[i].active = true;
	}
	
	public override function update():Void {
		super.update();
		for (i in 0 ... timers.length) {
			if (timers[i].finished && timers[i].active) {
				timers[i].active = false;
				prevvalues[i] = values[i];
			}
			if (timers[i].active) {
				var a = timers[i].progress;
				var s:Float = 0.6;
				if (a < 0.2) {
					s = 0.6 + a * 5;
				} else {
					s = 1.6;
				}
				bars[i].scale.set(s, s);
				bars[i].currentValue = (1 - a) * prevvalues[i] + a * values[i];
			} else {
				var s:Float = bars[i].scale.x;
				if (s > 1) {
					s = Math.max(1, s - 0.03);
					bars[i].scale.set(s, s);
				}
			}
		}
	}
	
	public function finalScore():Float {
		var sum:Float = 0;
		for (i in 0 ... scores.length) {
			sum += scores[i];
		}
		return sum;
	}
}