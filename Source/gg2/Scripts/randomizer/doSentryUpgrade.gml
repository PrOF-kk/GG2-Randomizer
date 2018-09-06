/**
 * argument0: The sentry's ownerPlayer
 * argument1: the new level
 */
if instance_exists(argument0.sentry) && argument0.sentry != -1 {
    playsound(argument0.sentry.x,argument0.sentry.y,SentryBuildSnd);
    with(argument0.sentry) {
        built = 0;
        upgraded = 0;
        level = other.argument1;
        switch(argument1) {
            case 0:
                spareHp=0;
                maxHp = 100;
                break;
            case 1:
                spareHp = 20;
                maxHp = 120;
                break;
            case 2: 
                spareHp = 20;
                maxHp = 140;
                break;
        }
        
    }
} else show_message("The upgrade event has just been called for a non-existant sentry. Please report this bug.");
