int p1Horizontal;
int p1Vertical;
boolean p1Jump = false;
boolean p1Shoot = false;
int p1aim = 0;
int p2Horizontal;
int p2Vertical;
boolean p2Jump = false;
boolean p2Shoot = false;
int p2aim = 180;

Player p1;
Player p2;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

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
  
  p1.move(p1Horizontal, p1Vertical, p1Jump);
  p2.move(p2Horizontal, p2Vertical, p2Jump); //move players
  
  p1.display(p1.pos.x, p1.pos.y);
  p2.display(p2.pos.x, p2.pos.y); //show players
  
  p1aim = p1.getPlayerAngle(p1Horizontal, p1Vertical, p1aim);
  p2aim = p2.getPlayerAngle(p2Horizontal, p2Vertical, p2aim); //gets angle based on keys held
  
  if(p1Shoot && p1.reload == 0) {
    p1.shoot(p1.weapon, p1aim, 1); //spawn bullets for current weapon
  } else if(p1.reload > 0) {
    p1.reload --; //reload if not ready to shoot
  }
  if(p2Shoot && p2.reload == 0) {
    p2.shoot(p2.weapon, p2aim, 2);
  } else if(p2.reload > 0) {
    p2.reload --;
  }
    
  
  for(int i = 0; i < bullets.size(); i++) {
    Bullet current = bullets.get(i);
    current.move();
    current.display(current.pos.x, current.pos.y, current.size); //move and display bullets
    
    if(current.checkOffscreen(current.pos.x, current.pos.y) || current.checkPlayerHit(current.pos.x, current.pos.y, current.team) || current.bounces == 0) { //if offscreen or can't bounce any more
      bullets.remove(i); //remove bullet
      i --; //decrement i to keep place in list
    }
  }
  
  
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
  if(key == 'c') {
    p1Jump = true;
  }
  if(key == '5') {
    p1Shoot = true;
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
  if(key == '6') {
    p2Jump = true;
  }
  if(key == ']') {
    p2Shoot = true;
  }
  
  p1Horizontal = constrain(p1Horizontal, -1, 1);
  p2Horizontal = constrain(p2Horizontal, -1, 1);
  
  p1Vertical = constrain(p1Vertical, -1, 1);
  p2Vertical = constrain(p2Vertical, -1, 1); //keep movement in reasonable bounds
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
  if(key == 'c') {
    p1Jump = false;
  }
  if(key == '5') {
    p1Shoot = false;
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
  if(key == '6') {
    p2Jump = false;
  }
  if(key == ']') {
    p2Shoot = false;
  }
}
