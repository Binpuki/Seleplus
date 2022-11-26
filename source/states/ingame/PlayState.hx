package states.ingame;

import objects.player.Player;
import flixel.FlxG;
import flixel.FlxCamera;
import objects.player.weapon.Gun;

class PlayState extends BasePlayState
{
    public var player:Player;

    // FIRYDY NIGHT FUNKNBN
    public var camHUD:FlxCamera;

    public override function create()
    {
        super.create();

        FlxCamera.defaultCameras = [FlxG.camera];

        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD);

        //var gun = new Gun();
        //add(gun);
        //gun.screenCenter();

        player = new Player();
        add(player);

        controlScheme.addPressEvent(player.onKeyDown);
        controlScheme.addReleaseEvent(player.onKeyRelease);
    }
}