package states.ingame;

import objects.player.Gun;

class PlayState extends BasePlayState
{
    public override function create()
    {
        super.create();

        var gun = new Gun();
        add(gun);
        gun.screenCenter();
    }
}