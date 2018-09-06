/**
 * argument0: The sentry's ownerPlayer
 * argument1: the new level
 */
 
write_ubyte(global.eventBuffer, SENTRY_UPGRADE);
write_ubyte(global.eventBuffer, ds_list_find_index(global.players, argument0));
write_ubyte(global.eventBuffer, argument1);
