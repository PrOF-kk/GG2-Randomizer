/**
 * argument0: The player who uses the scottish resistance
 * argument1: mouse_x
 * argument2: mouse_y
 */

var found;
found = false;
with(Mine) {
    if x > mouse_x-34 && x < mouse_x+34 && y > mouse_y-34 && y < mouse_y+34 {
        found = true;
    }
}
if found {
    write_ubyte(global.serverSocket, DETONATION_POS);
    //I'm assuming that you can't put your mouse outside of the screen (800 by 600) => sqrt(400²+300²)/2 = 250
    write_ubyte(global.serverSocket,round(point_distance(argument0.object.x,argument0.object.y,argument1,argument2)/2));
}


