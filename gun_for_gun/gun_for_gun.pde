int p1Horizontal;
int p1Vertical;
boolean p1Jump = false;
boolean p1Shoot = false; //controls p1
int p1Aim = 0; //default aim direction
int p1Health = 100; //p1 health, default 100. May change if I add multiple characters.
int p1Ammo = 8; //p1 ammo, starts at 8
int p2Horizontal;
int p2Vertical;
boolean p2Jump = false;
boolean p2Shoot = false; //controls p2
int p2Aim = 180; //default aim direction
int p2Health = 100; //p2 health, default 100. Same as p1.
int p2Ammo = 8;

Player p1;
Player p2;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Tile> tiles = new ArrayList<Tile>(); //change tile arraylist to a regular array! //define objects and object lists

int MAPWIDTH = 40;
int MAPHEIGHT = 32; //Map width and height, in tiles
//            v v v v v v v v v v v v v v v v v v v v
String MAP = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" + /*This entire string is the*/
     /*2*/   "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" + /*map data. "x" represents */
             "xxxxxx000000000xxxxxxxxxx000000000xxxxxx" + /*a solid tile, "0" stands */
     /*4*/   "xxx000000000000000xxxx000000000000000xxx" + /*for empty air.           */
             "xx000000000000000000000000000000000000xx" +
     /*6*/   "xx000000000000000000000000000000000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*8*/   "xx000000000000000000000000000000000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*10*/  "xx0000000000000000xxxx0000000000000000xx" +
             "xx000000000000xxxxxxxxxxxx000000000000xx" +
     /*12*/  "xx0000000000000xxxxxxxxxx0000000000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*14*/  "xx000000000000000000000000000000000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*16*/  "xx0000000xxx0000000000000000xxx0000000xx" +
             "xx0000000xxx0000000000000000xxx0000000xx" +
     /*18*/  "xx000000000000000000000000000000000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*20*/  "xxxxxx0000000000xxxxxxxx0000000000xxxxxx" +
             "xxxxxx0000000000xxxxxxxx0000000000xxxxxx" +
     /*22*/  "xx00000000000000000xx00000000000000000xx" +
             "xx00000000000000000xx00000000000000000xx" +
     /*24*/  "xx00000000000000000xx00000000000000000xx" +
             "xx00000xxxxxxx00000xx00000xxxxxxx00000xx" +
     /*26*/  "xx000000xxxxx000000xx000000xxxxx000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*28*/  "xx000000000000000000000000000000000000xx" +
             "xx000000000000000000000000000000000000xx" +
     /*30*/  "xxxxxx000000000xxxxxxxxxx000000000xxxxxx" +
             "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" +
     /*32*/  "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" ;

void setup() {
  size(1280, 1024);
  background(150);
  noFill();
  noStroke();
  p1 = new Player(100, height / 2, 1, 100);
  p2 = new Player(width - 100, height / 2, 2, 100);
  rectMode(CENTER);
  createMap(); //load tiles
}

void draw() {
  background(150);
  
  p1.move(p1Horizontal, p1Vertical, p1Jump);
  p2.move(p2Horizontal, p2Vertical, p2Jump); //move players
  
  p1.display(p1.pos.x, p1.pos.y);
  p1.displayHealth(p1.pos.x, p1.pos.y, p1Health);
  p1.displayAmmo(p1.pos.x, p1.pos.y, p1Ammo, p1Ammo > 0);
  p2.display(p2.pos.x, p2.pos.y); //show players
  p2.displayHealth(p2.pos.x, p2.pos.y, p2Health); //and player health
  p2.displayAmmo(p2.pos.x, p2.pos.y, p2Ammo, p2Ammo > 0); //and ammo
  
  p1Aim = p1.getPlayerAngle(p1Horizontal, p1Vertical, p1Aim);
  p2Aim = p2.getPlayerAngle(p2Horizontal, p2Vertical, p2Aim); //gets angle based on keys held
  
  if(p1Shoot && p1.reload == 0 && p1Ammo > 0) {
    p1.shoot(p1.weapon, p1Aim, 1); //spawn bullets for current weapon
    p1Ammo --;
    if(p1Ammo == 0) {
      if(p1.clipsLeft > 0 && p1.weapon > 0) {
        p1.reload = p1.maxReload;
        p1.clipsLeft --;
      } else {
        p1.changeWeapon(0);
      }
    }
  } else if(p1.reload > 0) {
    p1.reload --; //reload if not ready to shoot
    if(p1.reload == 0 && p1Ammo == 0) {
      p1Ammo = p1.maxAmmo;
    }
  }
  if(p2Shoot && p2.reload == 0 && p2Ammo > 0) {
    p2.shoot(p2.weapon, p2Aim, 2);
    p2Ammo --;
    if(p2Ammo == 0) {
      if(p2.clipsLeft > 0 && p2.weapon > 0) { //if you're not using the default weapon and you still have clips left
        p2.reload = p2.maxReload;
        p2.clipsLeft --;
      } else { //otherwise, set to default values - starter pistol. All other weapons should have some advantage over this.
        p2.changeWeapon(0);
      }
    }
  } else if(p2.reload > 0) {
    p2.reload --;
    if(p1.reload == 0 && p1Ammo == 0) {
      p1Ammo = p2.maxAmmo;
    }
  }
    
  
  for(int i = 0; i < bullets.size(); i++) {
    Bullet current = bullets.get(i);
    current.move();
    current.display(current.pos.x, current.pos.y, current.size); //move and display bullets
    
    if(current.checkOffscreen(current.pos.x, current.pos.y) || current.checkPlayerHit(current.pos.x, current.pos.y, current.team) || current.bounces == 0) { //if offscreen or can't bounce any more
      if(current.checkPlayerHit(current.pos.x, current.pos.y, current.team)) { //specifically check if a player is hit
        if(current.team == 2) { //if p1 is hit
          p1Health -= current.damage; //damage p1
        } else { //otherwise damage p2
          p2Health -= current.damage;
        }
      }
      
      bullets.remove(i); //remove bullet
      i --; //decrement i to keep place in list
      
      if(p1Health < 1 || p2Health < 1) {
        //end game, return to menu;
        //break;
      }
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
