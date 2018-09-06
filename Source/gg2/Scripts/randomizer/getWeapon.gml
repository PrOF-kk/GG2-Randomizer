if string_letters(argument0) != "" {
    var weapon;
    weapon = string_lower(argument0);
    for(i=0;i<WEAPON_COUNT;i+=1) {
        if string_count(weapon,string_lower(global.name[i])) > 0 return i;
    }
    return -1;
} else if real(string_digits(argument0)) < WEAPON_COUNT && real(string_digits(argument0)) >= 0 return real(string_digits(argument0));
else return -1;
