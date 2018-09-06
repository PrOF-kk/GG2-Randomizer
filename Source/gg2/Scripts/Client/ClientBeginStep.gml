// receive and interpret the server's message(s)
var i, playerObject, playerID, player, otherPlayerID, otherPlayer, sameVersion, buffer;

if(tcp_eof(global.serverSocket)) {
    if(gotServerHello)
        show_message("You have been disconnected from the server.");
    else
        show_message("Unable to connect to the server.");
    instance_destroy();
    exit;
}

if(downloadingMap)
{
    while(tcp_receive(global.serverSocket, min(1024, downloadMapBytes-buffer_size(downloadMapBuffer))))
    {
        write_buffer(downloadMapBuffer, global.serverSocket);
        if(buffer_size(downloadMapBuffer) == downloadMapBytes)
        {
            write_buffer_to_file(downloadMapBuffer, "Maps/" + downloadMapName + ".png");
            downloadingMap = false;
            buffer_destroy(downloadMapBuffer);
            downloadMapBuffer = -1;
            exit;
        }
    }
    if(keyboard_check(vk_escape))
        instance_destroy();
    exit;
}

roomchange = false;
do {
    if(tcp_receive(global.serverSocket,1)) {
        switch(read_ubyte(global.serverSocket)) {
        case HELLO:
            gotServerHello = true;
            global.joinedServerName = receivestring(global.serverSocket, 1);
            downloadMapName = receivestring(global.serverSocket, 1);
            advertisedMapMd5 = receivestring(global.serverSocket, 1);
            global.serverMotd = receivestring(global.serverSocket, 1);
            
            if(string_pos("/", downloadMapName) != 0 or string_pos("\", downloadMapName) != 0)
            {
                show_message("Server sent illegal map name: "+downloadMapName);
                instance_destroy();
                exit;
            }
            
            if(advertisedMapMd5 != "")
            {
                var download;
                download = not file_exists("Maps/" + downloadMapName + ".png");
                if(!download and CustomMapGetMapMD5(downloadMapName) != advertisedMapMd5)
                {
                    if(show_question("The server's copy of the map (" + downloadMapName + ") differs from ours.#Would you like to download this server's version of the map?"))
                        download = true;
                    else
                    {
                        instance_destroy();
                        exit;
                    }
                }
                
                if(download)
                {
                    write_ubyte(global.serverSocket, DOWNLOAD_MAP);
                    socket_send(global.serverSocket);
                    receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
                    downloadMapBytes = read_uint(global.tempBuffer);
                    downloadMapBuffer = buffer_create();
                    downloadingMap = true;
                    room_goto_fix(DownloadRoom);
                    roomchange=true;
                }
            }
            ClientPlayerJoin(global.serverSocket);
            if(global.haxxyKey != "")
                write_byte(global.serverSocket, I_AM_A_HAXXY_WINNER);
            if global.randomizerKey != "" 
                write_byte(global.serverSocket, I_AM_RANDOMIZER_DEV);
            socket_send(global.serverSocket);
            break;
            
        case JOIN_UPDATE:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            global.playerID = read_ubyte(global.tempBuffer);
            global.currentMapArea = read_ubyte(global.tempBuffer);
            break;
        
        case FULL_UPDATE:
            deserializeState(FULL_UPDATE);
            break;
        
        case QUICK_UPDATE:
            deserializeState(QUICK_UPDATE);
            break;
             
        case CAPS_UPDATE:
            deserializeState(CAPS_UPDATE);
            break;
                  
        case INPUTSTATE:
            deserializeState(INPUTSTATE);
            break;  
        
        case CHAT:
            var length, message;
            receiveCompleteMessage(global.serverSocket, 1, global.tempBuffer);
            length = read_ubyte(global.tempBuffer);
            receiveCompleteMessage(global.serverSocket, length, global.tempBuffer);
            message = read_string(global.tempBuffer, length);
            printChat(message);
            break;           
        
        case PLAYER_JOIN:
            player = instance_create(0,0,Player);
            player.name = receivestring(global.serverSocket, 1);
                  
            ds_list_add(global.players, player);
            if(ds_list_size(global.players)-1 == global.playerID) {
                global.myself = player;
                instance_create(0,0,PlayerControl);
            }
            break;
            
        case PLAYER_LEAVE:
            // Delete player from the game, adjust own ID accordingly
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            playerID = read_ubyte(global.tempBuffer);
            player = ds_list_find_value(global.players, playerID);
            removePlayer(player);
            if(playerID < global.playerID) {
                global.playerID -= 1;
            }
            break;
                                   
        case PLAYER_DEATH:
            var causeOfDeath, assistantPlayerID, assistantPlayer, damageCrit;
            receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
            playerID = read_ubyte(global.tempBuffer);
            otherPlayerID = read_ubyte(global.tempBuffer);
            assistantPlayerID = read_ubyte(global.tempBuffer);
            causeOfDeath = read_ubyte(global.tempBuffer);
            damageCrit = read_ubyte(global.tempBuffer)/100;
                  
            player = ds_list_find_value(global.players, playerID);
            
            otherPlayer = noone;
            if(otherPlayerID != 255)
                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
            
            assistantPlayer = noone;
            if(assistantPlayerID != 255)
                assistantPlayer = ds_list_find_value(global.players, assistantPlayerID);
            
            doEventPlayerDeath(player, otherPlayer, assistantPlayer, causeOfDeath, damageCrit);
            break;
             
        case BALANCE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            balanceplayer=read_ubyte(global.tempBuffer);
            if balanceplayer == 255 {
                if !instance_exists(Balancer) instance_create(x,y,Balancer);
                with(Balancer) notice=0;
            } else {
                player = ds_list_find_value(global.players, balanceplayer);
                if(player.object != -1) {
                    with(player.object) {
                        instance_destroy();
                    }
                    player.object = -1;
                }
                if(player.team==TEAM_RED) {
                    player.team = TEAM_BLUE;
                } else {
                    player.team = TEAM_RED;
                }
                if !instance_exists(Balancer) instance_create(x,y,Balancer);
                Balancer.name=player.name;
                with (Balancer) notice=1;
            }
            break;
                  
        case PLAYER_CHANGETEAM:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.team = read_ubyte(global.tempBuffer);
            break;
             
        case PLAYER_CHANGECLASS:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.class = read_ubyte(global.tempBuffer);
            player.loaded1 = player.class*10;
            player.loaded2 = player.class*10+5;
            break;  
       
       case SAXTON_HALE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            with(Player) {
                if(object != -1) doEventPlayerDeath(id, -1, -1, KILL_BOX, 1);
                if team != TEAM_SPECTATOR {
                    if id == player {
                        team = TEAM_BLUE;
                        class = CLASS_SOLDIER;
                        loaded1 = 10;
                        loaded2 = 15;
                        isSaxtonHale = true;
                    } else team = TEAM_RED;
                    //alarm[5] = 1;
                }
            }
            break;           
        
        case PLAYER_CHANGENAME:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            player.name = receivestring(global.serverSocket, 1);
            if player=global.myself {
                global.playerName=player.name
            }
            break;
                 
        case PLAYER_SPAWN:
            receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventSpawn(player, read_ubyte(global.tempBuffer), read_ubyte(global.tempBuffer));
            break;
              
        case CHAT_BUBBLE:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            setChatBubble(player, read_ubyte(global.tempBuffer));
            break;
        
        case DETONATION_POS:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doDetonation(player, 2*read_ubyte(global.tempBuffer));
            break;
        
        case NAPALM_EXPLOSION:
            receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doNapalm(player, read_ushort(global.tempBuffer), read_ushort(global.tempBuffer));
            break;
        
        case SENTRY_PICKUP:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doPickUp(player);
            break;
        
        case SENTRY_PLACE:
            receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            player.object.sentrylevel = read_ubyte(global.tempBuffer);
            player.object.sentryhp = read_ubyte(global.tempBuffer);
            player.object.sentryupgraded = read_ubyte(global.tempBuffer);

            doPlaceSentry(player);
            break;
            
            case PHLOG_ACTIVE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.object != -1 {
                player.object.currentWeapon.critting = 300;
                player.object.hp = player.object.maxHp;
                player.object.overheal = 25;
                with(player.object) {
                    if(!taunting and !omnomnomnom && !buffing && !stunned) && !isSaxtonHale {
                        if (!cloak && cloakAlpha == 1) {
                            taunting=true;
                            var i;
                            i=0;
                            if player.class == CLASS_PYRO i= 2;
                            tauntSprite = tauntsprite[i];
                            if (team==TEAM_RED) {
                                tauntindex=0;
                                tauntend=tauntlength[i]-1;
                            }
                            else if (team==TEAM_BLUE) {
                                tauntindex=tauntlength[i];
                                tauntend=tauntlength[i]*2-1;
                            }
                            image_speed=tauntspeed;
                        } 
                    }
                }
            }
            break;
        
        case SENTRY_UPGRADE:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doSentryUpgrade(player, read_ubyte(global.tempBuffer));
            break;
            
        case BALL_STUN:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventBallstun(player,read_ubyte(global.tempBuffer));
            break;
            
        case STUN:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            player2 = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventStun(player,player2);
            break;
            
        case MOTD_UPDATE:
            var length, motd;
            receiveCompleteMessage(global.serverSocket, 1, global.tempBuffer);
            length = read_ubyte(global.tempBuffer);
            receiveCompleteMessage(global.serverSocket, length, global.tempBuffer);
            global.serverMotd = read_string(global.tempBuffer, length);
            printChat("p" + global.serverMotd);
            break;
            
        case SAP_TOGGLE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.sentry != -1 {
                if player.sentry.sapped == 0 {
                    player.sentry.sapped = 4;
                    if player.object != -1 setChatBubble(player, 61);
                } else player.sentry.sapped = 0;
            }
            break;
        
        case WEAPON_SWAP:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.object != -1 {
                with player.object {
                    weaponSwitch(read_ubyte(global.tempBuffer));
                }
            }
            break;
        
        case LOADOUT_SYNC:
            receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            player.loaded1 = read_ubyte(global.tempBuffer);
            player.loaded2 = read_ubyte(global.tempBuffer);
            break;
        
        case RANDOMIZER_LOADOUT_SYNC:
            receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            player.loaded1 = read_ubyte(global.tempBuffer);
            player.loaded2 = read_ubyte(global.tempBuffer);
            if player == global.myself { 
                if instance_exists(NoticeO) with NoticeO instance_destroy();
                instance_create(0,0,NoticeO);
                with NoticeO {
                    notice = NOTICE_MISC;
                    text = "Randomizer loadout: (1) "+global.name[player.loaded1]+" + (2) "+global.name[player.loaded2]+".";
                }
            }
            break;
             
        case BUILD_SENTRY:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.sentry == -1 {
                buildSentry(player,read_ubyte(global.tempBuffer));
            }
            break;
              
        case DESTROY_SENTRY:
            receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
            playerID = read_ubyte(global.tempBuffer);
            otherPlayerID = read_ubyte(global.tempBuffer);
            assistantPlayerID = read_ubyte(global.tempBuffer);
            causeOfDeath = read_ubyte(global.tempBuffer);
            damageCrit = read_ubyte(global.tempBuffer)/100;
            
            player = ds_list_find_value(global.players, playerID);
            if(otherPlayerID == 255) {
                doEventDestruction(player, -1, -1, causeOfDeath, 1);
            } else {
                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
                if (assistantPlayerID == 255) {
                    doEventDestruction(player, otherPlayer, -1, causeOfDeath, damageCrit);
                } else {
                    assistantPlayer = ds_list_find_value(global.players, assistantPlayerID);
                    doEventDestruction(player, otherPlayer, assistantPlayer, causeOfDeath, damageCrit);
                }
            }
            break;
                      
        case GRAB_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventGrabIntel(player);
            break;
      
        case SCORE_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventScoreIntel(player);
            break;
      
        case DROP_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.object != -1 {
                with player.object event_user(5); 
            }
            break;
            
        case RETURN_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            doEventReturnIntel(read_ubyte(global.tempBuffer));
            break;
  
        case GENERATOR_DESTROY:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            team = read_ubyte(global.tempBuffer);
            doEventGeneratorDestroy(team);
            break;
      
        case UBER_CHARGED:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventUberReady(player);
            break;
  
        case UBER:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            doEventUber(player);
            break;    
  
        /*case OMNOMNOMNOM:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    omnomnomnom=true;
                    if(player.team == TEAM_RED) {
                        omnomnomnomindex=0;
                        omnomnomnomend=31;
                    } else if(player.team==TEAM_BLUE) {
                        omnomnomnomindex=32;
                        omnomnomnomend=63;
                    }
                    xscale=image_xscale; 
                } 
            }
            break;*/
      
        case TOGGLE_ZOOM:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, read_ubyte(global.tempBuffer));
            if player.object != -1 {
                toggleZoom(player.object);
            }
            break;
                                         
        case PASSWORD_REQUEST:
            if(!usePreviousPwd)
                global.clientPassword = get_string("Enter Password:", "");
            write_ubyte(global.serverSocket, string_length(global.clientPassword));
            write_string(global.serverSocket, global.clientPassword);
            socket_send(global.serverSocket);
            break;
       
        case PASSWORD_WRONG:                                    
            show_message("Incorrect Password.");
            instance_destroy();
            exit;
        
        case INCOMPATIBLE_PROTOCOL:
            show_message("Incompatible server protocol version.");
            instance_destroy();
            exit;
            
        case KICK:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            reason = read_ubyte(global.tempBuffer);
            //show_message(string(reason));
            if reason == KICK_NAME kickReason = "Name Exploit";
            else if reason == KICK_LOADOUT kickReason = "Loadout Exploit";
            else kickReason = "";
            show_message("You have been kicked from the server. "+kickReason+".");
            instance_destroy();
            exit;
              
        case ARENA_ENDROUND:
            with ArenaHUD clientArenaEndRound();
            break;   
        
        case ARENA_RESTART:
            doEventArenaRestart();
            break;
            
        case UNLOCKCP:
            doEventUnlockCP();
            break;
                   
        case MAP_END:
            global.nextMap=receivestring(global.serverSocket, 1);
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            global.winners=read_ubyte(global.tempBuffer);
            global.currentMapArea=read_ubyte(global.tempBuffer);
            global.mapchanging = true;
            if !instance_exists(ScoreTableController) instance_create(0,0,ScoreTableController);
            instance_create(0,0,WinBanner);
            break;

        case CHANGE_MAP:
            roomchange=true;
            global.mapchanging = false;
            global.currentMap = receivestring(global.serverSocket, 1);
            global.currentMapMD5 = receivestring(global.serverSocket, 1);
            if(global.currentMapMD5 == "") { // if this is an internal map (signified by the lack of an md5)
                if(gotoInternalMapRoom(global.currentMap) != 0) {
                    show_message("Error:#Server went to invalid internal map: " + global.currentMap + "#Exiting.");
                    instance_destroy();
                    exit;
                }
            } else { // it's an external map
                if(string_pos("/", global.currentMap) != 0 or string_pos("\", global.currentMap) != 0)
                {
                    show_message("Server sent illegal map name: "+global.currentMap);
                    instance_destroy();
                    exit;
                }
                if(!file_exists("Maps/" + global.currentMap + ".png") or CustomMapGetMapMD5(global.currentMap) != global.currentMapMD5)
                {   // Reconnect to the server to download the map
                    var oldReturnRoom;
                    oldReturnRoom = returnRoom;
                    returnRoom = DownloadRoom;
                    event_perform(ev_destroy,0);
                    ClientCreate();
                    returnRoom = oldReturnRoom;
                    usePreviousPwd = true;
                    exit;
                }
                room_goto_fix(CustomMapRoom);
            }
                 
            for(i=0; i<ds_list_size(global.players); i+=1) {
                player = ds_list_find_value(global.players, i);
                if global.currentMapArea == 1 { 
                    player.stats[KILLS] = 0;
                    player.stats[DEATHS] = 0;
                    player.stats[CAPS] = 0;
                    player.stats[ASSISTS] = 0;
                    player.stats[DESTRUCTION] = 0;
                    player.stats[STABS] = 0;
                    player.stats[HEALING] = 0;
                    player.stats[DEFENSES] = 0;
                    player.stats[INVULNS] = 0;
                    player.stats[BONUS] = 0;
                    player.stats[DOMINATIONS] = 0;
                    player.stats[REVENGE] = 0;
                    player.stats[POINTS] = 0;
                    player.roundStats[KILLS] = 0;
                    player.roundStats[DEATHS] = 0;
                    player.roundStats[CAPS] = 0;
                    player.roundStats[ASSISTS] = 0;
                    player.roundStats[DESTRUCTION] = 0;
                    player.roundStats[STABS] = 0;
                    player.roundStats[HEALING] = 0;
                    player.roundStats[DEFENSES] = 0;
                    player.roundStats[INVULNS] = 0;
                    player.roundStats[BONUS] = 0;
                    player.roundStats[DOMINATIONS] = 0;
                    player.roundStats[REVENGE] = 0;
                    player.roundStats[POINTS] = 0;
                    player.team = TEAM_SPECTATOR;
                }
            }
            break;
        
        case SERVER_FULL:
            show_message("The server is full.");
            instance_destroy();
            exit;
        
        case RANDOMIZER_CHALLENGE:
            receiveCompleteMessage(global.serverSocket,16,global.tempBuffer);
            write_ubyte(global.serverSocket, RANDOMIZER_RESPONSE);
            for(i=1;i<=16;i+=1)
                write_ubyte(global.serverSocket, read_ubyte(global.tempBuffer) ^ ord(string_char_at(global.randomizerKey, i)));
            socket_send(global.serverSocket);
            break;
            
        case HAXXY_CHALLENGE_CODE:
            receiveCompleteMessage(global.serverSocket,16,global.tempBuffer);
            write_ubyte(global.serverSocket, HAXXY_CHALLENGE_RESPONSE);
            for(i=1;i<=16;i+=1)
                write_ubyte(global.serverSocket, read_ubyte(global.tempBuffer) ^ ord(string_char_at(global.haxxyKey, i)));
            socket_send(global.serverSocket);
            break;
        
        default:
            show_message("The Server sent unexpected data");
            game_end();
            exit;
        }
    } else {
        break;
    }
} until(roomchange);