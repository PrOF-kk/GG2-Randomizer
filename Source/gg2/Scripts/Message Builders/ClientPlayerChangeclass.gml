write_ubyte(global.sendBuffer, PLAYER_CHANGECLASS);
write_ubyte(global.sendBuffer, argument0);
write_ushort(global.sendBuffer, ClientSendLoadout(argument0));
