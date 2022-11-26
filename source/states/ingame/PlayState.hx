package states.ingame;

import objects.player.weapon.Gun;

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