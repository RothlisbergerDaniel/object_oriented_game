int p1Horizontal;
int p1Vertical;
int p2Horizontal;
int p2Vertical;

Player p1;
Player p2;

void setup() {
  size(1280, 1024);
  background(150);
  noFill();
  noStroke();
  p1 = new Player(50, height / 2, 1, 100);
  p2 = new Player(width - 50, height / 2, 2, 100);
  rectMode(CENTER);
}

void draw() {
  background(150);
  
  p1.move(p1Horizontal, p1Vertical);
  p2.move(p2Horizontal, p2Vertical);
  
  p1.display(p1.pos.x, p1.pos.y);
  p2.display(p2.pos.x, p2.pos.y);
  
  
  
}

void keyPressed() {
  if(keyCode == LEFT) {
    p1Horizontal --;
  }
  if(keyCode == RIGHT) {
    p1Horizontal ++;
  }
  if(keyCode == UP) {
    p1Vertical --;
  }
  if(keyCode == DOWN) {
    p1Vertical ++;
  }
  
  if(key == 'd') {
    p2Horizontal --;
  }
  if(key == 'g') {
    p2Horizontal ++;
  }
  if(key == 'r') {
    p2Vertical --;
  }
  if(key == 'f') {
    p2Vertical ++;
  }
  
  p1Horizontal = constrain(p1Horizontal, -1, 1);
  p2Horizontal = constrain(p2Horizontal, -1, 1);
  
  p1Vertical = constrain(p1Vertical, -1, 1);
  p2Vertical = constrain(p2Vertical, -1, 1);
}

void keyReleased() {
  if(keyCode == LEFT) {
    p1Horizontal ++;
  }
  if(keyCode == RIGHT) {
    p1Horizontal --;
  }
  if(keyCode == UP) {
    p1Vertical ++;
  }
  if(keyCode == DOWN) {
    p1Vertical --;
  }
  
  if(key == 'd') {
    p2Horizontal ++;
  }
  if(key == 'g') {
    p2Horizontal --;
  }
  if(key == 'r') {
    p2Vertical ++;
  }
  if(key == 'f') {
    p2Vertical --;
  }
}
