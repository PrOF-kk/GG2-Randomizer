    // Record kill in killlog
    // argument0: The killed player
    // argument1: The killer, or a false value for suicides
    // argument2: The assistant, or a false value for no assist
    // argument3: The source of the damage (e.g. WEAPON_SCATTERGUN)
    // argument4: The crit value
      
        with (KillLog) {
            map = ds_map_create();

            if (!argument1 || argument1==argument0) {
                ds_map_add(map, "name1", "");
                ds_map_add(map, "team1", 0);
            } else {
                var killer;
                killer = string_copy(argument1.name, 1, 20);
                if (argument2)
                    killer += " + " + string_copy(argument2.name, 1, 20);
                ds_map_add(map, "name1", killer);
                ds_map_add(map, "team1", argument1.team);
            }            
            ds_map_add(map, "name2", string_copy(argument0.name, 1, 20));
            ds_map_add(map, "team2", argument0.team);
            
            if (argument0 == global.myself || argument1 == global.myself || argument2 == global.myself) 
                ds_map_add(map, "inthis", true);
            else ds_map_add(map, "inthis", false);
            if argument4 > 1 ds_map_add(map, "crit", 2);
            else ds_map_add(map, "crit", 0);
            ds_map_add(map, "string", "");
            
            switch(argument3) {
                case WEAPON_NEEDLEGUN:
                    ds_map_add(map, "weapon", NeedleKL);
                    break;
                case WEAPON_RIFLE:
                    ds_map_add(map, "weapon", RifleKL);
                    break;
                case WEAPON_RIFLE_CHARGED:
                //case WEAPON_SSLEEPER_CHARGED:
                    ds_map_add(map, "weapon", RifleChargedKL);
                    break;
                case WEAPON_MINEGUN:
                    ds_map_add(map, "weapon", MineKL);
                    break;
                case WEAPON_MINIGUN:
                    ds_map_add(map, "weapon", MinigunKL);
                    break;
                case WEAPON_FLAMETHROWER:
                    ds_map_add(map, "weapon", FlameKL);
                    break;
                case WEAPON_SCATTERGUN:
                    ds_map_add(map, "weapon", ScatterKL);
                    break;
                case WEAPON_SHOTGUN:
                    ds_map_add(map, "weapon", ShotgunKL);
                    break;
                /*case WEAPON_QROCKETLAUNCHER:
                    ds_map_add(map, "weapon", QRlauncherS);
                    break;*/
                case WEAPON_ROCKETLAUNCHER:
                    ds_map_add(map, "weapon", RocketKL);
                    break;
                case WEAPON_REVOLVER:
                    ds_map_add(map, "weapon", RevolverKL);
                    break;
                case WEAPON_SENTRYTURRET:
                    ds_map_add(map, "weapon", TurretKL);
                    break;
                case WEAPON_BLADE:
                    ds_map_add(map, "weapon", BladeKL);
                    break;
                case WEAPON_BUBBLE:
                    ds_map_add(map, "weapon", BubbleKL);
                    break;
                case WEAPON_REFLECTED_ROCKET:
                    ds_map_add(map, "weapon", RocketReflectKL);
                    break;
                case WEAPON_REFLECTED_STICKY:
                    ds_map_add(map, "weapon", MineReflectKL);
                    break;                    
                case WEAPON_KNIFE:
                    ds_map_add(map, "weapon", KnifeKL);
                    break;
                case WEAPON_BACKSTAB:
                case WEAPON_BIGEARNER_BACKSTAB:
                case WEAPON_SPYCICLE_BACKSTAB:
                case WEAPON_KUNAIBACKSTAB:
                case WEAPON_MEDICHAINBACKSTAB:
                    ds_map_add(map, "weapon", BackstabKL);
                    break;
                case WEAPON_FLAREGUN:
                    ds_map_add(map, "weapon", FlareKL);
                    break;
                case WEAPON_REFLECTED_ARROW:
                    ds_map_add(map, "weapon", ArrowReflectKL);
                    break;
                case WEAPON_HUNTSMAN:
                    ds_map_add(map, "weapon", ArrowKL);
                    break;
                case WEAPON_BACKBURNER:
                    ds_map_add(map, "weapon", BackBurnerKL);
                    break;
                case WEAPON_SANDMAN:
                    ds_map_add(map, "weapon", BatKL);
                    break;
                case WEAPON_BLACKBOX:
                    ds_map_add(map, "weapon", BlackboxKL);
                    break;
                case WEAPON_BLUTSAUGER:
                    ds_map_add(map, "weapon", BlutsaugerKL);
                    break;
                case WEAPON_ETRANGER:
                    ds_map_add(map, "weapon", EtrangerKL);
                    break;
                case WEAPON_EYELANDER:
                    ds_map_add(map, "weapon", EyelanderKL);
                    break;
                case WEAPON_FAN:
                    ds_map_add(map, "weapon", FANKL);
                    break;
                case WEAPON_FIREARROW:
                    ds_map_add(map, "weapon", FireArrowKL);
                    break;
                case WEAPON_TRANSMUTATOR:
                    ds_map_add(map, "weapon", TransmutatorKL);
                    break;
                case WEAPON_FRONTIERJUSTICE:
                    ds_map_add(map, "weapon", FrontierJusticeKL);
                    break;
                case WEAPON_GRENADELAUNCHER:
                    ds_map_add(map, "weapon", GrenadelauncherKL);
                    break;
                case WEAPON_DOUBLETROUBLE:
                    ds_map_add(map, "weapon", LochNLoadKL);
                    break;
                case WEAPON_COWMANGLERFIRE:
                    ds_map_add(map, "weapon", ManglerFireKL);
                    break;
                case WEAPON_COWMANGLER:
                    ds_map_add(map, "weapon", CowManglerKL);
                    break;
                case WEAPON_NATACHA:
                    ds_map_add(map, "weapon", NatachaKL);
                    break;
                /*case WEAPON_OVERDOSE:
                    ds_map_add(map, "weapon", OverdoseKL);
                    break;*/
                case WEAPON_PISTOL:
                    ds_map_add(map, "weapon", PistolKL);
                    break;
                case WEAPON_SAPPER:
                    ds_map_add(map, "weapon", SapperKL);
                    break;
                case WEAPON_STUNGUN:
                    ds_map_add(map, "weapon", StungunKL);
                    break;
                case WEAPON_TIGERUPPERCUT:
                    ds_map_add(map, "weapon", TigerUppercutKL);
                    break;
                /*case WEAPON_SHORTSTOP:
                    ds_map_add(map, "weapon", ShortStopKL);
                    break;*/
                case WEAPON_RBISON:
                    ds_map_add(map, "weapon", RBisonKL);
                    break;
                case WEAPON_KUKRI:
                    ds_map_add(map, "weapon", KukriKL);
                    break;
                case WEAPON_SCOTTISHRESISTANCE:
                    ds_map_add(map, "weapon", ScottishResistanceKL);
                    break;
                case WEAPON_WIDOWMAKER:
                    ds_map_add(map, "weapon", WidowMakerKL);
                    break;
                case WEAPON_TOMISLAV:
                    ds_map_add(map, "weapon", TomislavKL);
                    break;
                case WEAPON_FAMILYBUSINESS:
                    ds_map_add(map, "weapon", FamilyBusinessKL);
                    break;
                case WEAPON_ENFORCER:
                    ds_map_add(map, "weapon", EnforcerKL);
                    break;
                /*case WEAPON_KUNAI:
                    ds_map_add(map, "weapon", KunaiKL);
                    break;*/
                case WEAPON_BIGEARNER:
                    ds_map_add(map, "weapon", BigEarnerKL);
                    break;
                case WEAPON_WRENCH:
                    ds_map_add(map, "weapon", WrenchKL);
                    break;
                case WEAPON_REFLECTED_FLARE:
                    ds_map_add(map, "weapon", FlareReflectKL);
                    break;
                case WEAPON_DETONATOR:
                    ds_map_add(map, "weapon", DetonatorKL);
                    break;
                case WEAPON_BALL:
                    ds_map_add(map, "weapon", BallHitKL);
                    break;
                case WEAPON_SYDNEYSLEEPER:
                    ds_map_add(map, "weapon", SSleeperKL);
                    break;
                case WEAPON_SMG:
                    ds_map_add(map, "weapon", SmgKL);
                    break;
                case WEAPON_NAILGUN:
                    ds_map_add(map, "weapon", PistolKL);
                    break;
                case WEAPON_TOOLBOX:
                    ds_map_add(map, "weapon", ToolboxKL);
                    break;
                case WEAPON_AXE:
                    ds_map_add(map, "weapon", AxeKL);
                    break;
                case WEAPON_EQUALIZER:
                    ds_map_add(map, "weapon", ShovelKL);
                    break;
                case WEAPON_FISTS:
                case WEAPON_KGOB:
                    ds_map_add(map, "weapon", FistsKL);
                    break;
                case WEAPON_LVL2SENTRY:
                    ds_map_add(map, "weapon", Sentry2KL);
                    break;
                case WEAPON_LVL3SENTRYROCKET:
                case WEAPON_LVL3SENTRY:
                    ds_map_add(map, "weapon", Sentry3KL);
                    break;
                case WEAPON_WRANGLER:
                    ds_map_add(map, "weapon", WranglerKL);
                    break;
                case WEAPON_DIRECTHIT:
                    ds_map_add(map, "weapon", DirectHitKL);
                    break;
                case WEAPON_HAXXY:
                    ds_map_add(map, "weapon", HaxxyKL);
                    break;
                case WEAPON_HEADSHOT: 
                    ds_map_add(map, "weapon", HeadshotKL);
                    break;
                case WEAPON_POMSON:
                    ds_map_add(map, "weapon", PomsonKL);
                    break;
                case WEAPON_BAZAARBARGAIN:
                    ds_map_add(map, "weapon", BazaarbargainKL);
                    break;
                case WEAPON_MACHINA:
                    ds_map_add(map, "weapon", MachinaKL);
                    break;
                case WEAPON_SODAPOPPER:
                    ds_map_add(map, "weapon", SodaPopperKL);
                    break;
                case WEAPON_RUNDOWN:
                    ds_map_add(map, "weapon", RundownKL);
                    break;
                case WEAPON_SHIV:
                    ds_map_add(map, "weapon", ShivKL);
                    break;
                case WEAPON_PAINTRAIN:
                    ds_map_add(map, "weapon", PaintrainKL);
                    break;
                case WEAPON_DIPLOMAT:
                    ds_map_add(map, "weapon", DiplomatKL);
                    break;
                case WEAPON_SPYCICLE:
                    ds_map_add(map, "weapon", SpycicleKL);
                    break;
                case WEAPON_FROSTBITE:
                    ds_map_add(map, "weapon", FrostbiteKL);
                    break;
                /*case WEAPON_AXTINGUISHER:
                    ds_map_add(map, "weapon", AxtinguisherKL);
                    break;*/
                case WEAPON_SHERIFF:
                    ds_map_add(map, "weapon", SheriffKL);
                    break;
                case WEAPON_MEDICHAIN:
                    ds_map_add(map, "weapon", MedichainKL);
                    break;   
                case WEAPON_MACHINEGUN:
                    ds_map_add(map, "weapon", MachinegunKL);
                    break; 
                case WEAPON_BRASSBEAST:
                    ds_map_add(map, "weapon", BrassBeastKL);
                    break;    
                case WEAPON_FAILSTAB:
                    ds_map_add(map, "weapon", FailstabKL);
                    break; 
                case WEAPON_ARROWHEADSHOT:
                    ds_map_add(map, "weapon", ArrowHeadshotKL);
                    break;  
                case WEAPON_PREDATOR:
                    ds_map_add(map, "weapon", PredatorKL);
                    break;   
                case WEAPON_POTION:
                    ds_map_add(map, "weapon", BrewgunKL);
                break;  
                case WEAPON_PHLOG:
                    ds_map_add(map, "weapon", PhlogKL);
                break;  
                case WEAPON_ATOMIZER:
                    ds_map_add(map, "weapon", AtomizerKL);
                break; 
                case WEAPON_EUREKAEFFECT:
                    ds_map_add(map, "weapon", EeffectKL);
                break;
                case WEAPON_FLASHLIGHT:
                    ds_map_add(map, "weapon", LasergunKL); 
                break;
                case WEAPON_NORDICGOLD:
                    ds_map_add(map, "weapon", GoldAssistantKL);    
                break;
                case WEAPON_RESERVESHOOTER:
                    ds_map_add(map, "weapon", ReserveshooterKL);
                break;
                case WEAPON_SNIPEANATURE:
                    ds_map_add(map, "weapon", SnipeanatureKL);
                break;
                case WEAPON_MANMELTER:
                    ds_map_add(map, "weapon", ManmelterKL);
                break;
                case WEAPON_IRON:
                    ds_map_add(map, "weapon", IronMaidenKL);
                break;
                case WEAPON_AIRSTRIKE:
                    ds_map_add(map, "weapon",AirstrikeKL);
                break;
                case WEAPON_STICKYSTICKER:
                    ds_map_add(map, "weapon",StickyStickerKL);
                break;
                case WEAPON_ZAPPER:
                    ds_map_add(map, "weapon",ZapperKL);
                break;
                case SCOUT_TAUNTKILL:
                    ds_map_add(map, "weapon",ScoutTauntKL);
                break;
                case SNIPER_TAUNTKILL:
                    ds_map_add(map, "weapon",SniperTauntKL);
                break;
                case MEDIC_TAUNTKILL:
                case WEAPON_OVERDOSE:
                    ds_map_add(map, "weapon",UbersawKL);
                break;
                case WEAPON_WRECKER:
                case WEAPON_NAPALM:
                    ds_map_add(map, "weapon",ManglerFireKL);
                break;
                case KILL_BOX:
                case FRAG_BOX:
                    if (!argument1 || argument1==argument0) {
                        ds_map_add(map, "weapon", DeadKL);
                        break;
                    }
                case PITFALL:
                    ds_map_add(map, "weapon", DeadKL);
                    ds_map_replace(map, "string", string_copy(argument0.name, 1, 20) + " fell to a clumsy, painful death.");
                    ds_map_replace(map, "name2", "");
                    ds_map_replace(map, "team2", 0);
                    break;          
                case FINISHED_OFF:
                case FINISHED_OFF_GIB:
                    ds_map_add(map, "weapon", DeadKL);
                    ds_map_replace(map, "string", "finished off ");
                    break;
                case BID_FAREWELL:
                    ds_map_add(map, "weapon", DeadKL);
                    ds_map_replace(map, "string", string_copy(argument0.name, 1, 20) + " bid farewell, cruel world!");
                    ds_map_replace(map, "name2", "");
                    ds_map_replace(map, "team2", 0);
                    break;
                case GENERATOR_EXPLOSION:
                    ds_map_add(map, "weapon", ExplodeKL);
                    break;                
                default:
                    ds_map_add(map, "weapon", DeadKL);
                    break;            
            }
            
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5;
        }
