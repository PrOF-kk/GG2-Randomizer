var noOfPlayers;
noOfPlayers = ds_list_size(global.players);
if(global.dedicatedMode)
    noOfPlayers -= 1;

var lobbyBuffer;
lobbyBuffer = buffer_create();
set_little_endian(lobbyBuffer, false);

parseUuid("b5dae2e8-424f-9ed0-0fcb-8c21c7ca1352", lobbyBuffer); // Message Type "register"
write_buffer(lobbyBuffer, GameServer.serverId);
write_buffer(lobbyBuffer, global.gg2lobbyId);
write_ubyte(lobbyBuffer, 0); // TCP
write_ushort(lobbyBuffer, global.hostingPort);
write_ushort(lobbyBuffer, global.playerLimit);
write_ushort(lobbyBuffer, noOfPlayers);
//We can also write the amount of bots but since RM doensn't have bots I used this as a byte
//that sends the mode data to the lobby. This will look kinda weird on non-RM servers though.
var mode;
mode = 0;
if global.medieval mode |= $01;
if global.randomizer == 1 mode |= $02;
if global.randomizer == 2 mode |= $04;
if global.saxtonhale != noone or global.saxtonmode mode |= $08;
if global.chat == 1 mode |= $10;
if global.chat == 2 mode |= $20;
if global.seriousServer mode |= $40;

write_ushort(lobbyBuffer, mode);
if(global.serverPassword != "")
    write_ushort(lobbyBuffer, 1);
else
    write_ushort(lobbyBuffer, 0);

write_ushort(lobbyBuffer, 7); // Number of Key/Value pairs that follow
writeKeyValue(lobbyBuffer, "name", global.serverName);
writeKeyValue(lobbyBuffer, "game", "Randomizer mod");
writeKeyValue(lobbyBuffer, "game_short", "RM");
writeKeyValue(lobbyBuffer, "game_ver", GAME_VERSION_STRING);
writeKeyValue(lobbyBuffer, "game_url", "http://www.ganggarrison.com/forums/index.php?topic=38176.0");

writeKeyValue(lobbyBuffer, "map",global.currentMap);
write_ubyte(lobbyBuffer, string_length("protocol_id"));
write_string(lobbyBuffer, "protocol_id");
write_ushort(lobbyBuffer, 16);
write_buffer(lobbyBuffer, global.protocolUuid);

udp_send(lobbyBuffer, LOBBY_SERVER_HOST, LOBBY_SERVER_PORT);
buffer_destroy(lobbyBuffer);





