tempo(200, 4);
Instrument drumkit = percussion(FLUID);

Rhythm kickr = r(p(0), p(1), p(4), p(4.5)); // r=create rhythm, p=create percussive strike
Figure kickf = pf(kickr, 36, drumkit);      // pf=create percussive figure, 36="Bass drum 1"
Rhythm snarer = r(p(2), p(6));
Figure snaref = pf(snarer, 38, drumkit);    // 38="Acoustic snare"

Rhythm hihatr = r(p(.5), p(.75), p(1), p(1.5), p(2), p(2.5));
Figure hihatf = pf(hihatr, 42, drumkit);      // note 42 is "closed hi-hat"
Rhythm hihat2r = r(s(4, 1), s(5.5, 2));       // s=strike (start beat, duration)
Figure hihat2f = pf(hihat2r, 46, drumkit);    // note 46 is "open hi-hat"

Figure percf = gf(kickf, snaref, hihatf, hihat2f);

add1(gf(percf));
add1(gf());
add1(gf(percf));
add1(gf());
