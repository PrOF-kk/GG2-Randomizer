var i;

commandBytesInvalidCommand = -1; // No such command
commandBytesPrefixLength1 = -2;  // The length of the command is indicated by the first byte

for(i=0; i<256; i+=1) {
    // -1 indicates an invalid command byte
    commandBytes[i] = commandBytesInvalidCommand;
}

commandBytes[PLAYER_LEAVE] = 0;
commandBytes[PLAYER_CHANGECLASS] = 3;
commandBytes[PLAYER_CHANGETEAM] = 1;
commandBytes[CHAT_BUBBLE] = 1;
commandBytes[BUILD_SENTRY] = 0;
commandBytes[DESTROY_SENTRY] = 0;
commandBytes[DROP_INTEL] = 0;
commandBytes[OMNOMNOMNOM] = 0;
commandBytes[TOGGLE_ZOOM] = 0;
commandBytes[PLAYER_CHANGENAME] = commandBytesPrefixLength1;
commandBytes[INPUTSTATE] = 3;
commandBytes[I_AM_A_HAXXY_WINNER] = 0;
commandBytes[HAXXY_CHALLENGE_RESPONSE] = 16;
commandBytes[I_AM_RANDOMIZER_DEV] = 0;
commandBytes[RANDOMIZER_RESPONSE] = 16;
commandBytes[DETONATION_POS] = 1;       //for the scottish resistance
commandBytes[SENTRY_PLACE] = 0;         //for the wrench
commandBytes[SENTRY_PICKUP] = 0;        //also for the wrench
commandBytes[WEAPON_SWAP] = 0;          // the most important part
commandBytes[CHAT] = commandBytesPrefixLength1;
commandBytes[TEAM_CHAT] = commandBytesPrefixLength1;
commandBytes[SERVER_MESSAGE] = commandBytesPrefixLength1;
commandBytes[BUILD_DISPENSER] = 0;
commandBytes[GIMME_HAXXY] = 0;
commandBytes[PHLOG_ACTIVE] = 0;
