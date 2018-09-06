/**
 * argument0: The player who uses the scottish resistance
 * argument1: the relative postition of the mouse
 */
 
if instance_exists(argument0.object) && argument0.object != -1 {
    var mouse_xpos, mouse_ypos;
    mouse_xpos = argument0.object.x+lengthdir_x(argument1,argument0.object.aimDirection);
    mouse_ypos = argument0.object.y+lengthdir_y(argument1,argument0.object.aimDirection);
    with(Mine) {
        if ownerPlayer == argument0 {
            //show_message("mouse = "+string(mouse_xpos)+", "+string(mouse_ypos)+" and mine = "+string(x)+", "+string(y));
            if x > mouse_xpos-34 && x < mouse_xpos+34 && y > mouse_ypos-34 && y < mouse_ypos+34 {
                //ownerPlayer.object.currentWeapon.lobbed -= 1;
                event_user(2);
            }
        }
    }
} else show_message("The detonation event has just been called for a dead player. Please report this bug.");
