package;

import flixel.*;
using flixel.util.FlxSpriteUtil;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.group.*;

enum StarsState
{
	Ingame;
	Final;
	FinalAdd;
	FinalMultiply;
	FinalMove;
	TotalAdd;
	Nothing;
}

class Stars extends flixel.group.FlxGroup
{
	private var bars:Array<FlxBar>;
	private var timers:Array<FlxTimer>;
	private var scores:Array<Float>;
	private var values:Array<Float>;
	private var totalscore:Float;
	private var scoretext:FlxBitmapFont;
	private var additionscores:Array<Float>;
	private var additionscore1_2:Float;
	private var additionScoreText:Array<FlxBitmapFont>;
	private var addtext_x_offset:Float;
	private var substate:StarsState;
	private var timer:FlxTimer;
	private var addresult:Float;

	private var level:Int;

	public var finished:Bool;

	private var barsBG:FlxTypedGroup<FlxBar>;
	private var barsFG:FlxTypedGroup<FlxBar>;

	public function create(x:Float, y:Float):Void {
		var star_w = 64;
		var star_h = 64;
		var dist = 6;
		var total_w = star_w * 3 + dist * 2;
		var start_x = 56 ; //x - total_w / 2;
		var start_y = 24 + star_h/2;
		
		bars = [new FlxBar(start_x, start_y, FlxBar.FILL_BOTTOM_TO_TOP, star_w, star_h, null, "", 0, 1, false),
				new FlxBar(start_x + star_w + dist, start_y, FlxBar.FILL_BOTTOM_TO_TOP, star_w, star_h, null, "", 0, 1, false),
				new FlxBar(start_x + 2 * (star_w + dist), start_y, FlxBar.FILL_BOTTOM_TO_TOP, star_w, star_h, null, "", 0, 1, false)];
		timers = [new FlxTimer(null), new FlxTimer(null), new FlxTimer(null)];
		timer = new FlxTimer();
		values = [0, 0, 0];
		scores = [0, 0, 0];
		
		barsBG = new FlxTypedGroup<FlxBar>();
		barsFG = new FlxTypedGroup<FlxBar>();

		for (i in 0 ... bars.length) {
			bars[i].createImageBar("assets/images/star_bg.png", "assets/images/star_fg.png");
			bars[i].currentValue = 0;
			bars[i].offset.set(bars[i].width/2, bars[i].height/2);
			bars[i].origin.set(bars[i].width/2, bars[i].height/2);
			barsBG.add(bars[i]);
			timers[i].active = false;
		}

		add(barsBG);
		add(barsFG);
		
		totalscore = 0;
		scoretext = new FlxBitmapFont("assets/images/numbers.png", 32, 48, "0123456789", 10);
		scoretext.text = "000000";
		scoretext.x = 320 - 64;
		scoretext.y = 32;
		add(scoretext);

		additionScoreText = new Array<FlxBitmapFont>();

		var i:Int;
		for (i in 0...3) {
			var addST:FlxBitmapFont = new FlxBitmapFont("assets/images/numbers_small.png", 16, 24, "0123456789", 10);
			addST.text = "0";
			addST.kill();
			additionScoreText.push(addST);
			add(addST);
		}

		level = 0;
	}
	
	public function reset():Void {
		barsFG.clear();
		for (i in 0 ... bars.length) {
			barsBG.add(bars[i]);
			bars[i].currentValue = 0;
			timers[i].cancel();
		}
		values = [0, 0, 0];
		scores = [0, 0, 0];

		substate = StarsState.Ingame;
		var addST:FlxBitmapFont;
		for (addST in additionScoreText) {
			addST.text = "0";
			addST.kill();
		}

		addtext_x_offset = 0;
		addresult = 0;

		additionscores = [0, 0, 1];
		finished = false;

		level++;
		trace("Level " + level);
	}
	
