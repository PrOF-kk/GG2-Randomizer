/*
All built-in console commands are defined here, big strings approaching.
*/

global.commandDict = ds_map_create();
global.needName = ds_list_create();

//extremely shitty workaround....
global.doublequote='"';

ds_map_add(global.commandDict, "list", "
    ConsoleWindow.hidden = true;
    instance_create(0,0,PlayerList);
");

ds_map_add(global.commandDict, "players", "
    var list;
    ConsoleWindow.hidden = true;
    list = instance_create(0,0,PlayerList);
    list.showPlayers = true;
    list.editing = 1 
    list.needTarget = true;
");       

ds_map_add(global.commandDict, "kick","  
    var target;
    target = getTarget(input[1]);  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } else if global.isHost {
        if target == Player printChat('p[CONSOLE] All players have been kicked.');
        else SendChat(target.name+' has been kicked.',2);
        with(target) {
            if id != global.myself {
                socket_destroy_abortive(socket);
                socket = -1;
            }
        }
    } else if global.isRcon {
        var message;
        if target == Player message = 'kick all';
        else message = 'kick '+string(ds_list_find_index(global.players,target));
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket,message);
        printChat('p[CONSOLE] Sent <'+message+'> to server.');
    } else printChat('p[CONSOLE] No rcon access!');
");
ds_list_add(global.needName,"kick");

ds_map_add(global.commandDict, "classlimit","
    if global.isHost { 
        var class;
        class = getClass(input[1]);
        if class != -1 {
            if string_digits(input[2]) != '' {
                global.Classlimit[class] = input[2];
                ini_open('classlimits.gg2');
                ini_write_string('Class','Scout',string(global.Classlimit[0]));
                ini_write_string('Class','Soldier',string(global.Classlimit[1]));
                ini_write_string('Class','Sniper',string(global.Classlimit[2]));
                ini_write_string('Class','Demoman',string(global.Classlimit[3]));
                ini_write_string('Class','Medic',string(global.Classlimit[4]));
                ini_write_string('Class','Engineer',string(global.Classlimit[5]));
                ini_write_string('Class','Heavy',string(global.Classlimit[6]));
                ini_write_string('Class','Spy',string(global.Classlimit[7]));
                ini_write_string('Class','Pyro',string(global.Classlimit[8]));
                ini_write_string('Class','Quote',string(global.Classlimit[9]));
                ini_close();
                printChat('p[CONSOLE] '+input[1]+'-classlimit is set to ' + string(global.Classlimit[class]));
            } else printChat('p[CONSOLE] '+input[1]+'-classlimit is ' + string(global.Classlimit[class]));
        }
    }else if global.isRcon printChat('p[CONSOLE] Unavailable command.');
    else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "saxtonhale","  
    var target;
    target = getTarget(input[1]);
    if input[1] == '' {
        var list;
        list = ds_list_create();
        with(Player) if team != TEAM_SPECTATOR ds_list_add(list,id);
        if ds_list_size(list) > 1 {
            ds_list_shuffle(list);
            target = ds_list_find_value(list,0);
        }
        ds_list_destroy(list);
    }  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } else if target == Player {
        printChat('p[CONSOLE] There can be only one!');
        exit;
    } else if global.isHost {
        SendChat(target.name+' Became HAXTON SAAAAAAAAAAAAAALE!',2);
        write_ubyte(global.eventBuffer, SAXTON_HALE);
        write_ubyte(global.eventBuffer, ds_list_find_index(global.players,target));
        //global.saxtonHale = true;
        if instance_exists(ArenaHUD) ArenaHUD.allowswap=true;
        with(Player) {
            if(object != -1) doEventPlayerDeath(id, -1, -1, KILL_BOX, 1);
            if team != TEAM_SPECTATOR {
                if id == target {
                    team = TEAM_BLUE;
                    class = CLASS_SOLDIER;
                    loaded1 = 8;
                    loaded2 = 12;
                    isSaxtonHale = true;
                } else team = TEAM_RED;
                if canSpawn == 0 {
                    canSpawn = 1;
                    alarm[0] = 2;
                }
                alarm[5] = 1;
            }
        }
    } else if global.isRcon {
        var message; 
        if target == Player {
            printChat('p[CONSOLE] There can be only one!');
            exit;
        }
        if input[1] != '' message = 'saxtonhale '+string(ds_list_find_index(global.players,target));
        else message = 'saxtonhale';
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket,message);
        printChat('p[CONSOLE] Sent <'+message+'> to server.');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "teamscramble"," 
    if global.isHost {
        SendChat('Teams have been scrambled!',2);
        var tmpList, teamSize, i, player;
        tmpList = ds_list_create();
        with(Player) {
            if team != TEAM_SPECTATOR ds_list_add(tmpList,id);
            if object != -1 {
                with(object) instance_destroy();
                object = -1;
            }
        }
        ds_list_shuffle(tmpList);
        teamSize = round(ds_list_size(tmpList)/2);
        i=0;
        while(ds_list_size(tmpList) > i) {
            player = ds_list_find_value(tmpList,i);
            if i < teamSize player.team = TEAM_RED;
            else player.team = TEAM_BLUE;
            ServerPlayerChangeteam(ds_list_find_index(global.players,player), player.team, global.eventBuffer);
            i+=1;
        }
        ds_list_destroy(tmpList);
    } else if global.isRcon {
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,12);
        write_string(global.serverSocket,'teamscramble');
        printChat('p[CONSOLE] Sent <teamscramble> to server.');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "ban","  
    var target;
    target = getTarget(input[1]);  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } else if global.isHost {
        if target == Player printChat('p[CONSOLE] All players have been banned.');
        else SendChat(target.name+' has been banned.',2);
        with(target) {
            if id != global.myself {
                ip = socket_remote_ip(socket);
                ds_list_add(global.banlist, ip);
                socket_destroy_abortive(socket);
                socket = -1;
            }
        }
    } else if global.isRcon {
        var message;
        if target == Player message = 'ban all';
        else message = 'ban '+string(ds_list_find_index(global.players,target));
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket,message);
        printChat('p[CONSOLE] Sent <'+message+'> to server.');
    } else printChat('p[CONSOLE] No rcon access!');
