if argument0 != -1 {
    if argument0.loaded1 == WEAPON_KUKRI or argument0.loaded2 == WEAPON_KUKRI {
        argument0.hasDangershield = true;
        argument0.maxHp += 20;
        argument0.hp +=20;
    }
    if argument0.loaded1 == WEAPON_SHIV or argument0.loaded2 == WEAPON_SHIV {
        argument0.hasRazorback = true;
    }
    if argument0.loaded1 == WEAPON_FAN or argument0.loaded2 == WEAPON_FAN {
        argument0.maxHp -= 20;
        argument0.hp -=20;
    }
    if argument0.loaded1 == WEAPON_ATOMIZER or argument0.loaded2 == WEAPON_ATOMIZER {
        argument0.maxHp -= 10;
        argument0.hp -= 10;
    }
    if argument0.loaded1 == WEAPON_STICKYJUMPER or argument0.loaded2 == WEAPON_STICKYJUMPER {
        argument0.maxHp -= 20;
        argument0.hp -= 20;
    }
    if argument0.loaded1 == WEAPON_ATOMIZER or argument0.loaded2 == WEAPON_ATOMIZER {
        argument0.canTriplejump = true;
    }
    if argument0.loaded1 == WEAPON_TERMINALBREATH or argument0.loaded2 == WEAPON_TERMINALBREATH {
        argument0.maxHp-=20;
        argument0.hp-=20;
    }
    if argument0.loaded1 == WEAPON_NEEDLEGUN or argument0.loaded2 == WEAPON_NEEDLEGUN or 
       argument0.loaded1 == WEAPON_TERMINALBREATH or argument0.loaded2 == WEAPON_TERMINALBREATH or
       argument0.loaded1 == WEAPON_OVERDOSE or argument0.loaded2 == WEAPON_OVERDOSE or
       argument0.loaded1 == WEAPON_CROSSBOW or argument0.loaded2 == WEAPON_CROSSBOW {
        regenRate = 5;
    }
    if argument0.loaded1 == WEAPON_BIGEARNER or argument0.loaded2 == WEAPON_BIGEARNER {
        argument0.maxHp-=20;
        argument0.hp-=20;
    }
    if argument0.loaded1 == WEAPON_JETPACK or argument0.loaded2 == WEAPON_JETPACK {
        argument0.highJump = true;
    }
    if argument0.loaded1 == WEAPON_PAINTRAIN or argument0.loaded2 == WEAPON_PAINTRAIN {
        if instance_exists(IntelligenceBaseBlue) || instance_exists(IntelligenceBaseRed) || instance_exists(IntelligenceRed) || instance_exists(IntelligenceBlue) {
            argument0.maxHp+=30;
            argument0.hp+=30;
        }
        argument0.capStrength +=1;
    } 
    if argument0.loaded1 == WEAPON_RUNDOWN or argument0.loaded2 == WEAPON_RUNDOWN {
        argument0.capStrength = min(1,argument0.capStrength-1);
    }
    if argument0.loaded1 == WEAPON_NORDICGOLD or argument0.loaded2 == WEAPON_NORDICGOLD {
        argument0.runPower -= 0.08;
        argument0.runBkp -= 0.08;
    }
    if argument0.loaded1 == WEAPON_BOOTS {
        if argument0.weapon_index == WEAPON_BOOTS with(argument0) weaponSwitch(loaded2);
        argument0.canSwitch = 0;
        argument0.hasBoots = true;
    } else if argument0.loaded2 == WEAPON_BOOTS {
        if argument0.weapon_index == WEAPON_BOOTS with(argument0) weaponSwitch(loaded1);
        argument0.canSwitch = 0;
        argument0.hasBoots = true;
    }
}
