/**
 * argument0: The player who gets stunned
 * argument1: The time the ball was flying
 */
 
write_ubyte(global.eventBuffer, BALL_STUN);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));
write_ubyte(global.eventBuffer, argument1);