");
ds_list_add(global.needName,"ban");

ds_map_add(global.commandDict, "unban"," 
    if global.isHost { 
        if input[1] == 'all' {
            ds_list_clear(global.banlist);
            printChat('p[CONSOLE] banlist cleared.');
        }else if input[1] == 'last' {
            if ds_list_size(global.banlist) > 0 ds_list_delete(global.banlist,ds_list_size(global.banlist)-1);
            printChat('p[CONSOLE] unbanned the last banned player.');
        } else if real(input[1]) < ds_list_size(global.banlist) {
            ds_list_delete(global.banlist,real(string_digits(input[1])));
            printChat('p[CONSOLE] ip with value ' + input[1] + ' has been unbanned');
        } else printChat('p[CONSOLE] Fatal error during unbanning -- exiting');
    } else if global.isRcon {
        var message;
        message = 'unban '+string_digits(input[1]);
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket,message);
        printChat('p[CONSOLE] sent request to server');
    } else printChat('p[CONSOLE] Fatal error during unbanning -- exiting');
");

ds_map_add(global.commandDict, "mute","  
    var target;
    target = getTarget(input[1]);  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } else if global.isHost {
        with(target) {
            if other.input[2] == ''  {
                muted = !muted;
                if muted {
                    if ds_list_find_index(global.unmutelist, socket_remote_ip(socket)) >= 0 ds_list_delete(global.unmutelist,ds_list_find_index(global.unmutelist,socket_remote_ip(socket)));
                    if ds_list_find_index(global.mutelist, socket_remote_ip(socket)) < 0 ds_list_add(global.mutelist,socket_remote_ip(socket));
                } else {
                    if ds_list_find_index(global.mutelist, socket_remote_ip(socket)) >= 0 ds_list_delete(global.mutelist,ds_list_find_index(global.mutelist,socket_remote_ip(socket)));
                    if ds_list_find_index(global.unmutelist, socket_remote_ip(socket)) < 0 ds_list_add(global.unmutelist,socket_remote_ip(socket));
                }
            } else if other.input[2] == '1' {
                muted = true;
                if ds_list_find_index(global.unmutelist, socket_remote_ip(socket)) >= 0 ds_list_delete(global.unmutelist,ds_list_find_index(global.unmutelist,socket_remote_ip(socket)));
                if ds_list_find_index(global.mutelist, socket_remote_ip(socket)) < 0 ds_list_add(global.mutelist,socket_remote_ip(socket));
            } else {
                muted = false;
                if ds_list_find_index(global.mutelist, socket_remote_ip(socket)) >= 0 ds_list_delete(global.mutelist,ds_list_find_index(global.mutelist,socket_remote_ip(socket)));
                if ds_list_find_index(global.unmutelist, socket_remote_ip(socket)) < 0 ds_list_add(global.unmutelist,socket_remote_ip(socket));
            }
        }
        if target != Player {
            if target.muted SendChat(target.name+' has been muted.',2);
            else SendChat(target.name+' has been unmuted.',2);
        } else {
            if input[2] == '' SendChat('Toggled mute for all players.',2);
            else if input[2] == '1' SendChat('Muted all players.',2);
            else SendChat('Unmuted all players',2);
        } 
    } else if global.isRcon {
        if target == Player message = 'mute all '+input[2];
        else message = 'mute '+string(ds_list_find_index(global.players,target))+' '+input[2];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket,message);
        printChat('p[CONSOLE] sent request to server');
    } else {
        with(target) {
            if other.input[2] == ''  muted = !muted;
            else if other.input[2] == '1' muted = true;
            else muted = false;
        }
        if target != Player {
            if target.muted printChat('p[CONSOLE] '+target.name+' has been muted.');
            else printChat('p[CONSOLE] '+target.name+' has been unmuted.');
        } else {
            if input[2] == '' printChat('Toggled mute for all players.');
            else if input[2] == 1 printChat('Muted all players.');
            else printChat('Unmuted all players');
        } 
    }       
