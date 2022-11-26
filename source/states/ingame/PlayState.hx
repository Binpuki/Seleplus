package states.ingame;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.player.Player;
import objects.player.weapon.Gun;

class PlayState extends BasePlayState
{
	public var player:Player;

	// FIRYDY NIGHT FUNKNBN
	public var camHUD:FlxCamera;

	var testTxt:FlxText;

	public override function create()
	{
		super.create();

		FlxCamera.defaultCameras = [FlxG.camera];

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);

		// var gun = new Gun();
		// add(gun);
		// gun.screenCenter();

		// giant thing
		add(new FlxSprite(-300, -300).makeGraphic(600, 600, FlxColor.PINK));

		testTxt = new FlxText(10, 10, 0, "", 16);
		testTxt.cameras = [camHUD];
		add(testTxt);

		player = new Player();
		add(player);

		FlxG.camera.follow(player);

		controlScheme.addPressEvent(player.onKeyDown);
		controlScheme.addReleaseEvent(player.onKeyRelease);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		testTxt.text = Std.string(player.speed);
	}
}
