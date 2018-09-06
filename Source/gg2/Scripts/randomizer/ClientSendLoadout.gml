switch(argument0) {
    case CLASS_SCOUT:
        return global.scoutLoadout;
        break;
        
    case CLASS_PYRO:
        return global.pyroLoadout;
        break;
        
    case CLASS_SOLDIER:
        return global.soldierLoadout;
        break;
            
    case CLASS_HEAVY:
        return global.heavyLoadout;
        break;
           
    case CLASS_ENGINEER:
        return global.engineerLoadout;
        break;
        
    case CLASS_DEMOMAN:
        return global.demomanLoadout;
        break;
            
    case CLASS_MEDIC:
        return global.medicLoadout;
        break;
            
    case CLASS_SPY:
        return global.spyLoadout;
        break;
            
    case CLASS_SNIPER:
        return global.sniperLoadout;
        break;
    
    default:
        return 10000;
        break;
}
    
