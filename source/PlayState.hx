package;

import flixel.*;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static inline var MINIGAME_LAY:Int = 0;
	public static inline var MINIGAME_BREED:Int = 1;
	public static inline var MINIGAME_HATCH:Int = 2; 

	public var cam:FlxCamera;

	public var currentMinigame:Int;
	var minigames:Array<Minigame>;
	public var bg:Backdrop;
	public var egg:Egg;
	public var chicken:Chicken;
	public var stars:Stars;
	private var fartTimer:FlxTimer;
	private var canFart:Bool;

	public var init:Bool;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		bg = new Backdrop();
		bg.init();
		egg = new Egg(100, 100);
		egg.create();
		chicken = new Chicken(100, 50);
		chicken.create();
		stars = new Stars();
		stars.create(240, 48);
		
		add(bg);
		add(egg);
		add(chicken);
		add(stars);

		minigames = [
			new Minigame_Lay(),
			new Minigame_Breed(),
			new Minigame_Hatch()
		];

		currentMinigame = -1;
		nextMinigame();
		
		FlxG.sound.playMusic("assets/music/bgm.wav", 1, true);
		
		FlxG.cameras.flash(0xff000000, 1);
		
		canFart = true;
		fartTimer = new FlxTimer(0.1, function(t:FlxTimer) { canFart = true; });
	}

	public function nextMinigame():Void
	{
		if (currentMinigame >= 0) minigames[currentMinigame].destroy();
		currentMinigame = (currentMinigame + 1) % minigames.length;
		minigames[currentMinigame].init();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		stars.update();
		minigames[currentMinigame].update();
		
		if (FlxG.keys.justPressed.F) {
			if (canFart) {
				canFart = false;
				fartTimer.reset();
				FlxG.sound.play("assets/sounds/fart.wav");
			}
		}
		
		
		//DEBUG
		if (FlxG.keys.justPressed.R)
		{
			nextMinigame();
		}
	}
}