package states;

import controls.ControlScheme;
import flixel.FlxState;

class BaseState extends FlxState
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