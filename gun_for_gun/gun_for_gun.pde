int p1Horizontal;
int p1Vertical;
boolean p1Jump = false;
boolean p1Shoot = false; //controls p1
int p1Aim = 0; //default aim direction
int p1Health = 100; //p1 health, default 100. May change if I add multiple characters.
int p2Horizontal;
int p2Vertical;
boolean p2Jump = false;
boolean p2Shoot = false; //controls p2
int p2Aim = 180; //default aim direction
int p2Health = 100; //p2 health, default 100. Same as p1.

Player p1;
Player p2;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Tile> tiles = new ArrayList<Tile>(); //define objects and object lists

int MAPWIDTH = 40;
int MAPHEIGHT = 32; //Map width and height, in tiles
//            v v v v v v v v v v v v v v v v v v v v
String MAP = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" + /*This entire string is the*/
     /*2*/   "x00000000000000000000000000000000000000x" + /*map data. "x" represents */
             "x00000000000000000000000000000000000000x" + /*a solid tile, "0" stands */
     /*4*/   "x00000000000000000000000000000000000000x" + /*for empty air.           */
             "x00000000000000000000000000000000000000x" +
     /*6*/   "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*8*/   "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*10*/  "x0000000000000x0000000000x0000000000000x" +
             "x0000000000000x0000000000x0000000000000x" +
     /*12*/  "x0000000000000x0000000000x0000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*14*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*16*/  "x00000000000x00000000000000x00000000000x" +
             "x000000000000x000000000000x000000000000x" +
     /*18*/  "x0000000000000xxxxxxxxxxxx0000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*20*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*22*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*24*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*26*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*28*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*30*/  "x00000000000000000000000000000000000000x" +
             "x00000000000000000000000000000000000000x" +
     /*32*/  "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ;

void setup() {
  size(1280, 1024);
  background(150);
  noFill();
  noStroke();
  p1 = new Player(50, height / 2, 1, 100);
  p2 = new Player(width - 50, height / 2, 2, 100);
  rectMode(CENTER);
  createMap(); //load tiles
}

void draw() {
  background(150);
  
  p1.move(p1Horizontal, p1Vertical, p1Jump);
  p2.move(p2Horizontal, p2Vertical, p2Jump); //move players
  
  p1.display(p1.pos.x, p1.pos.y);
  p2.display(p2.pos.x, p2.pos.y); //show players
  
  p1Aim = p1.getPlayerAngle(p1Horizontal, p1Vertical, p1Aim);
  p2Aim = p2.getPlayerAngle(p2Horizontal, p2Vertical, p2Aim); //gets angle based on keys held
  
  if(p1Shoot && p1.reload == 0) {
    p1.shoot(p1.weapon, p1Aim, 1); //spawn bullets for current weapon
  } else if(p1.reload > 0) {
    p1.reload --; //reload if not ready to shoot
  }
  if(p2Shoot && p2.reload == 0) {
    p2.shoot(p2.weapon, p2Aim, 2);
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
  
  for(int i = 0; i < tiles.size(); i++) {
    Tile current = tiles.get(i);
    current.display(current.pos.x, current.pos.y, current.dimensions.x, current.dimensions.y);
  }
  
}

void createMap() {
  for(int i = 0; i < MAPHEIGHT; i++) { //vertical loop, iterates y times, where y is the height of the map
    for(int j = 0; j < MAPWIDTH; j++) { //horizontal loop, iterates x times, where x is the width of the map
      if(char(MAP.charAt(j + i * MAPWIDTH)) == 'x') {
        tiles.add(new Tile(32 * j + 16, 32 * i +16, 32, 32));
      }
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
