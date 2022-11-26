package objects.player.weapon;

import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;

class Gun extends FlxSprite
{
    public var bulletOffset:FlxPoint; // where the bullet should come out

    public var mouseCalc(get, null):FlxPoint;
    function get_mouseCalc():FlxPoint
        return FlxPoint.weak(FlxG.mouse.x - (x + bulletOffset.x), FlxG.mouse.y - (y + bulletOffset.y));
    
    public var gunAngle(get, null):Float;
    function get_gunAngle():Float
        return Math.atan2(mouseCalc.y, mouseCalc.x);

    public var gunAngleDegrees(get, null):Float;
    function get_gunAngleDegrees():Float
        return gunAngle * (180 / Math.PI);

    public function new()
    {
        super();

        // temporary 4 now
        loadGraphic("assets/images/gun.png");
        bulletOffset = FlxPoint.get(width / 2, height / 2);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        // woah degrees poop penis
        angle = gunAngleDegrees;

        // TEMPORARY
        if (FlxG.keys.justPressed.P)
            FlxG.state.add(new Bullet(this));
    }
}

class Bullet extends FlxSprite
{
    public var damage:Float = 5;
    public var speed:Float = 5;

    public var originalCalc:FlxPoint;

    // will not damage these objects if collided with
    public var excludeCollisions:Array<FlxObject> = [];

    private var hypotenuse:Float = 0;
    private var parent:Gun;

    public function new(gun:Gun)
    {
        parent = gun;
        originalCalc = FlxPoint.get(parent.mouseCalc.x, parent.mouseCalc.y);
        super(parent.x, parent.y);

        // temporary
        makeGraphic(50, 50);

        // pytaghorem theorem from SHCOOL omg
        hypotenuse = Math.sqrt(Math.pow(parent.mouseCalc.x, 2) + Math.pow(parent.mouseCalc.y, 2));
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        x += (originalCalc.x / (hypotenuse / speed));
        y += (originalCalc.y / (hypotenuse / speed));
    }
}