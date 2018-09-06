/**
 * Set a player's ubercharge to ready
 *
 * argument0: The player who filled his ubercharge meter
 */

var uberer;
uberer = argument0;
 
if(uberer.object != -1) {
    if uberer.object.currentWeapon.object_index == Medigun {
        playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
        setChatBubble(uberer, 46);
        with(Medigun) {
            if(ownerPlayer == uberer) {
                uberReady = true;
                uberCharge = 2000;
            }
        }
    } else if uberer.object.currentWeapon.object_index == Kritzieg {
        playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
        setChatBubble(uberer, 46);
        with(Kritzieg) {
            if(ownerPlayer == uberer) {
                uberReady = true;
                uberCharge = 2000;
            }
        }
    } else if uberer.object.currentWeapon.object_index == QuickFix {
        playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
        setChatBubble(uberer, 46);
        with(QuickFix) {
            if(ownerPlayer == uberer) {
                uberReady = true;
                uberCharge = 2000;
            }
        }
    } else if uberer.object.currentWeapon.object_index == Invisibeam {
        playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
        setChatBubble(uberer, 46);
        with(Invisibeam) {
            if(ownerPlayer == uberer) {
                uberReady = true;
                uberCharge = 2000;
            }
        }
    } else if uberer.object.currentWeapon.object_index == Overhealer {
        playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
        setChatBubble(uberer, 46);
        with(Overhealer) {
            if(ownerPlayer == uberer) {
                uberReady = true;
                uberCharge = 2000;
            }
        }
    } else if uberer.object.currentWeapon.object_index == Brewinggun {
        playsound(uberer.object.x,uberer.object.y,UberChargedSnd);
        setChatBubble(uberer, 46);
        with(Brewinggun) {
            if(ownerPlayer == uberer) {
                uberReady = true;
                uberCharge = 2000;
            }
        }
    }
} else {
    show_message("The UberReady-Event has just been called for a dead player. Please report this bug.");
}
