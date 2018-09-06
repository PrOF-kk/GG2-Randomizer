// argument0 = message
//argument1 = teamchat or not, 2 means console message
if argument1 == 1 {
    write_ubyte(global.serverSocket, TEAM_CHAT);
    write_ubyte(global.serverSocket, string_length(argument0));
    write_string(global.serverSocket, argument0);
    socket_send(global.serverSocket);
} else if argument1 == 0 {
    write_ubyte(global.serverSocket, CHAT);
    write_ubyte(global.serverSocket, string_length(argument0));
    write_string(global.serverSocket, argument0);
    socket_send(global.serverSocket);
} else if global.isHost {
    var message;
    message = 'p[CONSOLE] ' + argument0;
    write_ubyte(global.eventBuffer, CHAT);
    write_ubyte(global.eventBuffer, string_length(message));
    write_string(global.eventBuffer, message);
    printChat(message);
}
