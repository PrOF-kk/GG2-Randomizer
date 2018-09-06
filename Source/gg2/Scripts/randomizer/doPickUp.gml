/**
 * argument0: The sentry's ownerPlayer
**/
 
if argument0.sentry != -1 && instance_exists(argument0) {
    if argument0.object != -1 {
        with(argument0.object) {
            if argument0.team == TEAM_RED sprite_index = Engineer2RedS;
            else sprite_index = Engineer2BlueS;
            runPower=runBkp*3/4;
            jumpStrength=8*3/4;
            carrySentry=1;
            sentryhp=argument0.sentry.hp;
            sentryupgraded=argument0.sentry.upgraded;
            sentrylevel=argument0.sentry.level;
        }
        
        with(argument0.sentry) {
            pickedUp=1;
            instance_destroy();
        }
    } else show_message("Dead players are picking up sentries... Please report this bug.");
} else show_message("Tried to pick up a nonexistent sentry. Please report this bug.");
