import io.github.daveho.funwithsound.*;
import net.beadsproject.beads.core.*;
import net.beadsproject.beads.data.*;

// You may need to change this, depending on which drive letter
// is assigned to your USB flash drive.
final String SOUNDFONTS = "/home/dhovemey/SoundFonts";

// Soundfonts
final String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";
final String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";

FunWithSound fws = new FunWithSound(this);

class MyComp extends Composer {
  void create() {
    tempo(200, 8);  // 200 beats per minute, 8 beats per measure
    naturalMinor(57); // A minor, rooted at A3
    
    Instrument celesta = instr(FLUID, 9);
    Instrument marimba = instr(FLUID, 13);
    Instrument piano = instr(FLUID, 1);
    Instrument oboe = instr(FLUID, 69);
    Instrument drumkit = percussion(FLUID);
    Instrument pad = instr(FLUID, 89);
      
    double[][] slowProb = {
      { 4, 0.8 }, // 80% chance of creating a half note
      { 2, .3 },  // 30% chance of creating a quarter note
    };
    
    Figure slow1f = randomMelodicFigure(slowProb, true, .2, 8, celesta);
    Figure slow2f = randomMelodicFigure(slowProb, true, .2, 8, marimba);
    
    Figure slowf = gf(slow1f, slow2f);
    
    double[][] fastProb = {
      { 1, .7 },
      { .5, .5 },
      { .25, .1 },
    };
    
    Figure fast1f = xf(2, randomMelodicFigure(fastProb, false, .05, 8, piano));
    Figure fast2f = xf(0, randomMelodicFigure(fastProb, false, .1, 8, oboe));
    
    double[][] hihatProb = {
      { 1, .6, },   // 60% chance of creating an eighth note
      { .5, .4 },   // 40% chance of creating a sixteenth note
      { .25, .1 },  // 10% chance of creating a thirty-second note
    };
    Figure hihatf = randomPercussionFigure(hihatProb, 2, drumkit, 42);
    
    double[][] snareprob = {
      { .5, .9 },
    };
    Figure snaref = randomPercussionFigure(snareprob, 2, drumkit, 38);
    
    double[][] droneprob = {
      { 8, 1 },
    };
    Figure dronef = xf(-1, randomMelodicFigure(droneprob, false, .05, 8, pad));
    
    add1(gf(slowf));
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf(slowf,dronef));
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf(slowf,dronef,fast1f));
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf(slowf,dronef,fast1f,fast2f,hihatf));
    add1(gf());
    add1(gf(hihatf));
    add1(gf());
    add1(gf(hihatf));
    add1(gf());
    add1(gf(hihatf));
    add1(gf());
    add1(gf(slowf,dronef,fast1f,fast2f,hihatf,snaref));
    add1(gf());
    add1(gf(hihatf,snaref));
    add1(gf());
    add1(gf(hihatf,snaref));
    add1(gf());
    add1(gf(hihatf,snaref));
    add1(gf());
    add1(gf(slowf,dronef));
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
    add1(gf());
  }
  
  Rhythm randomRhythm(double[][] prob, boolean allowOverlap) {
    Rhythm result = r();
    
    int beatsPerMeasure = getComposition().getTempo().getBeatsPerMeasure();
    
    // Consider placing a strike at all possible 64th note positions
    int i = 0;
    while (i < 64) {
      boolean placed = false;
      // Check the probability table
      for (int j = 0; j < prob.length && !placed; j++) {
        // See if this beat matches the multiple in the table
        if (isMatch(i, prob[j][0], beatsPerMeasure)) {
          // Roll the dice, see if we should place a stike here
          if (random(1.0) < prob[j][1]) {
            int rvel = 96 + int(random(32));
            Strike s = s((i/64.0)*beatsPerMeasure, prob[j][0], rvel);
            result.add(s);
            placed = true;
            // If note overlap is not allowed, advance i so that the next
            // strike will (at the earliest) happen after the end of the
            // current strike
            if (!allowOverlap) {
              i += (int)((prob[j][0]/beatsPerMeasure)*64);
            }
          }
        }
      }
      // If either
      // - we didn't place a strike on this beat, or
      // - overlap is allowed
      // then advance to the next 64th note position
      if (!placed || allowOverlap) { i++; }
    }
    
    return result;
  }
  
  // Determine if beat i (out of 64) aligns with given alignment beat.
  boolean isMatch(int i, double beat, int beatsPerMeasure) {
    // Special case: if beat==beatsPerMeasure, that is true IFF
    // i==0.  (I.e., it's only true for the beat at the very
    // beginning of the measure.)
    if (beat == (double)beatsPerMeasure) {
      return i == 0;
    }
    
    // Convert beat from "out of 64" to "out of [beatsPerMeasure]"
    double iBeat = (i/64.0) * 8.0;
    double where = 0;
    while (where < beatsPerMeasure) {
      if (iBeat == where) {
        return true;
      }
      where += beat;
    }
    return false;
  }
  
  Melody randomMelody(int numNotes, double upDownProb) {
    Melody result = new Melody();
    
    for (int i = 0; i < numNotes; i++) {
      int note = int(random(7));
      int updown = (random(1.0) < .5) ? 1 : -1;
      int octave = 0;
      while (octave >= -2 && octave <= 2 && random(1.0) < upDownProb) {
        octave += updown;
      }
      int effectiveNote = note + updown*octave*7;
      result.add(n(effectiveNote));
    }
    
    return result;
  }
  
  Figure randomMelodicFigure(double[][] prob, boolean allowOverlap, double upDownProb, int numMeasures, Instrument instrument) {
    int beatsPerMeasure = getComposition().getTempo().getBeatsPerMeasure();
    
    Figure[] measureFigs = new Figure[numMeasures];
    
    for (int i = 0; i < numMeasures; i++) {
      Rhythm randr = sr(i * beatsPerMeasure, randomRhythm(prob, allowOverlap));
      Melody randm = randomMelody(randr.size(), upDownProb);
      Figure randf = f(randr, randm, instrument);
      measureFigs[i] = randf;
    }
    
    Figure result = gf(measureFigs);
    println("// Melodic figure:");
    printFigureRhythmAndMelody(result);
    return result;
  }
  
  Figure randomPercussionFigure(double[][] prob, int numMeasures, Instrument instrument, int note) {
    int beatsPerMeasure = getComposition().getTempo().getBeatsPerMeasure();

    Figure[] measureFigs = new Figure[numMeasures];
    
    for (int i = 0; i < numMeasures; i++) {
      Rhythm randr = sr(i * beatsPerMeasure, randomRhythm(prob, false));
      Figure randf = pf(randr, note, instrument);
      measureFigs[i] = randf;
    }
    
    Figure result = gf(measureFigs);
    println("// Percussion figure:");
    printFigureRhythmAndMelody(result);
    return result;
  }
  
  void printFigureRhythmAndMelody(Figure fig) {
    println("Rhythm rhythm = gr(");
    boolean firstR = true;
    for (SimpleFigure sf : fig) {
      if (!firstR) {
        print(", ");
      } else {
        firstR = false;
      }
      print(ConvertToCode.toCode(sf.getRhythm(), getComposition().getTempo(), false));
    }
    println("\n);");
    
    println("Melody melody = gm(");
    boolean firstM = true;
    for (SimpleFigure sf : fig) {
      if (!firstM) {
        print(", ");
      } else {
        firstM = false;
      }
      print(ConvertToCode.toCode(sf.getMelody(), getComposition().getScale(), false));
    }
    println("\n);");
  }
}

MyComp c;

void setup() {
  size(600,200);
  textSize(32);
  fill(0);
  text("Click to start playing", 125, 140); 
  //c.create();
}


void draw() {
}

void mouseClicked() {
  randomSeed(123); // <-- change this to get a different "random" composition
  c = new MyComp();
  c.create();
  fws.play(c);
  //fws.saveWaveFile(c, "/home/dhovemey/randomComposition.wav");
}