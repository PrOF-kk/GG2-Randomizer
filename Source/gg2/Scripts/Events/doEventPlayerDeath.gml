/**
 * Perform the "player death" event, i.e. change the appropriate scores,
 * destroy the character object to much splattering and so on.
 *
 * argument0: The player whose character died
 * argument1: The player who inflicted the fatal damage (or -1 for unknown)
 * argument2: The player who assisted the kill (or -1 for no assist)
 * argument3: The source of the fatal damage
 */
var victim, killer, assistant, damageSource, damageCrit;
victim = argument0;
killer = argument1;
assistant = argument2;
damageSource = argument3;
damageCrit = argument4;

if(!(killer and instance_exists(killer))) {
    killer = noone;
}

if(!(assistant and instance_exists(assistant))) {
    assistant = noone;
}

//*************************************
//*      Scoring and Kill log
//*************************************

if instance_exists(DeathmatchHud) {
    if killer != noone && instance_exists(killer) {
        if killer.team == TEAM_RED && killer != victim global.redCaps += 1;
        else if killer.team == TEAM_BLUE && killer != victim global.blueCaps += 1;
    }
}

if damageSource == WEAPON_RUNDOWN {
    if killer != noone && instance_exists(killer) {
        if killer.object != -1 killer.object.currentKills+=1;
    }
}

if damageSource == WEAPON_ETRANGER {
    if killer != noone && instance_exists(killer) {
        if killer.object != -1 killer.object.drCharge = min(480,killer.object.drCharge+120);
    }
}

if damageSource == WEAPON_BIGEARNER_BACKSTAB {
    if killer != noone && instance_exists(killer) {
        if killer.object != -1 {
            killer.object.stabspeed+=1;
        }
    }
}

if damageSource == WEAPON_IRON {
    if killer != noone && instance_exists(killer) {
        if killer.object != -1 {
            if killer.object.weapon_index == WEAPON_IRON killer.object.currentWeapon.ammoCount = min(killer.object.currentWeapon.maxAmmo, killer.object.currentWeapon.ammoCount+66);
        }
    }
}
if assistant != noone && instance_exists(assistant){
    if assistant.object != -1 {
        if assistant.object.weapon_index == WEAPON_IRON assistant.object.currentWeapon.ammoCount = min(assistant.object.currentWeapon.maxAmmo, assistant.object.currentWeapon.ammoCount+33);
    }
}

if damageSource == WEAPON_KGOB {
    if killer != noone && instance_exists(killer) {
        if killer.object != -1 {
            if killer.object.weapon_index == WEAPON_KGOB {
                if killer.object.currentWeapon.crit == 1 {
                    killer.object.currentWeapon.crit = MINICRIT_FACTOR;
                    killer.object.currentWeapon.alarm[3] = 120;
                    killer.object.critting = MINICRIT_FACTOR;
                    killer.object.alarm[9] = 120;
                }
            }
        }
    }
}

if damageSource == WEAPON_NORDICGOLD {
    instance_create(victim.object.x,victim.object.y,Medkit);
}

if killer != noone && instance_exists(killer) {
    if killer.object != -1 {
        if killer.object.loaded1 == WEAPON_BUFFBANNER or killer.object.loaded2 == WEAPON_BUFFBANNER {
             killer.object.ammo[WEAPON_BUFFBANNER] = min(4,killer.object.ammo[WEAPON_BUFFBANNER]+1);
             if killer.object.weapon_index == WEAPON_BUFFBANNER 
                killer.object.currentWeapon.ammoCount = min(4,killer.object.currentWeapon.ammoCount+1);
        }
    }
}

if damageSource == WEAPON_FAMILYBUSINESS {
    if killer != noone && instance_exists(killer) {
        if killer.object.healer != -1 {
            var medic;
            medic = killer.object.healer.object;
            if medic.weapon_index != WEAPON_MEDIGUN medic.ammo[WEAPON_MEDIGUN] = min(250,medic.ammo[WEAPON_MEDIGUN]+25);
            else medic.currentWeapon.uberCharge = min(2000,medic.currentWeapon.uberCharge+200); 
            if medic.weapon_index != WEAPON_KRITSKRIEG medic.ammo[WEAPON_KRITSKRIEG] = min(250,medic.ammo[WEAPON_KRITSKRIEG]+25);
            else medic.currentWeapon.uberCharge = min(2000,medic.currentWeapon.uberCharge+200); 
            if medic.weapon_index != WEAPON_QUICKFIX medic.ammo[WEAPON_QUICKFIX] = min(250,medic.ammo[WEAPON_QUICKFIX]+25);
            else medic.currentWeapon.uberCharge = min(2000,medic.currentWeapon.uberCharge+200); 
            if medic.weapon_index != WEAPON_OVERHEALER medic.ammo[WEAPON_OVERHEALER] = min(250,medic.ammo[WEAPON_OVERHEALER]+25);
            else medic.currentWeapon.uberCharge = min(2000,medic.currentWeapon.uberCharge+200);  
        }
    }
}

