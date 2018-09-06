/**
 * argument0: The sentry's ownerPlayer
**/
 
if argument0.sentry == -1 && instance_exists(argument0.object) {
    argument0.sentry = instance_create(argument0.object.x,argument0.object.y,Sentry);
    argument0.sentry.ownerPlayer = argument0;
    argument0.sentry.team = argument0.team;
    argument0.sentry.startDirection = argument0.object.image_xscale;
    argument0.sentry.image_xscale = argument0.object.image_xscale;
    argument0.sentry.level = argument0.object.sentrylevel;
    switch(argument0.sentry.level) {
        case 0: 
            argument0.sentry.maxHp=100;
            break;
        case 1:
            argument0.sentry.maxHp=120;
            break;
        case 2:
            argument0.sentry.maxHp=140;
            break;
        default:
            argument0.sentry.maxHp=80;
    }
    argument0.sentry.spareHp = max(0,argument0.object.sentryhp-25);
    argument0.sentry.upgraded = argument0.object.sentryupgraded;
    argument0.sentry.buildspeed = 2;
    
    if argument0.object != -1 {
        with(argument0.object) {
            runPower=runBkp;
            jumpStrength=8;
            sprite_index = spriteBkp;
            carrySentry=0;
        }
    } else show_message("Dead players place sentries... Please report this bug.");
} else show_message("Tried to place 2 sentries for the same player. Epic fail. Please report this bug.");
