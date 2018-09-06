//if(argument0.alarm[5]<=0) argument0.alarm[5] = 1;
argument0.class = floor(random(10));
ServerPlayerChangeclass(ds_list_find_index(global.players,argument0), argument0.class, global.eventBuffer);
