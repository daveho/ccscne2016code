import io.github.daveho.funwithsound.*;

FunWithSound fws = new FunWithSound(this);

// Where the soundfonts are
String SOUNDFONTS = "/some/dir/FWS_Soundfonts";
// Very good general-purpose soundfont
String FLUID = SOUNDFONTS + "/fluid/FluidR3 GM2-2.SF2";
// TR-808 drum machine soundfont
String TR808 = SOUNDFONTS + "/tr808/Roland_TR-808_batteria_elettronica.sf2";

class MyComp extends Composer {
  void create() {
    // Composition goes here!
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
