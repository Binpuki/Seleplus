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

    public var speed:Float = 0;
    public var maxSpeed:Float = 10;

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

        //if (mappings.pressed["LEFT"] || mappings.pressed["RIGHT"])
        //    speed += 0.4 * (speedM);
    }

    public function onKeyRelease(key:KeyCode, modifier:KeyModifier)
    {
        mappings.process(key, modifier, false);

        //if (!(mappings.pressed["RIGHT"] || mappings.pressed["LEFT"]))
        //    speed = 0;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (mappings.pressed["LEFT"] || mappings.pressed["RIGHT"])
        {
            var horizMultiplier:Float = (mappings.pressed["LEFT"] ? -1 : mappings.pressed["RIGHT"] ? 1 : 0);

            if (speed >= -maxSpeed && speed <= maxSpeed)
                speed += 0.4 * horizMultiplier;
            else
                speed = (maxSpeed * horizMultiplier);
        }

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