if instance_exists(argument0.object) && argument0.object != -1 { 
    with(argument0.object) { 
        if argument1 == 255 alarm[10] = 120; 
        else alarm[10] = 30+3*argument1;
        runPower = runPower*(3/4);
        jumpStrength = jumpStrength*(3/4);
        stunned = true;
        cloak = false;
        if argument1 > 0 && argument1 != 255 {
            var text;
            text=instance_create(x,y,Text);
            text.sprite_index = BonkS;
        }
        var blood;
        if(global.gibLevel > 0){
            blood = instance_create(x,y,Blood);
            blood.direction = direction-180;
        }  
        if argument1 > 0 && argument1 != 255 playsound(x,y,BonkSnd);
    }
} else show_message("The ball-stun has just been called for a dead player. Please report this bug.");
