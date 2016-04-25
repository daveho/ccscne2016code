tempo(200, 4);
Instrument drumkit = percussion(TR808);

Rhythm kickr = r(p(0), p(1), p(4), p(4.5));
Figure kickf = pf(kickr, 36, drumkit);
Rhythm snarer = r(p(2), p(6));
Figure snaref = pf(snarer, 38, drumkit);
Rhythm hihatr = r(p(.5), p(.75), p(1), p(1.5), p(2), p(2.5));
Figure hihatf = pf(hihatr, 42, drumkit);
Rhythm hihat2r = r(s(4, 1), s(5.5, 1));
Figure hihat2f = pf(hihat2r, 46, drumkit);

Figure percf = gf(kickf, snaref, hihatf, hihat2f);

add1(gf(percf));
add1(gf());
add1(gf(percf));
add1(gf());