var hpBoost, minHp, target;
hpBoost = 0;
if victim.object != -1 {
    if victim.object.loaded1 == WEAPON_TERMINALBREATH or victim.object.loaded2 == WEAPON_TERMINALBREATH {
        if victim.object.ammo[WEAPON_MEDIGUN] > 188 hpBoost = victim.object.ammo[WEAPON_MEDIGUN]/2.5;
        else if victim.object.ammo[WEAPON_KRITSKRIEG] > 188 hpBoost = victim.object.ammo[WEAPON_KRITSKRIEG]/2.5;
        else if victim.object.ammo[WEAPON_QUICKFIX] > 188 hpBoost = victim.object.ammo[WEAPON_QUICKFIX]/2.5;
        else if victim.object.ammo[WEAPON_OVERHEALER] > 188 hpBoost = victim.object.ammo[WEAPON_OVERHEALER]/2.5;
        else if victim.object.ammo[WEAPON_POTION] > 188 hpBoost = victim.object.ammo[WEAPON_POTION]/2.5;
        else hpBoost = 0;
        if instance_exists(ArenaHUD) {
            minHp = 300;
            target = -1
            with(Character) {
                if player.team == victim.team && hp < minHp target = id;
            }
            if target != -1 target.hp += hpBoost;
        }
        with(Character) {
            if player.team == victim.team hp += hpBoost;
        }
    }
    if victim.object.loaded1 == WEAPON_SHERIFF or victim.object.loaded2 == WEAPON_SHERIFF {
        if victim.sentry != -1 victim.sentry.hp = -999;
    }
}


recordKillInLog(victim, killer, assistant, damageSource, damageCrit);
if victim.object != -1 {
    if victim.object.carrySentry {
        if killer != noone && instance_exists(killer) {
            killer.stats[DESTRUCTION] +=1;
            killer.roundStats[DESTRUCTION] +=1;
            killer.stats[POINTS] += 1;
            killer.roundStats[POINTS] += 1;
            recordDestructionInLog(victim, killer, -1, WEAPON_TOOLBOX, damageCrit);
        }
        var gib;
        gib = instance_create(victim.object.x,victim.object.y,Toolbox);
        gib.hspeed=(random(5)-2);
        gib.vspeed=random(3);
        gib.rotspeed=(random(13)-6 );
        gib.image_index = victim.team;
    }
}

if (damageSource == WEAPON_SENTRYTURRET or damageSource == WEAPON_LVL2SENTRY or  damageSource == WEAPON_LVL3SENTRY or damageSource == WEAPON_LVL3SENTRYROCKET or damageSource == WEAPON_WRANGLER) && killer != noone && instance_exists(killer) {
    if killer.sentry != -1 killer.sentry.kills += 1;
}

victim.stats[DEATHS] += 1;
if(killer)
{
    if(damageSource == WEAPON_KNIFE || damageSource == WEAPON_BACKSTAB)
    {
        killer.stats[STABS] += 1;
        killer.roundStats[STABS] += 1;
        killer.stats[POINTS] += 1;
        killer.roundStats[POINTS] +=1;
    }
    
    if (victim.object.ammo[100]=true)
    {
        killer.stats[BONUS] += 1;
        killer.roundStats[BONUS] += 1;
        killer.stats[POINTS] += 1;
        killer.roundStats[POINTS] += 1;
    }
        
    if (killer != victim)
    {
        killer.stats[KILLS] += 1;
        killer.roundStats[KILLS] += 1;
        killer.stats[POINTS] += 1;
        killer.roundStats[POINTS] += 1;
        if(victim.object.intel)
        {
            killer.stats[DEFENSES] += 1;
            killer.roundStats[DEFENSES] += 1;
            killer.stats[POINTS] += 1;
            killer.roundStats[POINTS] += 1;
            recordEventInLog(4, killer.team, killer.name, global.myself == killer);
        }
    }
}

if (assistant)
{
    assistant.stats[ASSISTS] += 1;
    assistant.roundStats[ASSISTS] += 1;
    assistant.stats[POINTS] += .5;
    assistant.roundStats[POINTS] += .5;
}

