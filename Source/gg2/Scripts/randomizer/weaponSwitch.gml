if argument0 < WEAPON_COUNT {
    ammo[weapon_index]=currentWeapon.ammoCount;
    with(currentWeapon) {instance_destroy()};
    currentWeapon = instance_create(x,y,global.weapons[argument0]);
    if ammo[argument0] == -1 ammo[argument0] = currentWeapon.maxAmmo;
    else if ammo[argument0] != -2 currentWeapon.ammoCount=ammo[argument0];
    currentWeapon.owner=id;
    weapon_index=argument0;
    if ammo[argument0] < currentWeapon.maxAmmo with(currentWeapon) event_user(0);
    currentWeapon.ownerPlayer=player;
    if critting > 1 currentWeapon.crit = critting;
    if !cloak playsound(x,y,SwitchSnd);
}
