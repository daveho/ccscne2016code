Melody melody = new Melody();
for (int i = 0; i < 10; i++) {
  int note = int(random(20)) - 10;
  melody.add(n(note));     // n=choose note from composition's scale
}
