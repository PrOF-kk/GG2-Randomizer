if argument4 == 0 {
    write_ubyte(argument3, LOADOUT_SYNC);
    write_ubyte(argument3, argument0);
    write_ubyte(argument3, argument1);
    write_ubyte(argument3, argument2);
} else {
    write_ubyte(argument3, RANDOMIZER_LOADOUT_SYNC);
    write_ubyte(argument3, argument0);
    write_ubyte(argument3, argument1);
    write_ubyte(argument3, argument2);
}
