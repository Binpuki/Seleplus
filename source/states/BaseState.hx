package states;

import controls.ControlScheme;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;

class BaseState extends FlxUIState
{
	private var controlScheme:ControlScheme;

	public function new()
	{
		super();

		controlScheme = new ControlScheme();
	}

	override function destroy()
	{
		super.destroy();

		controlScheme.destroy();
	}
}