");
ds_list_add(global.needName,"mute");

ds_map_add(global.commandDict, "rcon","
    if input[1] == 'force' && !global.myself.rcon {
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length('forcercon'));
        write_string(global.serverSocket,'forcercon');
        printChat('p[CONSOLE] Sent request to server');
        exit;
    }
    var target;
    target = getTarget(input[1]);  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } else if global.isHost {
        with(target) {
            if other.input[2] == '' rcon = !rcon;            
            else if other.input[2] == '1' rcon = true;
            else other.rcon = false;
            
            if rcon {
                if ds_list_find_index(global.rconlist, socket_remote_ip(socket)) < 0 ds_list_add(global.rconlist,socket_remote_ip(socket));
            } else if ds_list_find_index(global.rconlist, socket_remote_ip(socket)) >= 0 ds_list_delete(global.rconlist,ds_list_find_index(global.rconlist,socket_remote_ip(socket)));    
        }
        var message;
        if target == Player {
            if input[2] == '' message = 'Toggled rcon for all players!';
            else if input[2] == 1 message = 'All players are now a rcon! (this is going to end badly)';
            else message = 'All players are no longer a rcon.';
        } else {
            if target.rcon message = target.name + ' is now a rcon!';
            else message = target.name + ' is no longer a rcon.';
        }
        SendChat(message,2);
    } else printChat('p[CONSOLE] No rcon access!');
");
ds_list_add(global.needName,"rcon");

