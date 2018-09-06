//argument0 : the console input
var found;
found = -1;
if argument0 == 'all' or argument0 == 'player' found = Player
else if string_letters(argument0) != "" {
    with(Player) {
        if string_count(string_lower(other.argument0), string_lower(name)) >= 1 found = id;
    }
} else if real(string_digits(argument0)) < ds_list_size(global.players) {
    found = ds_list_find_value(global.players,real(string_digits(argument0)));
}

return found;


