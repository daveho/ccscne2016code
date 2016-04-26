tempo(200, 4);
melodicMinor(56); // A minor
Instrument drumkit = percussion(TR808);
Instrument bass = instr(FLUID, 39); // synth bass 1

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
Melody bass1m = m(-7, -7, -14, -7);     // m=create melody with specified notes/chords
Melody bass2m = m(-8, -15, -13, -6);    // note numbers are relative to scale's start note
Figure bass1f = f(bassr, bass1m, bass); // f=create melodic figure w/ rhythm, melody, instrument
Figure bass2f = f(bassr, bass2m, bass);

add1(gf(percf, bass1f));
add1(gf());
add1(gf(percf, bass2f));
add1(gf());
add1(gf(percf, bass1f));
add1(gf());
add1(gf(percf, bass2f));
add1(gf());
