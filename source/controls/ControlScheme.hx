package controls;

import lime.app.Event;
import lime.app.Application;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;

// this for event shit, if you want shit from the keyboard, use FlxG.keys dumbass
class ControlScheme
{
    // this just fo easy access
    public static var onKeyDown(get, null):Event<KeyCode->KeyModifier->Void>;
    static function get_onKeyDown():Event<KeyCode->KeyModifier->Void>
        return Application.current.window.onKeyDown;

    public static var onKeyUp(get, null):Event<KeyCode->KeyModifier->Void>;
    static function get_onKeyUp():Event<KeyCode->KeyModifier->Void>
        return Application.current.window.onKeyUp;

    public function new() { }

    // storing events to delete shit off of later
    private var pressEvents:Array<KeyCode->KeyModifier->Void> = [];
    private var releaseEvents:Array<KeyCode->KeyModifier->Void> = [];

    public function addPressEvent(func:KeyCode->KeyModifier->Void)
    {
        onKeyDown.add(func);
        pressEvents.push(func);
    }

    public function removePressEvent(func:KeyCode->KeyModifier->Void)
    {
        onKeyDown.remove(func);
        pressEvents.remove(func);
    }

    public function addReleaseEvent(func:KeyCode->KeyModifier->Void)
    {
        onKeyUp.add(func);
        releaseEvents.push(func);
    }

    public function removeReleaseEvent(func:KeyCode->KeyModifier->Void)
    {
        onKeyUp.remove(func);
        releaseEvents.remove(func);
    }

    public function destroy()
    {
        for (pressEvent in pressEvents)
            onKeyDown.remove(pressEvent);

        for (releaseEvent in releaseEvents)
            onKeyUp.remove(releaseEvent);

        pressEvents = null;
        releaseEvents = null;
    }
}