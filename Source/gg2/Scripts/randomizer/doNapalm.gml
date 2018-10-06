/**
 * argument0: The player
 * argument1: x
 * argument2: y
 */

var critical;
critical = 1;
with(NapalmGrenade) {
    if ownerPlayer == argument0 and collision_circle(argument1, argument2, 4, NapalmGrenade,false,false){
        if crit > 1 critical = crit;
        instance_destroy();
    }
} 
 
instance_create(argument1,argument2,Explosion);
playsound(argument1,argument2,ExplosionSnd);
for(i=0;i<60;i+=1){
    shot = instance_create(argument1,argument2,NapalmFlame);
    shot.direction=i*3;
    shot.owner=argument0.object;
    shot.ownerPlayer=argument0;
    shot.team=argument0.team;
    if critical > 1 shot.crit=critical;
    shot.weapon=WEAPON_NAPALM;
    with(shot) motion_add(direction, 2);
}

