tempo(200, 4);
Instrument drumkit = percussion(FLUID);

Rhythm kickr = r(p(0), p(1), p(4), p(4.5));
Figure kickf = pf(kickr, 36, drumkit);
Rhythm snarer = r(p(2), p(6));
Figure snaref = pf(snarer, 38, drumkit);

Figure percf = gf(kickf, snaref);

add1(gf(percf));
add1(gf());
add1(gf(percf));
add1(gf());
