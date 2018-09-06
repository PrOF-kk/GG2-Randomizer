if instance_exists(argument0.object) && argument0.object != -1 { 
    with(argument0.object) {  
        invincible = true;
        alarm[6] = 30*5;
    }
} else show_message("The invincible has just been called for a dead player. Please report this bug.");
