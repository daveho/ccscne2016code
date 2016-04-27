import io.github.daveho.funwithsound.*;
import java.util.*;

FunWithSound fws = new FunWithSound(this);

String SOUNDFONTS = "/home/dhovemey/SoundFonts";               // Where the soundfonts are
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";   // Very good general-purpose soundfont
String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";

class MyComp extends Composer {
  void create() {
    tempo(200, 4);
    naturalMinor(56); // A minor
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
  }
}

MyComp c = new MyComp();

// Data for piano roll visualization
Map<Instrument, Integer> instrMap = new HashMap<Instrument, Integer>();
color[] instrColors;
List<NoteEvent> noteEvents = new ArrayList<NoteEvent>();
int ticks;

void setup() {
  size(600, 450);
  c.create();
  fws.enableVis(FunWithSound.PIANO, false);
  frameRate(60);
  
  // Prepare piano roll visualization
  Iterator<PlayFigureEvent> it = c.getComposition().iterator();
  while (it.hasNext()) {
    PlayFigureEvent evt = it.next();
    Instrument instr = evt.getFigure().getInstrument();
    if (!instrMap.containsKey(instr)) {
      instrMap.put(instr, instrMap.size());
    }
  }
  instrColors = new color[instrMap.size()];
  for (int i = 0; i < instrColors.length; i++) {
    instrColors[i] = color(int(random(255)), int(random(255)), int(random(255)), 127);
  }
}

double TIME_PER_TICK = 1000000.0 / 60.0;

// Frame rate is 60
void draw() {
  background(200);
  textSize(32);
  fill(0);
  text("Click to start playing", 125, 190);
  
  if (noteEvents != null && !noteEvents.isEmpty()) {
    double curTime = ticks * TIME_PER_TICK;

    // How many notes are playing for each instrument
    int[] countOn = new int[instrMap.size()];
    // Timestamps of first note on event for each instrument
    long[] on = new long[instrMap.size()];
    
    for (NoteEvent evt : noteEvents) {
      // Draw notes based on on/off events
      int instrNum = instrMap.get(evt.instrument);
      if (evt.isNoteOn()) {
        if (countOn[instrNum] == 0) {
          on[instrNum] = evt.timeStamp;
        }
        countOn[instrNum]++;
      } else if (evt.isNoteOff()) {
        countOn[instrNum]--;
        if (countOn[instrNum] == 0) {
          drawNote(instrNum, on[instrNum], evt.timeStamp);
          on[instrNum] = 0L;
        }
      }
    }
    
    // Any notes still on?  If so, pretend they had note off events
    // occurring exactly now.
    for (int i = 0; i < instrMap.size(); i++) {
      if (countOn[i] > 0) {
        drawNote(i, on[i], (long) curTime);
      }
      //textSize(24);
      //fill(0);
      //text("" + countOn[i], 36 + i*80, 20);
    }
  }
  
  ticks++;
}

void drawNote(int instrNum, long startTimeUs, long endTimeUs) {
  int y1 = timeToY(startTimeUs);
  int y2 = timeToY(endTimeUs);
  int x = 20 + instrNum * 80;
  fill(instrColors[instrNum]);
  rect(x, y1, 60, y2-y1);
}

int timeToY(long ts) {
  // What time does the bottom of the window represent?
  double botTime = ticks * TIME_PER_TICK;
  
  // Determine time difference
  double timeDiff = botTime - ts;
  
  // Subtract one pixel per elapsed time
  return height - (int) (timeDiff / TIME_PER_TICK);
}

void mouseClicked() {
  if (!fws.isPlaying()) {
    noteEvents.clear();
    fws.play(c);
    ticks = 0;
  }
}

void onNoteEvent(NoteEvent evt) {
  //println("NoteEvent!");
  noteEvents.add(evt);
}