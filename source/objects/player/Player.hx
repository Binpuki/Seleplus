package objects.player;

import controls.ControlMapping;
import controls.Converter;
import flixel.input.keyboard.FlxKey;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxSprite;

class Player extends FlxTypedSpriteGroup<FlxSprite>
{
    public var player(default, null):PlayerSprite;

    private var speed = 0;

    public var mappings:ControlMapping;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        mappings = new ControlMapping();
        mappings.addMapping("LEFT", LEFT);
        mappings.addMapping("RIGHT", RIGHT);

        player = new PlayerSprite();
        add(player);
    }  

    public function onKeyDown(key:KeyCode, modifier:KeyModifier)
    {
        mappings.process(key, modifier, true);

        if (mappings.pressed["RIGHT"])
            speed = 10;

        if (mappings.pressed["LEFT"])
            speed = -10;
    }

    public function onKeyRelease(key:KeyCode, modifier:KeyModifier)
    {
        mappings.process(key, modifier, false);

        if (!(mappings.pressed["RIGHT"] || mappings.pressed["LEFT"]))
            speed = 0;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        x += speed;
    }
}

class PlayerSprite extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        // TEMP !!!
        makeGraphic(100, 100);
    }
}