var i;
i = 0;
with(Player) {
    if team == argument0 && class == argument1 i+=1;
}

if real(i) < real(global.Classlimit[argument1]) or real(global.Classlimit[argument1]) == -1 return 1;
else return -1;
