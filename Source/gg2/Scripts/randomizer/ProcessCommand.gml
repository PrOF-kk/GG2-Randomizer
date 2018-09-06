// Takes user input and tries to guess what it is.
// argument0 = user input string

// First step: Parse the arguments
var numOfCommands, parseString, pos;
numOfCommands = 0;
input = 0;
parseString = argument0;

while string_count(" ", parseString) > 0
{
    pos = string_pos(" ", parseString)-1;
    //deal with strings (starting with a quote)
    if string_copy(parseString,1,1) == '"' {    //it's a string
        var quotePos;
        quotePos = string_pos('"',string_copy(parseString,2,string_length(parseString)))-1;
        if quotePos == -1 {
            input[numOfCommands] = string_copy(parseString, 2, string_length(parseString)-1);
            numOfCommands += 1;   
            parseString = ''; 
        } else {
            input[numOfCommands] = string_copy(parseString, 2, quotePos);
            numOfCommands += 1;   
            parseString = string_copy(parseString, quotePos+3, string_length(parseString)); 
        }      
    } else {
        input[numOfCommands] = string_copy(parseString, 1, pos);
        numOfCommands += 1;
        parseString = string_copy(parseString, pos+2, string_length(parseString));
    }
}

//get rid of extra quotes if there are no spaces left.
parseString = string_replace_all(parseString,'"','');

input[numOfCommands] = parseString// For the last argument, there's no ' ' left.
numOfCommands += 1;

while numOfCommands <= 10// Fill up until 10 arguments, that way there are no errors.
{
    input[numOfCommands] = ""
    numOfCommands += 1;
}

// Second step: Find out what command it is and execute it.

if ds_map_exists(global.commandDict, input[0])
{
    execute_string(ds_map_find_value(global.commandDict, input[0]));
}
else
{
    printChat("p[CONSOLE] Unknown command");
}

