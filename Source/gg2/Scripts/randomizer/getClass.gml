//argument0 : the console input
var found, class;
found = -1;
class = string_lower(argument0);
if class == 'random' or class == 'class' or class == '*' found = floor(random(10));
else if class == 'scout' or class == 'runner' or class == '1' found = CLASS_SCOUT;
else if class == 'soldier' or class == 'rocketman' or class == '3' found = CLASS_SOLDIER;
else if class == 'demoman' or class == 'detonator' or class == '5' found = CLASS_DEMOMAN;
else if class == 'heavy' or class == 'overweight' or class == '4' found = CLASS_HEAVY;
else if class == 'spy' or class == 'infiltrator' or class == '8' found = CLASS_SPY;
else if class == 'pyro' or class == 'firebug' or class == '2' found = CLASS_PYRO;
else if class == 'medic' or class == 'healer' or class == '6' found = CLASS_MEDIC;
else if class == 'engineer' or class == 'constructor' or class == '7' found = CLASS_ENGINEER;
else if class == 'sniper' or class == 'rifleman' or class == '9' found = CLASS_SNIPER;
else if class == 'quote' or class == 'curly' or class == 'q' found = CLASS_QUOTE;

return found;


