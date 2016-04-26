tempo(200, 4);
melodicMinor(56); // A minor
Instrument drumkit = percussion(TR808);
Instrument bass = instr(FLUID, 39); // synth bass 1
Instrument synth = instr(FLUID, 91); // pad 3 (polysynth) 

Rhythm kickr = r(p(0), p(1), p(4), p(4.5));
Figure kickf = pf(kickr, 36, drumkit);
Rhythm snarer = r(p(2), p(6));
Figure snaref = pf(snarer, 38, drumkit);
Rhythm hihatr = r(p(.5), p(.75), p(1), p(1.5), p(2), p(2.5));
Figure hihatf = pf(hihatr, 42, drumkit);
Rhythm hihat2r = r(s(4, 1), s(5.5, 2));
Figure hihat2f = pf(hihat2r, 46, drumkit);

Figure percf = gf(kickf, snaref, hihatf, hihat2f);

Rhythm bassr = r(s(0, .5), s(.5, .5), s(1.5, .5), s(2, .5));
Melody bass1m = m(-7, -7, -14, -7);
Melody bass2m = m(-8, -15, -13, -6);
Figure bass1f = f(bassr, bass1m, bass);
Figure bass2f = f(bassr, bass2m, bass);

Rhythm synthr = r(s(0, 2), s(2, 2), s(4, 2), s(6, 2));
Melody synth1m = m(3, 4, 2, 3);
Melody synth2m = m(1, 2, 0, 1);
Figure synth1f = f(synthr, synth1m, synth);
Figure synth2f = f(synthr, synth2m, synth);

add1(gf(percf, bass1f, synth1f));
add1(gf());
add1(gf(percf, bass2f, synth1f));
add1(gf());
add1(gf(percf, bass1f, synth2f));
add1(gf());
add1(gf(percf, bass2f, synth2f));
add1(gf());
