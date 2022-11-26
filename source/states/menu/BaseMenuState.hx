package states.menu;

import lime.app.Event;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import flixel.FlxState;

class BaseMenuState extends BaseState
{
    public var allowInputs:Bool = true; // STOP SPMAINGNG DUMBASS

    // waog events omg :O
    private var onLeft(default, null):Event<Void->Void> = new Event<Void->Void>();
    private var onRight(default, null):Event<Void->Void> = new Event<Void->Void>();
    private var onDown(default, null):Event<Void->Void> = new Event<Void->Void>();
    private var onUp(default, null):Event<Void->Void> = new Event<Void->Void>();
    private var onEnter(default, null):Event<Void->Void> = new Event<Void->Void>();
    private var onBack(default, null):Event<Void->Void> = new Event<Void->Void>();

    public function new()
    {
        super();

        // ik im a genius coder
        controlScheme.addPressEvent(_onLeft);
        controlScheme.addPressEvent(_onRight);
        controlScheme.addPressEvent(_onDown);
        controlScheme.addPressEvent(_onUp);
        controlScheme.addPressEvent(_onEnter);
        controlScheme.addPressEvent(_onBack);
    }

    private function _onLeft(key:KeyCode, modifier:KeyModifier)
    {
        if (key != LEFT || !allowInputs) return;
        onLeft.dispatch();
    }

    private function _onRight(key:KeyCode, modifier:KeyModifier)
    {
        if (key != RIGHT || !allowInputs) return;
        onRight.dispatch();
    }

    private function _onDown(key:KeyCode, modifier:KeyModifier)
    {
        if (key != DOWN || !allowInputs) return;
        onDown.dispatch();
    }

    private function _onUp(key:KeyCode, modifier:KeyModifier)
    {
        if (key != UP || !allowInputs) return;
        onUp.dispatch();
    }

    private function _onEnter(key:KeyCode, modifier:KeyModifier)
    {
        if (key != RETURN || !allowInputs) return;
        onEnter.dispatch();
    }

    private function _onBack(key:KeyCode, modifier:KeyModifier)
    {
        if (key != ESCAPE || !allowInputs) return;
        onBack.dispatch();
    }
}