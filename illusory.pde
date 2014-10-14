void setup() {
  size(screen.width, screen.height);
  background(125);
  fill(255);
  noLoop();
}

void draw() {
  //println("Hello ErrorLog!");

  stroke(0,0,0);
  for (float x= 0; x<screen.width; x+=50) {
    for (float y = 0; y<screen.height; y+=50) {
      float px = x;
      float py = random(screen.height);
      line(px, py);
    }
  }
}

void resize(float x, float y) {
  size(x,y);
}
