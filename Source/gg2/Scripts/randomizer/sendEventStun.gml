/**
 * argument0: The player who is stunned
 * argument1: The player who shot the stunshot
 */
 
write_ubyte(global.eventBuffer, STUN);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument1))
