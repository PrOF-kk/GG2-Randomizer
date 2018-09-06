switch(argument0) {
    //non-damage dealing weapons
    case WEAPON_BONK:
    case WEAPON_BOOTS:
    case WEAPON_MADMILK:
    case WEAPON_JARATE:
    case WEAPON_MEDIGUN:
    case WEAPON_KRITSKRIEG:
    case WEAPON_OVERHEALER:
    case WEAPON_QUICKFIX:
    case WEAPON_WRANGLER:
    case WEAPON_CHOCOLATE:
    case WEAPON_SANDVICH:
    case WEAPON_ZAPPER:
        return 1;
        break;
    
    //bats
    case WEAPON_SANDMAN:
    case WEAPON_ATOMIZER:
        return 2;
        break;
    
    //shotguns
    case WEAPON_SOLDIERSHOTGUN:
    case WEAPON_RESERVESHOOTER:
    case WEAPON_WIDOWMAKER:
    case WEAPON_SHOTGUN:
    case WEAPON_SHERIFF:
    case WEAPON_FAMILYBUSINESS:
    case WEAPON_PYROSHOTGUN:
        return 3;
        break;
    
    default:
        return -1;
        break;
}
