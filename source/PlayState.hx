package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static inline var MINIGAME_LAY:Int = 0;
	public static inline var MINIGAME_BREED:Int = 1;
	public static inline var MINIGAME_HATCH:Int = 2; 

	public var currentMinigame:Int;
	var minigames:Array<Minigame>;
	public var bg:Backdrop;
	public var egg:Egg;
	public var chicken:Chicken;
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
		
		add(bg);
		add(egg);
		add(chicken);

		minigames = [
			new Minigame_Lay(),
			new Minigame_Breed(),
			new Minigame_Hatch()
		];

		currentMinigame = -1;
		nextMinigame();
	}

	public function nextMinigame():Void
	{
		if (currentMinigame >= 0) minigames[currentMinigame].destroy();
		currentMinigame++;
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
		minigames[currentMinigame].update();
	}
}