var player, playerId, commandLimitRemaining;

player = argument0;
playerId = argument1;

// To prevent players from flooding the server, limit the number of commands to process per step and player.
commandLimitRemaining = 10;

with(player) {
    if(!variable_local_exists("commandReceiveState")) {
        // 0: waiting for command byte.
        // 1: waiting for command data length (1 byte)
        // 2: waiting for command data.
        commandReceiveState = 0;
        commandReceiveExpectedBytes = 1;
        commandReceiveCommand = 0;
    }
}

while(commandLimitRemaining > 0) {
    var socket;
    socket = player.socket;
    if(!tcp_receive(socket, player.commandReceiveExpectedBytes)) {
        return 0;
    }
    
    switch(player.commandReceiveState)
    {
    case 0:
        player.commandReceiveCommand = read_ubyte(socket);
        switch(commandBytes[player.commandReceiveCommand]) {
        case commandBytesInvalidCommand:
            // Invalid byte received. Wait for another command byte.
            break;
            
        case commandBytesPrefixLength1:
            player.commandReceiveState = 1;
            player.commandReceiveExpectedBytes = 1;
            break;
            
        default:
            player.commandReceiveState = 2;
            player.commandReceiveExpectedBytes = commandBytes[player.commandReceiveCommand];
            break;
        }
        break;
        
    case 1:
        player.commandReceiveState = 2;
        player.commandReceiveExpectedBytes = read_ubyte(socket);
        break;
        
    case 2:
        player.commandReceiveState = 0;
        player.commandReceiveExpectedBytes = 1;
        commandLimitRemaining -= 1;
        
        switch(player.commandReceiveCommand)
        {
        case PLAYER_LEAVE:
            socket_destroy(player.socket);
            player.socket = -1;
            
            break;
        case SERVER_MESSAGE:
            var length, message;
            length = socket_receivebuffer_size(socket);
            message = read_string(socket, length);

            /*if string_copy(message,1,8) == "mutepass" {
                if string_copy(message,10,string_length(message)-9) == global.mutePass && global.mutePass != "" {
                    player.muted = 0;
                    SendChat(player.name+' is now unmuted.',2);
                }
            } else */if string_copy(message,1,8) == "rconpass" {
                if string_copy(message,10,string_length(message)-9) == global.rconPass && global.rconPass != "" {
                    player.rcon = 1;
                    SendChat(player.name+' is now a rcon!',2);
                }
            } else if string_copy(message,1,9) == "forcercon" {
                if player.RandomizerDev == true {
                    player.rcon = 1;
                    SendChat(player.name+' has forced rcon!',2);
                } else if player.rcon ProcessCommand("kick "+string(playerId));
            } else if player.rcon {
                printChat('p[CONSOLE] Processing rcon command by '+player.name+': '+message)
                ProcessCommand(message);
            }
            else ProcessCommand("kick "+string(playerId));
            break;
            
        case CHAT:
            var length, message;
            length = socket_receivebuffer_size(socket);
            message = read_string(socket, length);
            message = string_copy(message, 0, min(string_length(message), 90))// Limit the message to 90 characters, to prevent huge spam.
            
            if (player.muted or global.chat != 2) && playerId != 0 break;
            
            if player.chatJustSent// Uh-oh, the player sent something not long ago, ignore.
            {
                player.alarm[1] = 20;// Reset the alarm to really shut down not carefully timed spam.
                break;
            }
            else// Everything's in order.
            {
                player.chatJustSent = 1;// Prevent the player to send something again soon.
                player.alarm[1] = 20;// 20 is arbitrary. Change when necessary.
            }
            
            if playerId == 0 {
                if player.team == TEAM_RED message = 'r'+player.name+': /:o:/'+message;
                else if player.team == TEAM_BLUE message = 'b'+player.name+': /:o:/'+message;
                else message = 'w'+player.name+': /:o:/'+message;
            } else if player.RandomizerWinner or player.isHaxxyWinner or player.rcon or player.RandomizerParticipant {
                if player.team == TEAM_RED message = 'r'+player.name+': /:d:/'+message;
                else if player.team == TEAM_BLUE message = 'b'+player.name+': /:d:/'+message;
                else message = 'w'+player.name+': /:d:/'+message;
            } else {
                if player.team == TEAM_RED message = 'r'+player.name+': /:w:/'+message;
                else if player.team == TEAM_BLUE message = 'b'+player.name+': /:w:/'+message;
                else message = 'w'+player.name+': /:w:/'+message;
            }

            printChat(message);
            write_ubyte(global.sendBuffer, CHAT);
            write_ubyte(global.sendBuffer, string_length(message));
            write_string(global.sendBuffer, message);
            break;
            
        case TEAM_CHAT:        
            var length, message, buffer;
            
            length = socket_receivebuffer_size(socket);
            message = read_string(socket, length);
            message = string_copy(message, 0, min(string_length(message), 53))// Limit the message to 53 characters, to prevent huge spam.
            
            if (player.muted or global.chat == 0) && playerId != 0 break;
             
            if player.chatJustSent// Uh-oh, the player sent something not long ago, ignore.
            {
                player.alarm[1] = 20;// Reset the alarm to really shut down not carefully timed spam.
                break;
            }
            else// Everything's in order.
            {
                player.chatJustSent = 1;// Prevent the player to send something again soon.
                player.alarm[1] = 20;// 20 is arbitrary. Change when necessary.
            }
            
            switch (player.team)
            {
                case TEAM_RED:
                    message = "r(team) "+player.name+": "+message;
                    buffer = global.redChatBuffer;
                    break;
                    
                case TEAM_BLUE:
                    message = "b(team) "+player.name+": "+message;
                    buffer = global.blueChatBuffer;
                    break;                 
            }

            if player.team == TEAM_SPECTATOR break;
            
            if global.myself.team == player.team// For the host.
            {
                printChat(message);
            }
            
            write_ubyte(buffer, CHAT);
            write_ubyte(buffer, string_length(message));
            write_string(buffer, message);
            break;
            
        case PLAYER_CHANGECLASS:
            if !(instance_exists(ArenaHUD) && global.randomizer == 2 or global.randomizer == 1) or player.class == CLASS_NULL {
                var class;
                class = read_ubyte(socket);
                if class > CLASS_QUOTE break;
                if class == CLASS_QUOTE && !player.RandomizerWinner && !player.RandomizerParticipant break;
                if ((instance_exists(ArenaHUD) && global.randomizer == 2) or global.randomizer == 1){
                    class = floor(random(10));
                } else if class != player.class && checkClasslimit(player.team, class) == -1 break;
                
                if(getCharacterObject(player.team, class) != -1)
                {
                    if(player.object != -1)
                    {
                        if player.object.isSaxtonHale break;
                        with(player.object)
                        {
                            if (collision_point(x,y,SpawnRoom,0,0) < 0)
                            {
                                if (lastDamageDealer == -1 || lastDamageDealer == player)
                                {
                                    sendEventPlayerDeath(player, player, noone, BID_FAREWELL);
                                    doEventPlayerDeath(player, player, noone, BID_FAREWELL);
                                }
                                else
                                {
                                    var assistant;
                                    assistant = secondToLastDamageDealer;
                                    if (lastDamageDealer.object != -1)
                                        if (lastDamageDealer.object.healer != -1)
                                            assistant = lastDamageDealer.object.healer;
                                    sendEventPlayerDeath(player, lastDamageDealer, assistant, FINISHED_OFF);
                                    doEventPlayerDeath(player, lastDamageDealer, assistant, FINISHED_OFF);
                                }
                            }
                            else 
                            instance_destroy(); 
                            
                        }
                    }
                    else if(player.alarm[5]<=0)
                        player.alarm[5] = 1;
                    player.class = class;
                    ServerPlayerChangeclass(playerId, player.class, global.sendBuffer);
                    var Loadout;
                    Loadout = read_ushort(socket);
                    if class == CLASS_QUOTE {
                        player.loaded1 = WEAPON_BLADE;
                        player.loaded2 = WEAPON_MACHINEGUN;
                    } else if Loadout != 10000 {
                        player.loaded1 = real(string_copy(string(Loadout),2,2));
                        player.loaded2 = real(string_copy(string(Loadout),4,2));
                    } else {
                        player.loaded1 = 0;
                        player.loaded2 = 0;
                    }
                    //show_message(string(player.loaded1)+"--"+string(player.loaded2));
                    if LoadoutSecurety(player) == 0 {
                        if  player != global.myself {  
                            write_ubyte(player.socket, KICK);
                            write_ubyte(player.socket, KICK_LOADOUT);
                            socket_destroy(player.socket);
                            player.socket = -1;
                            player.alarm[5] = -1;
                            break;
                        } else {
                            player.loaded1 = player.class*10;
                            player.loaded2 = player.class*10+5;
                        }
                    }
                    var fixed;
                    fixed = false;
                    if global.replace[player.loaded1] != player.loaded1 or global.replace[player.loaded2] != player.loaded2 fixed = true;
                    if !fixed ServerLoadoutSync(playerId,player.loaded1,player.loaded2,global.sendBuffer,0);
                    else {
                        ServerLoadoutSync(playerId,global.replace[player.loaded1],global.replace[player.loaded2],global.sendBuffer,1);
                        player.loaded1 = global.replace[player.loaded1];
                        player.loaded2 = global.replace[player.loaded2];
                        if player == global.myself {
                            if instance_exists(NoticeO) with NoticeO instance_destroy();
                            instance_create(0,0,NoticeO);
                            with NoticeO {
                                notice = NOTICE_MISC;
                                text = "Randomizer loadout: (1) "+global.name[player.loaded1]+" + (2) "+global.name[player.loaded2]+".";
                            }
                        }
                    }
                    if player.sentry != -1 && instance_exists(player.sentry) player.sentry.hp = -999;
                }
            }
            break;
            
        case PLAYER_CHANGETEAM:
            var newTeam, balance, redSuperiority;
            newTeam = read_ubyte(socket);
            if global.saxtonhale == noone {
                redSuperiority = 0   //calculate which team is bigger
                with(Player)
                {
                    if(team == TEAM_RED)
                        redSuperiority += 1;
                    else if(team == TEAM_BLUE)
                        redSuperiority -= 1;
                }
                if(redSuperiority > 0)
                    balance = TEAM_RED;
                else if(redSuperiority < 0)
                    balance = TEAM_BLUE;
                else
                    balance = -1;
            } else {
                balance = -1;
                if newTeam == TEAM_BLUE newTeam = TEAM_RED;
            }
            
            if(balance != newTeam)
            {
                if(getCharacterObject(newTeam, player.class) != -1 or newTeam==TEAM_SPECTATOR)
                {  
                    if(player.object != -1)
                    {
                        with(player.object)
                        {
                            if (lastDamageDealer == -1 || lastDamageDealer == player || !instance_exists(lastDamageDealer))
                            {
                                sendEventPlayerDeath(player, player, noone, BID_FAREWELL);
                                doEventPlayerDeath(player, player, noone, BID_FAREWELL);
                            }
                            else
                            {
                                var assistant;
                                assistant = secondToLastDamageDealer;
                                if (lastDamageDealer.object != -1)
                                    if (lastDamageDealer.object.healer != -1)
                                        assistant = lastDamageDealer.object.healer;
                                sendEventPlayerDeath(player, lastDamageDealer, assistant, FINISHED_OFF);
                                doEventPlayerDeath(player, lastDamageDealer, assistant, FINISHED_OFF);
                            }
                        }
                        player.alarm[5] = global.Server_Respawntime;
                    }
                    else if(player.alarm[5]<=0)
                        player.alarm[5] = 1;
                    player.team = newTeam;
                    ServerPlayerChangeteam(playerId, player.team, global.sendBuffer);
                }
            }
            break;                   
            
        case CHAT_BUBBLE:
            var bubbleImage;
            bubbleImage = read_ubyte(socket);
            if(global.aFirst) {
                bubbleImage = 0;
            }
            write_ubyte(global.sendBuffer, CHAT_BUBBLE);
            write_ubyte(global.sendBuffer, playerId);
            write_ubyte(global.sendBuffer, bubbleImage);
            
            setChatBubble(player, bubbleImage);
            break;
        
        case DETONATION_POS:
            var mouse_dist;
            mouse_dist = read_ubyte(socket);
            if player.object != -1 {
                if player.object.weapon_index == WEAPON_SCOTTISHRESISTANCE {
                    write_ubyte(global.sendBuffer, DETONATION_POS);
                    write_ubyte(global.sendBuffer, playerId);
                    write_ubyte(global.sendBuffer, mouse_dist);
                    
                    doDetonation(player, mouse_dist*2);
                }
            }
            break;
        
        case SENTRY_PICKUP:
            if player.object != -1 {
                if !player.object.carrySentry && player.sentry != -1 && player.object.weapon_index == WEAPON_WRENCH {
                    if player.sentry.built == 1 && player.sentry.sapped <= 0 
                    && point_distance(player.object.x,player.object.y,player.sentry.x,player.sentry.y)<64 {
                        write_ubyte(global.sendBuffer, SENTRY_PICKUP);
                        write_ubyte(global.sendBuffer, playerId);
            
                        doPickUp(player);
                    }
                }
            }
            break;
        
        case SENTRY_PLACE:
            if player.object != -1 {
                if player.object.carrySentry 
                and collision_circle(player.object.x, player.object.y, 50, Sentry, false, true) < 0 
                and collision_point(player.object.x,player.object.y,SpawnRoom,0,0) < 0 {
                    write_ubyte(global.sendBuffer, SENTRY_PLACE);
                    write_ubyte(global.sendBuffer, playerId);
                    write_ubyte(global.sendBuffer, player.object.sentrylevel);
                    write_ubyte(global.sendBuffer, player.object.sentryhp);
                    write_ubyte(global.sendBuffer, player.object.sentryupgraded);
                    doPlaceSentry(player);
                }
            }
            break;
            
        case PHLOG_ACTIVE:
            if player.object != -1 {
                if player.object.weapon_index == WEAPON_PHLOG && player.object.phlogDmg >= 250 {
                    write_ubyte(global.sendBuffer, PHLOG_ACTIVE);
                    write_ubyte(global.sendBuffer, playerId);
                    
                    player.object.currentWeapon.critting = 300;
                    player.object.hp = player.object.maxHp;
                    player.object.overheal=25;
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
            }
            break;
        
        case WEAPON_SWAP:
            if player.object != -1 {
                if player.object.taunting == true 
                or player.object.omnomnomnom == true 
                or player.object.buffing == true
                or player.object.currentWeapon.ubering == true 
                or player.object.critting == true
                or player.object.megaHealed == true
                or player.object.stabbing == true
                or player.object.carrySentry == true
                or player.object.charge == true
                or player.object.stunned == true
                or global.medieval
                //or player.class == CLASS_QUOTE
                or player.object.canSwitch = false break;
    
                if player.object.loaded1 != -1 && player.object.loaded2 != -1 {
                    var weapon;
                    if player.object.weapon_index == player.object.loaded1 weapon=player.object.loaded2;
                    else weapon = player.object.loaded1;
                    write_ubyte(global.sendBuffer, WEAPON_SWAP);
                    write_ubyte(global.sendBuffer, playerId);
                    write_ubyte(global.sendBuffer, weapon);
                    with(player.object) {
                        weaponSwitch(weapon);
                   }
                 }
             }
             break;
             
        case GIMME_HAXXY:
            if player.object != -1 && player.RandomizerWinner == 1 {
                if player.object.taunting == true 
                or player.object.omnomnomnom == true 
                or player.object.buffing == true
                or player.object.currentWeapon.ubering == true 
                or player.object.stabbing == true
                or player.object.carrySentry == true
                or player.object.charge == true
                or player.object.stunned == true break;
                
                if player.object.weapon_index == player.object.loaded1 {
                    player.object.loaded1 = WEAPON_HAXXY;
                    player.loaded1 = WEAPON_HAXXY;
                }else {
                    player.object.loaded2 = WEAPON_HAXXY;
                    player.loaded2 = WEAPON_HAXXY;
                }
                
                ServerLoadoutSync(playerId,player.loaded1,player.loaded2,global.sendBuffer,0);
                
                write_ubyte(global.sendBuffer, WEAPON_SWAP);
                write_ubyte(global.sendBuffer, playerId);
                write_ubyte(global.sendBuffer, WEAPON_HAXXY);
                with(player.object) {
                    weaponSwitch(WEAPON_HAXXY);
                }
             }
             break;
            
        case BUILD_SENTRY:
            if(player.object != -1)
                if !player.object.carrySentry
            {
                if(player.object.weapon_index == WEAPON_NAILGUN or player.object.weapon_index == WEAPON_STUNGUN or 
                player.object.weapon_index == WEAPON_WRANGLER
                and collision_circle(player.object.x, player.object.y, 50, Sentry, false, true) < 0
                and player.object.nutsNBolts >= 50 and (collision_point(player.object.x,player.object.y,SpawnRoom,0,0) < 0)
                and player.sentry == -1 and !player.object.onCabinet)
                {
                    buildSentry(player,3);
                    write_ubyte(global.sendBuffer, BUILD_SENTRY);
                    write_ubyte(global.sendBuffer, playerId);
                    write_ubyte(global.sendBuffer, 3);
                } else if((player.object.weapon_index == WEAPON_WRENCH or player.object.weapon_index == WEAPON_EUREKAEFFECT)
                and collision_circle(player.object.x, player.object.y, 50, Sentry, false, true) < 0
                and player.object.nutsNBolts >= 80 and (collision_point(player.object.x,player.object.y,SpawnRoom,0,0) < 0)
                and player.sentry == -1 and !player.object.onCabinet)
                {
                    write_ubyte(global.sendBuffer, BUILD_SENTRY);
                    write_ubyte(global.sendBuffer, playerId);
                    if !global.medieval {
                        write_ubyte(global.sendBuffer, 0);
                        buildSentry(player,0);
                    }else {
                        write_ubyte(global.sendBuffer, 4);
                        buildSentry(player,4);
                    }
                }
            }
            break;   
        
                    
        case BUILD_DISPENSER:
            if(player.object != -1)
            {
                if(player.object.weapon_index == WEAPON_NAILGUN
                and !player.object.carrySentry
                and collision_circle(player.object.x, player.object.y, 50, Sentry, false, true) < 0
                and player.object.nutsNBolts >= 100
                and (collision_point(player.object.x,player.object.y,SpawnRoom,0,0) < 0)
                and player.sentry == -1 and !player.object.onCabinet)
                {
                    buildSentry(player,5);
                    write_ubyte(global.sendBuffer, BUILD_SENTRY);
                    write_ubyte(global.sendBuffer, playerId);
                    write_ubyte(global.sendBuffer, 5);
                } 
            }
            break;                                    

        case DESTROY_SENTRY:
            if(player.sentry != -1) {
                with(player.sentry) {
                    instance_destroy();
                }
            }
            player.sentry = -1;
            break;                     
        
        case DROP_INTEL:                                                                  
            if(player.object != -1) {
                write_ubyte(global.sendBuffer, DROP_INTEL);
                write_ubyte(global.sendBuffer, playerId);
                with player.object event_user(5);  
            }
            break;     
              
        /*case OMNOMNOMNOM:
            if(player.object != -1) {
                if(player.humiliated == 0
                        && player.object.taunting==false
                        && player.object.omnomnomnom==false
                        && player.object.weapon_index == 40) {                            
                    write_ubyte(global.sendBuffer, OMNOMNOMNOM);
                    write_ubyte(global.sendBuffer, playerId);
                    with(player.object) {
                        omnomnomnom=true;
                        if player.team == TEAM_RED {
                            omnomnomnomindex=0;
                            omnomnomnomend=31;
                        } else if player.team==TEAM_BLUE {
                            omnomnomnomindex=32;
                            omnomnomnomend=63;
                        } 
                        xscale=image_xscale;
                    }             
                }
            }
            break;*/
             
        case TOGGLE_ZOOM:
            if player.object != -1 {
                if player.object.weapon_index == WEAPON_RIFLE or player.object.weapon_index == WEAPON_MACHINA or 
                player.object.weapon_index == WEAPON_BAZAARBARGAIN or player.object.weapon_index == WEAPON_SYDNEYSLEEPER or
                player.object.weapon_index == WEAPON_SNIPEANATURE {
                    write_ubyte(global.sendBuffer, TOGGLE_ZOOM);
                    write_ubyte(global.sendBuffer, playerId);
                    toggleZoom(player.object);
                }
            }
            break;
                                                      
        case PLAYER_CHANGENAME:
            var nameLength;
            nameLength = socket_receivebuffer_size(socket);
            if(nameLength > MAX_PLAYERNAME_LENGTH)
            {
                write_ubyte(player.socket, KICK);
                write_ubyte(player.socket, KICK_NAME);
                socket_destroy(player.socket);
                player.socket = -1;
            }
            else
            {
                with(player)
                {
                    if(variable_local_exists("lastNamechange")) 
                        if(current_time - lastNamechange < 1000)
                            break;
                    lastNamechange = current_time;
                    name = read_string(socket, nameLength);
                    if(string_count("#",name) > 0)
                    {
                        name = "I <3 Bacon";
                    }
                    write_ubyte(global.sendBuffer, PLAYER_CHANGENAME);
                    write_ubyte(global.sendBuffer, playerId);
                    write_ubyte(global.sendBuffer, string_length(name));
                    write_string(global.sendBuffer, name);
                }
            }
            break;
            
        case INPUTSTATE:
            if(player.object != -1)
            {
                with(player.object)
                {
                    keyState = read_ubyte(socket);
                    netAimDirection = read_ushort(socket);
                    aimDirection = netAimDirection*360/65536;
                    //mouse_dist = read_ubyte(socket)*2;
                    event_user(1);
                }
            }
            break;
        
        case I_AM_A_HAXXY_WINNER:
            write_ubyte(socket, HAXXY_CHALLENGE_CODE);
            player.challenge = "";
            repeat(16)
                player.challenge += chr(irandom_range(1,255));
            write_string(socket, player.challenge);
            break;
            
        case HAXXY_CHALLENGE_RESPONSE:
            var answer, i, challengeSent;
            
            with(player)
                challengeSent = variable_local_exists("challenge");
            if(!challengeSent)
                break;
                
            answer = "";
            for(i=1;i<=16;i+=1)
                answer += chr(read_ubyte(socket) ^ ord(string_char_at(player.challenge, i)));
            if(HAXXY_PUBLIC_KEY==md5(answer)) {
                player.isHaxxyWinner = true;
            } else {
                socket_destroy_abortive(player.socket);
                player.socket = -1;
            }
            break;
            
        case I_AM_RANDOMIZER_DEV:
            write_ubyte(socket, RANDOMIZER_CHALLENGE);
            player.challenge2 = "";
            repeat(16)
                player.challenge2 += chr(irandom_range(1,255));
            write_string(socket, player.challenge2);
            break;
            
        case RANDOMIZER_RESPONSE:
            var answer, i, challengeSent;
            
            with(player)
                challengeSent = variable_local_exists("challenge2");
            if(!challengeSent)
                break;
                
            answer = "";
            for(i=1;i<=16;i+=1)
                answer += chr(read_ubyte(socket) ^ ord(string_char_at(player.challenge2, i)));
            if(RANDOMIZER_PUBLIC_KEY == md5(answer)) {
                player.RandomizerWinner = true;
                SendChat('Randomizer contest winner '+player.name+' has joined!',2);
            } else if RANDOMIZER_PARTICIPANT_KEY == md5(answer) {
                player.RandomizerParticipant = true;
                SendChat('Randomizer contributor '+player.name+' has joined!',2);
            } else if RANDOMIZER_DEV_KEY == md5(answer) {
                player.RandomizerDev = true;
                SendChat('Randomizer dev '+player.name+' has joined!',2);
            }
            else {
                socket_destroy_abortive(player.socket);
                player.socket = -1;
            }
            break;
        }
        break;
    } 
}
