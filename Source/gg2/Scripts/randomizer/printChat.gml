var input, input2;
input = argument0;
if string_length(input) > 53 && string_count("/:",input) && string_count(":/",input) {
    input = string_copy(argument0,1,53+5);
    var pos;
    pos = string_pos('/:',argument0);
    if pos > 0 && string_copy(argument0,pos+3,2) == ':/' 
        input2 = string_copy(argument0,pos+2,1) + string_copy(argument0,54+5,60);
    else input2 = string_copy(argument0,1,1) + string_copy(argument0,54+5,60);
} else if string_length(input) > 53 {
    input = string_copy(argument0,1,53);
    input2 = string_copy(argument0,1,1) + string_copy(argument0,54,60);
} else input2 = "";

with (ConsoleWindow) {
    alarm[0]=120;
    idle = false;
}
ds_list_add(global.chatLog, input);
if input2 != "" ds_list_add(global.chatLog, input2);

