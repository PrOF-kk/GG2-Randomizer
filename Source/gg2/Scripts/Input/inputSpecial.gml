if (global.myself.object.weapon_index >= WEAPON_NAILGUN && global.myself.object.weapon_index <= WEAPON_EUREKAEFFECT)
{
    if !instance_exists(BuildMenu) instance_create(0,0,BuildMenu);
    else if instance_exists(BuildMenu) with (BuildMenu) done=true;
} else if global.myself.object.weapon_index == WEAPON_RIFLE or global.myself.object.weapon_index == WEAPON_SNIPEANATURE
       or global.myself.object.weapon_index == WEAPON_BAZAARBARGAIN or global.myself.object.weapon_index == WEAPON_MACHINA
       or global.myself.object.weapon_index == WEAPON_SYDNEYSLEEPER {
    write_ubyte(global.serverSocket, TOGGLE_ZOOM);
}
