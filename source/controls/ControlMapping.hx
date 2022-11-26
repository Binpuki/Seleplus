package controls;

import lime.ui.KeyModifier;
import lime.ui.KeyCode;
import flixel.input.keyboard.FlxKey;

class ControlMapping
{
    public var pressed(default, null):Map<String, Bool> = [];
    private var controlMappings(default, null):Map<String, FlxKey> = [];

    public function new() { };

    public function addMapping(name:String, key:FlxKey)
    {
        controlMappings.set(name, key);
    }

    public function removeMapping(name:String)
    {
        controlMappings.remove(name);
    }

    public function process(key:KeyCode, modifier:KeyModifier, pressed:Bool)
    {
        var flixelKey:FlxKey = Converter.fromKeyCodeToFlxKey(key, modifier);

        for (action in controlMappings.keys())
            if (controlMappings[action] == flixelKey)
                this.pressed.set(action, pressed);
            else if (pressed)
                this.pressed.set(action, !pressed);
    }
}