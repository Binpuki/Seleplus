package objects.player;

import flixel.FlxG;
import flixel.FlxSprite;

class Gun extends FlxSprite
{
    public function new()
    {
        super();

        loadGraphic("assets/images/gun.png");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        angle = Math.atan2(FlxG.mouse.y - (y + (height / 2)), FlxG.mouse.x - (x + (width / 2))) * (180 / Math.PI);
    }
}