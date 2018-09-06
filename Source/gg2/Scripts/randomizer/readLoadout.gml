var Loadout;

switch(argument0.class) {
    case CLASS_SCOUT:
        Loadout = global.scoutLoadout;
        break;
        
    case CLASS_PYRO:
        Loadout = global.pyroLoadout;
        break;
        
    case CLASS_SOLDIER:
        Loadout = global.soldierLoadout;
        break;
            
    case CLASS_HEAVY:
        Loadout = global.heavyLoadout;
        break;
           
    case CLASS_ENGINEER:
        Loadout = global.engineerLoadout;
        break;
        
    case CLASS_DEMOMAN:
        Loadout = global.demomanLoadout;
        break;
            
    case CLASS_MEDIC:
        Loadout = global.medicLoadout;
        break;
            
    case CLASS_SPY:
        Loadout = global.spyLoadout;
        break;
            
    case CLASS_SNIPER:
        Loadout = global.sniperLoadout;
        break;
    
    default:
        Loadout = real("1"+string(WEAPON_BLADE)+string(WEAPON_MACHINEGUN));
        break;
}
    
argument0.object.loaded1 = real(string_copy(string(Loadout),2,2));
argument0.object.loaded2 = real(string_copy(string(Loadout),4,2));
