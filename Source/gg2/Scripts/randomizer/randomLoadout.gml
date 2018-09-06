if global.medieval argument0.loaded1 = 
choose(choose(WEAPON_SANDMAN,WEAPON_SHIV,WEAPON_ATOMIZER,WEAPON_HUNTSMAN,WEAPON_EYELANDER,
WEAPON_PAINTRAIN,WEAPON_CROSSBOW,WEAPON_AXE,WEAPON_EQUALIZER),choose(WEAPON_WRENCH,WEAPON_KNIFE,WEAPON_MEDICHAIN,
WEAPON_BIGEARNER,WEAPON_SPYCICLE,WEAPON_BLADE,WEAPON_FISTS,WEAPON_HAXXY,WEAPON_AXE));
else {
    var load1, load2, type;
    load1 = floor(random(WEAPON_COUNT));
    type = checkType(load1);
    do {
        load2 = floor(random(WEAPON_COUNT));
        if type == checkType(load2) && type != -1 load2 = load1;
    } until load2 != load1;
    
    argument0.loaded1 =  global.replace[load1];
    argument0.loaded2 =  global.replace[load2];
}