ds_map_add(global.commandDict, "motd", "
    if input[1] == '' {
        if global.isHost printChat('p' + global.motd);
        else printChat('p' + global.serverMotd)
    } else if global.isHost {
        global.motd = input[1];
        printChat('p[CONSOLE] Motd updated to: ' + global.motd);
        ini_open('gg2.ini');
        ini_write_string('Server', 'motd', global.motd);
        ini_close();
        write_ubyte(global.eventBuffer, MOTD_UPDATE);
        write_ubyte(global.eventBuffer,string_length(global.motd));
        write_string(global.eventBuffer,global.motd);
    } else if global.isRcon {
        var message;
        message = 'motd '+global.doublequote+input[1]+global.doublequote;
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket,message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "medieval", "
    if global.isHost {
        if input[1] == '1' global.medieval = true;
        else if input[1] == '0' global.medieval = false;
        else global.medieval = !global.medieval;
        
        if global.medieval SendChat('Gamemode changed. Activated medieval mode.',2);
        else SendChat('Gamemode changed. Disabled medieval mode.',2);
        
        global.newMap = global.currentMap;
        with(Player) class = CLASS_NULL; //force the player to resend their loadout
        
        if input[2] == '0' global.winners = TEAM_RED;
        else if input[2] == '1' global.winners = TEAM_BLUE;
        else global.winners = TEAM_SPECTATOR;
    } else if global.isRcon {
        var message;
        message = 'medieval '+ input[1] + ' ' + input[2];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "randomizer", "
    if global.isHost {
        if input[1] == '1' global.randomizer = 1;
        else if input[1] == '0' global.randomizer = 0;
        else global.randomizer = 2;
        
        if global.randomizer == 1 SendChat('Gamemode changed. Activated randomizer mode.',2);
        else if global.randomizer == 2 SendChat('Gamemode changed. Activated randomizer mode (arena only).',2);
        else SendChat('Gamemode changed. Disabled randomizer mode.',2);
        
        global.newMap = global.currentMap;
        with(Player) class = CLASS_NULL;
        
        if input[2] == '0' global.winners = TEAM_RED;
        else if input[2] == '1' global.winners = TEAM_BLUE;
        else global.winners = TEAM_SPECTATOR;
    } else if global.isRcon {
        var message;
        message = 'randomizer '+ input[1] + ' ' + input[2];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "shuffle", "
    if global.isHost {
        ds_list_shuffle(global.map_rotation);
        printChat('p[CONSOLE] Shuffled map rotation');
    } else if global.isRcon {
        var message;
        message = 'shuffle '+ input[1];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "team", "
    var target;
    target = getTarget(input[1]);  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } else if global.isHost {
        with(target) {
            if object != -1 {
                sendEventPlayerDeath(id, -1, -1, FINISHED_OFF);
                doEventPlayerDeath(id, -1, -1, FINISHED_OFF);
                alarm[5] = 1;
            } else if alarm[5]<=0 alarm[5] = 1;
            if other.input[2] == '1' team = TEAM_BLUE;
            else if other.input[2] == '0' team = TEAM_RED;
            else team = TEAM_SPECTATOR;
            ServerPlayerChangeteam(ds_list_find_index(global.players,id), team, global.eventBuffer);
        }
        if target == Player printChat('p[CONSOLE] Moved all players to team ' + input[2]);
        else printChat('p[CONSOLE] Moved '+target.name+' to team ' + string(target.team));
    } else if global.isRcon {
            var message;
            if target != Player message = 'team '+ string(ds_list_find_index(global.players,target)) + ' ' + input[2];
            else message = 'team all ' + input[2];
            write_ubyte(global.serverSocket, SERVER_MESSAGE);
            write_ubyte(global.serverSocket,string_length(message));
            write_string(global.serverSocket, message);
            printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");
ds_list_add(global.needName,"team");

ds_map_add(global.commandDict, "class", "
    var target, type;
    target = getTarget(input[1]);  
    if target == -1 {
        printChat('p[CONSOLE] Player does not exist -- exiting');
        exit;
    } 
    type = getClass(input[2]);
    if type == -1 {
        printChat('p[CONSOLE] Class does not exist -- exiting');
        exit;
    } else if global.isHost {
        with(target) {
            if object != -1 {
                sendEventPlayerDeath(id, -1, -1, FINISHED_OFF);
                doEventPlayerDeath(id, -1, -1, FINISHED_OFF);
                alarm[5] = 1;
            } else if alarm[5]<=0 alarm[5] = 1;
            class = type;
            loaded1 = class*10;
            loaded2 = class*10+5;
            ServerPlayerChangeclass(ds_list_find_index(global.players,id), class, global.eventBuffer);
        }
        if target == Player printChat('p[CONSOLE] Change all players to class ' + input[2]);
        else printChat('p[CONSOLE] changed '+target.name+ 's class to ' + input[2]);
    } else if global.isRcon {
            var message;
            if target != Player message = 'class '+ string(ds_list_find_index(global.players,target)) + ' ' + input[2];
            else message = 'class all ' + input[2];
            write_ubyte(global.serverSocket, SERVER_MESSAGE);
            write_ubyte(global.serverSocket,string_length(message));
            write_string(global.serverSocket, message);
            printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");
ds_list_add(global.needName,"class");

ds_map_add(global.commandDict, "rconpass", "
    if global.isHost {
        if input[1] == '' {
            printChat('p[CONSOLE] the rcon password has been disabled.');
            global.rconPass = '';
        } else {
            printChat('p[CONSOLE] the rcon password has been changed to: '+input[1]);
            global.rconPass = input[1];
            ini_open('gg2.ini');
            ini_write_string('Server', 'rcon password', global.rconPass);
            ini_close();
        }
    } else if global.isRcon {
        printChat('p[CONSOLE] You are not allowed to execute this command.');
    } else {
        message = 'rconpass '+ input[1];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    }
");

ds_map_add(global.commandDict, "chat","
    if global.isHost {
        if input[1] == '1' global.chat = 1
        else if input[1] == '2' global.chat = 2;
        else global.chat = 0;
        ini_open('gg2.ini');
        ini_write_real('Server', 'Chat', global.chat);
        ini_close();
        if global.chat == 1 SendChat('Team chat enabled.',2);
        else if global.chat == 2 SendChat('Global chat enabled',2);
        else SendChat('chat disabled',2);
     } else if global.isRcon {
        message = 'chat '+ input[1];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "endround", "
    if global.isHost {
        SendChat('Round ended by host.',2);
        if input[1] == '0' global.winners = TEAM_RED;
        else if input[1] == '1' global.winners = TEAM_BLUE;
        else if input[1] == '2' global.winners = TEAM_SPECTATOR;
        else if input[1] != '' && file_exists('Maps/' + input[1] + '.png') {
            global.newMap = input[1];
            printChat('p[CONSOLE] Going to: '+input[1]);
        } else if input[1] != '' printChat('p[CONSOLE] Unknown map, going to next map in rotation.');
               
        if input[2] == '0' global.winners = TEAM_RED;
        else if input[2] == '1' global.winners = TEAM_BLUE;
        else global.winners = TEAM_SPECTATOR;
    } else if global.isRcon {
        var message;
        message = 'endround '+ input[1] + ' ' + input[2];
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
");

ds_map_add(global.commandDict, "nextmap", "
    if global.isHost {
        if input[1] == '' {
            var index;
            if(global.currentMapIndex+1 == ds_list_size(global.map_rotation)) index = 0;
            else index = global.currentMapIndex+1;
            printChat('p[CONSOLE] Next map: '+ds_list_find_value(global.map_rotation, index));
        } else if file_exists('Maps/' + input[1] + '.png') {
            global.newMap = input[1];
            printChat('p[CONSOLE] Next map set to: ' + input[1] );
        }
        else printChat('p[CONSOLE] Unknown map.');
    } else printChat('p[CONSOLE] Unavailable command!');
");

ds_map_add(global.commandDict, "respawntime", "
    if global.isHost {
        global.Server_Respawntime = max(1, real(input[1])*30);
        SendChat('Set respawn time to '+string(real(input[1]))+' seconds.',2);
    } else if global.isRcon {
        var message;
        message = 'respawntime '+ string(real(input[1]));
        write_ubyte(global.serverSocket, SERVER_MESSAGE);
        write_ubyte(global.serverSocket,string_length(message));
        write_string(global.serverSocket, message);
        printChat('p[CONSOLE] Sent request to server');
    } else printChat('p[CONSOLE] No rcon access!');
    
");

ds_map_add(global.commandDict, "haxxy","
    if global.myself.RandomizerWinner == 1 {
        write_ubyte(global.serverSocket, GIMME_HAXXY);
    } else printChat('p[CONSOLE] haha. Good try, but no.');
");

//RM 4.0

ds_map_add(global.commandDict, "execute", "
    if global.isHost {
        var stdout;
        stdout = execute_string(input[1]);
        printChat('p[CONSOLE] Execute successful, returned ' + string(stdout));
    } else printChat('p[CONSOLE] Unavailable command!');
");
