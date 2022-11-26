package objects.player;

import controls.ControlMapping;
import controls.Converter;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;

class Player extends FlxTypedSpriteGroup<FlxSprite>
{
	public var player(default, null):PlayerSprite;

	public var speed:Float = 0;

	public var increaseSpeed:Float = 0.4;
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

		// if (mappings.pressed["LEFT"] || mappings.pressed["RIGHT"])
		//    speed += 0.4 * (speedM);
	}

	public function onKeyRelease(key:KeyCode, modifier:KeyModifier)
	{
		mappings.process(key, modifier, false);

		// if (!(mappings.pressed["RIGHT"] || mappings.pressed["LEFT"]))
		//    speed = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mappings.pressed["LEFT"] || mappings.pressed["RIGHT"])
		{
			var horizMultiplier:Float = (mappings.pressed["LEFT"] ? -1 : mappings.pressed["RIGHT"] ? 1 : 0);
			var dSpeed:Float = increaseSpeed * horizMultiplier;

			if (speed + dSpeed >= -maxSpeed && speed + dSpeed <= maxSpeed)
				speed += dSpeed;
			else
				speed = (maxSpeed * horizMultiplier);
		}
		else
		{
			speed = FlxMath.lerp(speed, 0, 0.1);
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
