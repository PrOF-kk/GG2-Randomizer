// A simple check if the sent loadout is valid. Get rid if all cheaters :P
//argument0 = player
if argument0.class == CLASS_QUOTE return -1
else if ((instance_exists(ArenaHUD) && global.randomizer == 2) or global.randomizer == 1) return -1
else {
    if ((argument0.loaded1 < argument0.class*10                // The new weapon needs to fall within the 
    or argument0.loaded2 < argument0.class*10+5                // weapons a class can hold.
    or argument0.loaded1 > argument0.class*10+4                  
    or argument0.loaded2 > argument0.class*10+9)
    or argument0.loaded1 > WEAPON_COUNT                      // The new weapon can't be bigger 
    or argument0.loaded2 > WEAPON_COUNT)                     // than the amount of weapons (derp).
    
    return 0                                                // Give the player das boot.
    else return -1                                          // Do nothing.
}

