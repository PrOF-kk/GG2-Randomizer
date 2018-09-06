with(argument0) {
    zoomed = !zoomed;
    if(zoomed) {
        runPower = runBkp-0.3;
        jumpStrength = 6;
    } else {
        runPower = runBkp;
        jumpStrength = 8;
    }
}
