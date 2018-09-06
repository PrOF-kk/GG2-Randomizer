/**
 * argument0: The player who is invincible
**/
 
write_ubyte(global.eventBuffer, INVINCIBLE);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));