//SPEC
if (victim == global.myself)
    instance_create(victim.object.x, victim.object.y, Spectator);

//*************************************
//*         Gibbing
//*************************************
var xoffset, yoffset, xsize, ysize;

xoffset = view_xview[0];
yoffset = view_yview[0];
xsize = view_wview[0];
ysize = view_hview[0];

randomize();
with(victim.object) {
    if((damageSource == WEAPON_STICKYSTICKER or damageSource == DEMOMAN_TAUNTKILL or damageSource == WEAPON_DIRECTHIT or damageSource == WEAPON_LVL3SENTRYROCKET or damageSource == WEAPON_GRENADELAUNCHER or damageSource == WEAPON_DOUBLETROUBLE or damageSource == WEAPON_TIGERUPPERCUT or damageSource == WEAPON_SCOTTISHRESISTANCE or damageSource == WEAPON_BLACKBOX or damageSource == WEAPON_ROCKETLAUNCHER or damageSource == WEAPON_MINEGUN or damageSource == FRAG_BOX or damageSource == WEAPON_REFLECTED_STICKY or damageSource == WEAPON_REFLECTED_ROCKET or damageSource == FINISHED_OFF_GIB or damageSource == GENERATOR_EXPLOSION) and (player.class != CLASS_QUOTE) && (global.gibLevel>1) && distance_to_point(xoffset+xsize/2,yoffset+ysize/2) < 900) {
        repeat(global.gibLevel) {
            var gib;
            gib = instance_create(x,y,Gib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(145)-72);
        }
        switch(player.team) {
        case TEAM_BLUE :
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,BlueClump);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(145)-72);
            }
            break;
        case TEAM_RED :
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,RedClump);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(145)-72);
            }
            break;
        }

        repeat(global.gibLevel * 14) {
            var blood;
            blood = instance_create(x+random(23)-11,y+random(23)-11,BloodDrop);
            blood.hspeed=(random(21)-10);
            blood.vspeed=(random(21)-13);
        }

        switch(player.class) {
        case CLASS_SCOUT :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 6;
            }
            repeat(global.gibLevel -1){
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6 );
                gib.image_index = 0;
            }
            repeat(global.gibLevel -1){
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52);
                gib.image_index = 1;
            }
            break;
        case CLASS_PYRO :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52);
            gib.image_index = 7;
            }
            if(global.gibLevel > 2){
            var gib;
            gib = instance_create(x,y,Accesory);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 4;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 1;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 0;
            }
            break;
        case CLASS_SOLDIER :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 1;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 2;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 1;
            }
            if(global.gibLevel > 2 || choose(0,1) == 1){
            switch(player.team) {
            case TEAM_BLUE :
                var gib;
                gib = instance_create(x,y,Accesory);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 2;
                break;
            case TEAM_RED :
                var gib;
                gib = instance_create(x,y,Accesory);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 1;
                break;
            }
            break;
        }
        case CLASS_HEAVY :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 2;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 3;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 1;
            }
            break;
        case CLASS_DEMOMAN :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 4;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 4;
            }
            repeat(global.gibLevel -1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 0;
            }
            break;
        case CLASS_MEDIC :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 5;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 4;
            }
            if(global.gibLevel > 2 || choose(0,1) == 1){
            switch(player.team) {
            case TEAM_BLUE :
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 3;
                break;
            case TEAM_RED :
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 2;
                break;     
            }
        }
        break;

        case CLASS_ENGINEER :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 8;
            }
            if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Accesory);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 3;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 5;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 0;
            }
            break;
        case CLASS_SPY :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 3;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 6;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 0;
            }
            break;
            
        case CLASS_SNIPER :
        if(global.gibLevel > 2 || choose(0,1) == 1){
            var gib;
            gib = instance_create(x,y,Headgib);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 0;
            var gib;
            }
            if(global.gibLevel > 2 || choose(0,1) == 1){
            gib = instance_create(x,y,Accesory);
            gib.hspeed=(random(17)-8);
            gib.vspeed=(random(17)-9);
            gib.rotspeed=(random(105)-52 );
            gib.image_index = 0;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Feet);
                gib.hspeed=(random(5)-2);
                gib.vspeed=random(3);
                gib.rotspeed=(random(13)-6);
                gib.image_index = 6;
            }
            repeat(global.gibLevel - 1) {
                var gib;
                gib = instance_create(x,y,Hand);
                gib.hspeed=(random(17)-8);
                gib.vspeed=(random(17)-9);
                gib.rotspeed=(random(105)-52 );
                gib.image_index = 0;
            }
            break;
        }
        playsound(x,y,Gibbing);
    } else if (damageSource == WEAPON_POMSON or damageSource == WEAPON_COWMANGLER or damageSource == WEAPON_COWMANGLERFIRE or damageSource == WEAPON_RBISON) && global.particles == PARTICLES_NORMAL {
        var deadbody;
        if player.class != CLASS_QUOTE playsound(x,y,choose(DeathSnd1, DeathSnd2));
        deadbody = instance_create(x,y-5,MangledGuy);
        deadbody.class = player.class;
        deadbody.team = player.team;
        deadbody.hspeed=hspeed;
        //deadbody.vspeed=vspeed;
        deadbody.image_xscale = image_xscale;  
    } else if lastDamageSource == WEAPON_PHLOG && global.gibLevel >= 2 {
        var gib;
        gib = instance_create(x-15,y,Burnedheadgib);
        gib.hspeed=(random(17)-8);
        gib.vspeed=(random(17)-9)+2;
        gib.rotspeed=(random(105)-52 );
        gib.image_index = player.class;
        playsound(x,y,choose(DeathSnd1, DeathSnd2));
        repeat(50) {
            instance_create(x+random(16)-8,y+random(42)-24,Dust)
        }
    } else if hpBoost > 0 {
        var deadbody;
        playsound(x,y,choose(DeathSnd1, DeathSnd2));
        deadbody = instance_create(x,y,DeadMedic);
        deadbody.team = victim.team
        deadbody.image_xscale = image_xscale;  
        deadbody.hspeed=hspeed;
        deadbody.vspeed=vspeed;
    } else if damageSource == WEAPON_SPYCICLE or damageSource == WEAPON_SPYCICLE_BACKSTAB or damageSource == WEAPON_FROSTBITE { 
        if global.gibLevel > 2 {
            var statue;
            statue=instance_create(x,y,Toolbox);
            statue.hspeed=hspeed;
            statue.vspeed=vspeed;
            if(hspeed>0) statue.image_xscale = -1; 
            statue.sprite_index = FrozenStatuesS; 
            if player.class != CLASS_QUOTE statue.image_index = player.class+choose(10,0);
            else statue.image_index = player.class+player.team*10;
        } else {
            deadbody = instance_create(x,y,DeadGuy);
            deadbody.hspeed=hspeed;
            deadbody.vspeed=vspeed;
            if(hspeed>0) deadbody.image_xscale = -1;  
            deadbody.sprite_index = FrozenStatuesS;
            if player.class != CLASS_QUOTE deadbody.image_index = player.class+choose(10,0);
            else deadbodyimage_index = player.class+player.team*10;
        }
    } else {
        var deadbody;
        if player.class != CLASS_QUOTE playsound(x,y,choose(DeathSnd1, DeathSnd2));
        deadbody = instance_create(x,y-30,DeadGuy);
        if(player.isHaxxyWinner) or damageSource == WEAPON_HAXXY or damageSource == WEAPON_SPYCICLE_BACKSTAB or damageSource == WEAPON_FROSTBITE
        {
            deadbody.sprite_index = haxxyStatue;
            //if damageSource == WEAPON_SPYCICLE_BACKSTAB or damageSource == WEAPON_FROSTBITE deadbody.image_index = 2;
            //else if player.RandomizerWinner or player.RandomizerParticipant deadbody.image_index = 1;
            /*else */deadbody.image_index = 0;
        }
        else
        { 
            deadbody.sprite_index = sprite_index;
            deadbody.image_index = CHARACTER_ANIMATION_DEAD;
        }
        deadbody.hspeed=hspeed;
        deadbody.vspeed=vspeed;
        if(hspeed>0) {
            deadbody.image_xscale = -1;  
        }
    }
}

if global.gg_birthday {
    myHat = instance_create(victim.object.x,victim.object.y,PartyHat);
    myHat.image_index = victim.team;
}

with(victim.object) {       
    instance_destroy();
}

//*************************************
//*         Deathcam
//*************************************
if( global.killCam and victim == global.myself and killer and killer != victim and !(damageSource == KILL_BOX || damageSource == FRAG_BOX || damageSource == FINISHED_OFF || damageSource == FINISHED_OFF_GIB || damageSource == GENERATOR_EXPLOSION)) {
    instance_create(0,0,DeathCam);
    DeathCam.killedby=killer;
    DeathCam.name=killer.name;
    DeathCam.oldxview=view_xview[0];
    DeathCam.oldyview=view_yview[0];
    DeathCam.lastDamageSource=damageSource;
    DeathCam.team = global.myself.team;
}
