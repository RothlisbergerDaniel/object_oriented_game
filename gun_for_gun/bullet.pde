class Bullet {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  
  float baseVel; //initial velocity, scalar
  int damage;
  float size;
  int delay; //delay between shots
  int team; //either 1 or 2
  int type; //bullet type
  int bounces; //times the bullet can deflect
  float gravity; //amount of gravity applied, 0 for no drop
  float friction; //air friction, 1 for neutral, <1 to make the bullet slow down as it flies, >1 to make it speed up (e.g. rockets)
  
  PImage[] bullets = new PImage[4]; //initialize bullet graphics container
  
  
  Bullet(float x, float y, float dir, int bulletDamage, float bulletSize, float velocity, float initY, int spawnDelay, int maxBounces, float grav, float frict, int bulletTeam, int bulletType) {
    pos.set(x, y);
    damage = bulletDamage;
    size = bulletSize;
    delay = spawnDelay;
    vel = PVector.fromAngle(dir);
    vel.mult(velocity);
    vel.y -= initY;
    bounces = maxBounces;
    gravity = grav;
    friction = frict;
    team = bulletTeam;
    type = bulletType;
    
    for(int i = 0; i < 4; i++) {
      bullets[i] = loadImage("gun_for_gun_bullets" + i + ".png"); //load images in a list
    }
  }
  
  void move() {
    if(delay == 0) {
      vel.mult(friction); //slow bullets down if air resistance is applied
      vel.y += gravity; //make them drop if gravity is applied
      
      pos.x += vel.x;
      if(p1.checkCollision(pos.x, pos.y, size)) { //hijack the collision detection script in class Player to save on space and improve readability
        vel.x *= -1;
        pos.x += vel.x; //push bullet out of the wall and back the way it came. Useful for especially slow projectiles.
        bounces --; //subtract bounces if applicable
      }
      
      pos.y += vel.y;
      if(p1.checkCollision(pos.x, pos.y, size)) { //split x and y collision scripts into two parts to properly register horizontal and vertical bounces
        vel.y *= -1;
        pos.y += vel.y;
        if(gravity > 0) {
          vel.y *= 0.8; //prevent bullets from maintaining vertical height or becoming super balls
        }
        bounces --;
      }
    } else {
      delay --;
      if(delay == 0) {
        if(team == 1) {
          pos.set(p1.pos);
        } else {
          pos.set(p2.pos); //set bullet position correctly when spawned
        }
      }
    }
  }
  
  void display(float x, float y, float size) {
    if(delay == 0) {
      stroke(0);
      //circle(x, y, size); //simple primitive for display
      pushMatrix();
      translate(x, y);
      rotate(vel.heading()); //point the bullet towards its heading
      image(bullets[type], 0, 0, bullets[type].width * (size / 10), bullets[type].height * (size / 10));
      popMatrix(); //push and pop to maintain regular transform
    }
  }
  
  boolean checkOffscreen(float x, float y) {
    if(x < 0 || y < 0 || x > width || y > height) { //if bullet is offscreen
      return true;
    } else {
      return false;
    }
  }
  
  boolean checkPlayerHit(float x, float y, int team) {
    if(team == 2) { //if the bullet belongs to p2, check for hits on p1
      if(x > p1.pos.x - p1.SIZE / 2 - size && y > p1.pos.y - p1.SIZE / 2 - size && x < p1.pos.x + p1.SIZE / 2 + size && y < p1.pos.y + p1.SIZE / 2 + size) { //if within bounds of player
        return true;
      } else {
        return false;
      }
    } else { //if the bullet belongs to p1, check for hits on p2
      if(x > p2.pos.x - p2.SIZE / 2 - size && y > p2.pos.y - p2.SIZE / 2 - size && x < p2.pos.x + p2.SIZE / 2 + size && y < p2.pos.y + p2.SIZE / 2 + size) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  /*boolean checkCollision(float x, float y, float bSize) { //irrelevant
    
    if(p1.checkCollision(x, y, size)) { //hijack the collision detection script in class Player to save on space and improve readability
      return true; //if it returns true, pass the value forward
    }
    return false;
  }*/
    
  
}
