int p1Horizontal;
int p1Vertical = 0;
boolean p1Jump = false;
boolean p1Shoot = false; //controls p1
int p1Aim = 0; //default aim direction
int p1LastVertical = 0; //for preventing superjumps :(
int p2Horizontal;
int p2Vertical = 0;
boolean p2Jump = false;
boolean p2Shoot = false; //controls p2
int p2Aim = 180; //default aim direction
int p2LastVertical = 0;

boolean inGame = false;

Player p1;
Player p2;
Crate crate;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Tile> tiles = new ArrayList<Tile>(); //change tile arraylist to a regular array! //define objects and object lists

PImage bg; //initialize PImage for background
PImage start; //same for start screen

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
  p1 = new Player(100, height / 2 + 72, 1, 100);
  p2 = new Player(width - 100, height / 2 + 72, 2, 100);
  crate = new Crate(width / 2, height / 2 + 84, 0, 600);
  rectMode(CENTER);
  createMap(); //load tiles
  
  imageMode(CENTER);
  bg = loadImage("gun_for_gun_bg.png"); //set background to bg image
  start = loadImage("gun_for_gun_title.png");
}

void draw() {
  background(150);
  image(bg, width / 2, height / 2);
  if(!inGame) {
    image(start, width / 2, height / 2);
    if(p1Shoot && p2Shoot) {
      reset();
      inGame = !inGame;
    }
  } else {
  
    p1.move(p1Horizontal, p1Vertical, p1Jump);
    p2.move(p2Horizontal, p2Vertical, p2Jump); //move players
  
    crate.update();
  
    p1Aim = p1.getPlayerAngle(p1Horizontal, p1Vertical, p1Aim);
    p2Aim = p2.getPlayerAngle(p2Horizontal, p2Vertical, p2Aim); //gets angle based on keys held
  
    p1.display(p1.pos.x, p1.pos.y, p1Aim);
    p1.displayHealth(p1.pos.x, p1.pos.y, p1.health);
    p1.displayAmmo(p1.pos.x, p1.pos.y, p1.ammo, p1.ammo > 0);
    p2.display(p2.pos.x, p2.pos.y, p2Aim); //show players
    p2.displayHealth(p2.pos.x, p2.pos.y, p2.health); //and player health
    p2.displayAmmo(p2.pos.x, p2.pos.y, p2.ammo, p2.ammo > 0); //and ammo
  
    if(p1Shoot && crate.checkCollision(crate.pos.x, crate.pos.y, p1.pos.x, p1.pos.y, crate.SIZE, p1.SIZE) && crate.life > 0) {
      if(crate.type == 0) { //weapon crate
        p1.changeWeapon(int(random(1, 10))); //change weapon from one to max + 1 - not including default weapon
        crate.life = int(random(3, 10)) * -60; //remove crate, set crate spawn delay to a random value between 3 and 10 seconds
      } else if(crate.type == 1 && p1.weapon > 0 && p1.clipsLeft < 10) { //if ammo recharge crate and not default weapon and not at max clips
        p1.clipsLeft ++; //add a full clip
        if(p1.ammo != 0) { //make sure the player's not already reloading
          p1.reload = p1.maxReload / p1.maxAmmo; //reset shot cooldown so that the player doesn't waste ammo picking up an ammo crate
        }
        crate.life = int(random(3, 10)) * -60; //reset crate
      }    
    }
    if(p2Shoot && crate.checkCollision(crate.pos.x, crate.pos.y, p2.pos.x, p2.pos.y, crate.SIZE, p2.SIZE) && crate.life > 0) {
      if(crate.type == 0) {
        p2.changeWeapon(int(random(1, 10)));
        crate.life = int(random(3, 10)) * -60;
      } else if(crate.type == 1 && p2.weapon > 0 && p2.clipsLeft < 10) {
        p2.clipsLeft ++;
        if(p2.ammo != 0) {
          p2.reload = p2.maxReload / p2.maxAmmo;
        }
        crate.life = int(random(3, 10)) * -60; //same again for p2
      }    
    }
  
    if(p1Shoot && p1.reload == 0 && p1.ammo > 0) {
      p1.shoot(p1.weapon, p1Aim, 1, p1LastVertical); //spawn bullets for current weapon
      p1.ammo --;
      if(p1.ammo == 0) {
        if(p1.clipsLeft > 0 && p1.weapon > 0) {
          p1.reload = p1.maxReload;
          p1.clipsLeft --;
        } else {
          p1.changeWeapon(0);
        }
      }
    } else if(p1.reload > 0) {
      p1.reload --; //reload if not ready to shoot
      if(p1.reload == 0 && p1.ammo == 0) {
        p1.ammo = p1.maxAmmo;
      }
    }
    if(p2Shoot && p2.reload == 0 && p2.ammo > 0) {
      p2.shoot(p2.weapon, p2Aim, 2, p2LastVertical);
      p2.ammo --;
      if(p2.ammo == 0) {
        if(p2.clipsLeft > 0 && p2.weapon > 0) { //if you're not using the default weapon and you still have clips left
          p2.reload = p2.maxReload;
          p2.clipsLeft --;
        } else { //otherwise, set to default values - starter pistol. All other weapons should have some advantage over this.
          p2.changeWeapon(0);
        }
      }
    } else if(p2.reload > 0) {
      p2.reload --;
      if(p2.reload == 0 && p2.ammo == 0) {
        p2.ammo = p2.maxAmmo;
      }
    }
    
  
    for(int i = 0; i < bullets.size(); i++) {
      Bullet current = bullets.get(i);
      current.move();
      current.display(current.pos.x, current.pos.y, current.size); //move and display bullets
    
      if(current.checkOffscreen(current.pos.x, current.pos.y) || current.checkPlayerHit(current.pos.x, current.pos.y, current.team) || current.bounces < 1 || current.vel.mag() < 0.01) { //if offscreen or can't bounce any more or bullet is moving too slowly
        if(current.checkPlayerHit(current.pos.x, current.pos.y, current.team)) { //specifically check if a player is hit
          if(current.team == 2) { //if p1 is hit
            p1.health -= current.damage; //damage p1
          } else { //otherwise damage p2
            p2.health -= current.damage;
          }
        }
      
        bullets.remove(i); //remove bullet
        i --; //decrement i to keep place in list
      
        if(p1.health < 1 || p2.health < 1) {
          //end game, return to menu;
          inGame = !inGame; //sets to false
          p1Shoot = false;
          p2Shoot = false; //prevent players from instantly starting a new game if shoot is still held down
          //break;
        }
      }
    }
  
    /*for(int i = 0; i < tiles.size(); i++) {
      Tile current = tiles.get(i);
      current.display(current.pos.x, current.pos.y, current.dimensions.x, current.dimensions.y);
    }*/ //disable displaying tiles - unnecessary after background has been added, and tiles don't need to be shown to have collision
  }
}

void reset() {
  noFill();
  noStroke();
  p1 = new Player(100, height / 2 + 72, 1, 100);
  p2 = new Player(width - 100, height / 2 + 72, 2, 100);
  crate = new Crate(width / 2, height / 2 + 84, 0, 600);
}

void createMap() {
  for(int i = 0; i < MAPHEIGHT; i++) { //vertical loop, iterates y times, where y is the height of the map
    for(int j = 0; j < MAPWIDTH; j++) { //horizontal loop, iterates x times, where x is the width of the map
      if(char(MAP.charAt(j + i * MAPWIDTH)) == 'x') {
        tiles.add(new Tile(32 * j + 16, 32 * i + 16, 32, 32));
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
  p2Horizontal = constrain(p2Horizontal, -1, 1); //keep movement in reasonable bounds
  
  p1Vertical = constrain(p1Vertical, -1, 1);
  if(abs(p1Vertical) > 0) {
    p1LastVertical = p1Vertical;
  }
  p2Vertical = constrain(p2Vertical, -1, 1); //keep movement in reasonable bounds
  if(abs(p2Vertical) > 0) {
    p2LastVertical = p2Vertical; //update last known vertical for recoil - I hate this fix
  }
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
