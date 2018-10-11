if instance_exists(argument0) {
    argument0.sentry = instance_create(argument0.object.x,argument0.object.y,Sentry);
    argument0.sentry.ownerPlayer = argument0;
    argument0.sentry.team = argument0.team;
    argument0.sentry.startDirection = argument0.object.image_xscale;
    argument0.sentry.image_xscale = argument0.object.image_xscale;
    if argument1 == 3 argument0.object.nutsNBolts -= 50;
    else if argument1 == 0 argument0.object.nutsNBolts -= 80;
    else argument0.object.nutsNBolts -= 100;
    argument0.sentry.level = argument1;
    
    if argument0.object != -1 {
        if argument0.object.weapon_index == WEAPON_WRANGLER argument0.object.currentWeapon.ammoCount = 100;
        else argument0.object.ammo[WEAPON_WRANGLER] = 100;
    }
    switch(argument1) {
        case 0:
            with(argument0.sentry) {
                spareHp=75;
                maxHp = 100;
                hp = 25;
            }
            break;
            
        case 5:
            with(argument0.sentry) {
                spareHp=55;
                maxHp = 80;
                hp = 25;
            }
            break;
            
        default: 
            with(argument0.sentry) {
                spareHp = 55;
                maxHp = 80;
                hp=25;
            }
            break;
    }
}
