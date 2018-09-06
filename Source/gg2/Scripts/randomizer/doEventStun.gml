if instance_exists(argument0.object) && argument0.object != -1 && instance_exists(argument1.object) && argument1.object != -1{ 
    with(argument0.object) {  
        runPower = 0;
        jumpStrength = 0;
        stunned=1;
        cloak=false;  
    }
    with(StunShot) {
        if ownerPlayer == other.argument1 instance_destroy();
    }
    argument1.object.currentWeapon.hasShot = false;
    var stunshot;
    stunshot = instance_create(argument0.object.x,argument0.object.y,StunShot);
    with(stunshot) { 
        owner=argument1.object.currentWeapon.owner;
        ownerPlayer=argument1.object.currentWeapon.ownerPlayer;
        team=owner.argument1.object.currentWeapon.owner.team;
        if argument1.object.currentWeapon.crit > 1 crit=argument1.object.currentWeapon.crit;
        weapon=WEAPON_STUNGUN;   
        target=argument0.object.id; 
        x=target.x;
        y=target.y;
    }
} else show_message("The stun event has just been called for a dead player. Please report this bug.");