	public function setScore(i:Int, score:Float):Void
	{
		barsBG.remove(bars[i]);
		barsFG.add(bars[i]);
		var score_ = Math.min(1, Math.max(0, score)); // limit score to 0..1
		scores[i] = score_;
		// scale for gfx, bc border counts to bar!
		var val = score_ * 0.85;
		values[i] = val;
		if (i == 2) {
			new FlxTimer(1.5, finalAnimation);
		}
		timers[i].start(1);
		timers[i].active = true;
		
		trace("Score[" + i + "]: " + score + " -> " + score_);
	}

	private function addScoreAppear(timer:FlxTimer):Void
	{
		var i:Int;
		for (i in 0...additionScoreText.length) {
			if (!additionScoreText[i].exists) {
				additionScoreText[i].revive();
				additionScoreText[i].x = bars[i].x - additionScoreText[i].width / 2;
				additionScoreText[i].y = bars[i].y;
				additionScoreText[i].alpha = 0;
				if (i + 1 < additionScoreText.length) {
					new FlxTimer(0.5, addScoreAppear);
				}
				return;
			}
		}
	}
	
	public override function update():Void {
		super.update();
		if (substate == StarsState.Ingame) {
			for (i in 0 ... timers.length) {
				if (timers[i].finished && timers[i].active) {
					timers[i].active = false;
				}
				if (timers[i].active) {
					var a = timers[i].progress;
					var s:Float = 1.0;
					if (a < 0.2) {
						s = 1.0 + a * 3;
					} else {
						s = 1.6;
					}
					bars[i].scale.set(s, s);
					bars[i].currentValue = a * values[i];
				} else {
					var s:Float = bars[i].scale.x;
					if (s > 1) {
						s = Math.max(1, s - 0.03);
						bars[i].scale.set(s, s);
					}
				}
			}
		} else if (substate == StarsState.Final) {
			if (scores[0] > 0 && additionScoreText[0].exists) {
				scores[0] -= 0.02;
				additionscores[0] += level * scores[0];
				bars[0].currentValue = scores[0] * 0.85;
			} else if (scores[1] > 0 && additionScoreText[1].exists) {
				scores[1] -= 0.02;
				additionscores[1] += level * scores[1];
				bars[1].currentValue = scores[1] * 0.85;
			} else if (scores[2] > 0 && additionScoreText[2].exists) {
				scores[2] -= 0.02;
				if (scores[2] > 0.8) {
					additionscores[2] += 0.2;
				} else if (scores[2] > 0.5) {
					additionscores[2] += 0.068;
				}
				additionscores[2] += 0.011;
				bars[2].currentValue = scores[2] * 0.85;
			} else {
				if (additionScoreText[0].exists && additionScoreText[1].exists && additionScoreText[2].exists
					&& additionScoreText[2].alpha >= 1) {
					substate = StarsState.FinalAdd;
					addresult = Std.int(additionscores[0]) + Std.int(additionscores[1]);
					timer.start(0.4);
				}
			}
			var i:Int;
			for (i in 0...additionScoreText.length) {
				additionScoreText[i].text = "" + Std.int(additionscores[i]);
				additionScoreText[i].x = bars[i].x + 24 - additionScoreText[i].width;

				if (additionScoreText[i].alpha < 1) {
					additionScoreText[i].alpha = Math.min(1, additionScoreText[i].alpha + 0.05);
					additionScoreText[i].y = bars[i].y + 32 * additionScoreText[i].alpha;
				}
			}
		} else if (substate == StarsState.FinalAdd) {
			if (additionscores[0] > 0 || !timer.finished) {
				if (additionscores[0] > 0) {
					var transfer:Float = Math.min(additionscores[0], Math.max(1, additionscores[0] * 0.02));
					additionscores[1] += transfer;
					additionscores[0] -= transfer;
				}

				// move text #0 to the right and fade it out
				if (additionscores[0] < 30) {
					additionScoreText[0].alpha = Math.max(0, additionScoreText[0].alpha - 0.05);
					var target_x:Float = bars[1].x - additionScoreText[0].width / 2;
					additionScoreText[0].x += (target_x - additionScoreText[0].x) * 0.1;
				}
				// update text #1 and #0
				additionScoreText[0].text = "" + Std.int(additionscores[0]);
				additionScoreText[0].x = bars[0].x + 24 - additionScoreText[0].width;
				additionScoreText[1].text = "" + Std.int(additionscores[1]);
				additionScoreText[1].x = bars[1].x + 24 - additionScoreText[1].width;
			} else {
				additionscores[1] = addresult;
				addresult = Std.int(additionscores[1]) * Std.int(additionscores[2]);
				substate = StarsState.FinalMultiply;
				timer.start(0.4);
				// save result of multiplying slot 1 and 2 in slot 0
				additionscore1_2 = additionscores[1];
				additionscores[0] = 30; // timer: 0.5 seconds
			}

		} else if (substate == StarsState.FinalMultiply) {
			if (additionscores[2] > 1 || !timer.finished) {


				if (addtext_x_offset > 0) {
					addtext_x_offset--;
				}

				if (Std.int(additionscores[2]) > 1) {
					if (additionscores[0] > 0) {
						additionscores[0]--;
					} else {
						additionscores[2]--;
						additionscores[1] += additionscore1_2;
						additionscores[0] = 30; // timer: 0.5 seconds
						addtext_x_offset = 15;
					}
				} else {
					additionscores[2] = 0.9;
				}
			} else {
				additionscores[1] = addresult;
				addresult = Std.int(totalscore) + Std.int(additionscores[1]);
				substate = StarsState.FinalMove;
				timer.start(0.4);
			}


			// update text #1 and #2
			additionScoreText[1].text = "" + Std.int(additionscores[1]);
			additionScoreText[1].x = bars[1].x + 24 - additionScoreText[1].width + Std.int(addtext_x_offset/2);
			additionScoreText[2].text = "" + Std.int(additionscores[2]);
			additionScoreText[2].x = bars[2].x + 24 - additionScoreText[2].width - Std.int(addtext_x_offset/2);
		} else if (substate == StarsState.FinalMove) {
			// fade out text #2
			additionScoreText[2].alpha = Math.max(0, additionScoreText[2].alpha - 0.05);

			var text1_x_distance:Float = scoretext.x + scoretext.width - additionScoreText[1].width - additionScoreText[1].x;
			if (text1_x_distance > 1) {
				additionScoreText[1].x += 3;
			} else {
				substate = StarsState.TotalAdd;
			}

		} else if (substate == StarsState.TotalAdd) {
			if (additionscores[1] > 0) {
				var transfer:Float = Math.min(additionscores[1], Math.max(1, additionscores[1] * 0.02));
				totalscore += transfer;
				additionscores[1] -= transfer;
			} else {
				totalscore = addresult;
				// fade text #1 out
				additionScoreText[1].alpha = Math.max(0, additionScoreText[1].alpha - 0.05);
				//var target_y:Float = scoretext.y;
				//additionScoreText[1].y += (target_y - additionScoreText[1].y) * 0.05;
			}

			if (additionScoreText[1].alpha <= 0 && additionscores[1] <= 0) {
				// BACK TO THE START OF THE MINIGAMES
				finished = true;
				substate = StarsState.Nothing;
			}				

			// update total score text and text #1
			additionScoreText[1].text = "" + Std.int(additionscores[1]);
			additionScoreText[1].x = scoretext.x + scoretext.width - additionScoreText[1].width;
			scoretext.text = Sprintf.format("%06d", [Std.int(totalscore)]);
		}
	}
	
	public function finalAnimation(timer:FlxTimer) {
		substate = StarsState.Final;
		addScoreAppear(timer);
	}
	
	public function finalScore():Void {
		var sum:Float = 0;
		for (i in 0 ... scores.length) {
			sum += scores[i];
		}
		totalscore += Math.floor(1 * 100/3 * sum); //level * percent
		scoretext.text = Sprintf.format("%06d", [totalscore]);
	}
}