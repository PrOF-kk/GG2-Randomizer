/*
 * argument0 = playerid
 * argument1 = x
 * argument2 = y
*/
write_ubyte(global.eventBuffer, NAPALM_EXPLOSION);
write_ubyte(global.eventBuffer, argument0);
write_ushort(global.eventBuffer, argument1);
write_ushort(global.eventBuffer, argument2);


