import io.github.daveho.funwithsound.*;
import net.beadsproject.beads.core.*;
import net.beadsproject.beads.data.*;

FunWithSound fws = new FunWithSound(this) {
  protected Player createPlayer() {
    Player player = super.createPlayer();
    registerCustomInstruments(player);
    return player;
  }
};

String SOUNDFONTS = "/home/dhovemey/SoundFonts";               // Where the soundfonts are
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";   // Very good general-purpose soundfont
String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";

class MyComp extends Composer {
  void create() {
    tempo(200, 4);
    naturalMinor(56); // A minor
    Instrument drumkit = percussion(TR808);
    Instrument bass = instr(FLUID, 39); // synth bass 1
    //Instrument synth = instr(FLUID, 91); // pad 3 (polysynth)
    Instrument synth = custom(0);
    v(synth, 0.1); // the raw waveforms are super loud, quiet it down
    addfx(synth, new AddReverb()); // add reverb
    
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
  }
}

MyComp c = new MyComp();

void setup() {
  size(600, 200);
  textSize(32);
  fill(0);
  text("Click to start playing", 125, 140);
  c.create();
}

void draw() {
}

void mouseClicked() {
  fws.play(c);
}

void registerCustomInstruments(Player player) {
  CustomInstrumentFactory factory = new CustomInstrumentFactoryImpl(
    0, new CustomInstrumentFactoryImpl.CreateCustomInstrument() {
      public RealizedInstrument create(AudioContext ac) {
        DataBead params = Defaults.monosynthDefaults();
        params.put(ParamNames.GLIDE_TIME_MS, 80.0f);    // glide between notes (portamento)
        SynthToolkit tk = SynthToolkitBuilder.start()
          .withWaveVoice(Buffer.SAW)                    // use sawtooth waveform
          .withASRNoteEnvelope()                        // use attack/sustain/release envelope
          .getTk();
        MonoSynthUGen2 u = new MonoSynthUGen2(ac, tk, params,
          new double[]{ 1.0, 1.5, 2.0 },                // frequency multipliers
          new double[]{ 1.0, .5, .4 }                   // gain (volume) for each multiplier
        );
        return new RealizedInstrument(u, ac);
      }
    });
  player.setCustomInstrumentFactory(factory);
}
