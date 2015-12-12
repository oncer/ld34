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
	var minigameIdx:UInt;
	var minigames:Array<Minigame>;
	var egg:Egg;
	var chicken:Chicken;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		egg = new Egg(100, 100);
		egg.create();
		chicken = new Chicken(100, 50);
		chicken.create();
		add(egg);

		minigames = [
			new Minigame_Lay(),
			new Minigame_Breed(),
			new Minigame_Hatch()
		];

		minigameIdx = -1;
		nextMinigame();
	}

	public function nextMinigame():Void
	{
		minigameIdx++;
		minigames[minigameIdx].init();
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
		minigames[minigameIdx].update();
	}
}