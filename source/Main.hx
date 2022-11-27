package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.editor.EditorState;
import states.ingame.PlayState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, EditorState));
	}
}
