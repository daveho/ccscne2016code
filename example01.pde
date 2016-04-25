tempo(200, 4);                              // 200 beats per minute, 4 beats per measure
Instrument drumkit = percussion(FLUID);     // percussion instrument

Rhythm kickr = r(p(0), p(1), p(4), p(4.5)); // r=create rhythm, p=create percussive strike
Figure kickf = pf(kickr, 36, drumkit);      // pf=create percussive figure
Rhythm snarer = r(p(2), p(6));
Figure snaref = pf(snarer, 38, drumkit);

Figure percf = gf(kickf, snaref);           // gf=combine figures into one figure

add1(gf(percf));                            // play percf at measure 0
add1(gf());
add1(gf(percf));                            // play percf at measure 2
add1(gf());
