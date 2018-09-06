if global.myself.object.taunting==false 
&& global.myself.object.omnomnomnom==false 
&& global.myself.object.buffing == false
&& global.myself.object.currentWeapon.ubering == false 
&& global.myself.object.critting == false
&& global.myself.object.megaHealed == false
&& global.myself.object.stabbing == false
&& global.myself.object.carrySentry == false
&& global.myself.object.charge == false
&& global.myself.object.stunned == false write_ubyte(global.serverSocket, WEAPON_SWAP);
