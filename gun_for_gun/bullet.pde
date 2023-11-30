class Bullet {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  
  float baseVel; //initial velocity, scalar
  int damage;
  float size;
  int delay; //delay between shots
  int team; //either 1 or 2
  int bounces; //times the bullet can deflect
  float gravity; //amount of gravity applied, 0 for no drop
  float friction; //air friction, 1 for neutral, <1 to make the bullet slow down as it flies, >1 to make it speed up (e.g. rockets)
  
  
  Bullet(float x, float y, float dir, int bulletDamage, float bulletSize, float velocity, float initY, int spawnDelay, int maxBounces, float grav, float frict, int bulletTeam) {
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
  }
  
  void move() {
    if(delay == 0) {
      vel.x *= friction;
      vel.y += gravity;
      
      pos.x += vel.x;
      if(p1.checkCollision(pos.x, pos.y, size)) { //hijack the collision detection script in class Player to save on space and improve readability
        vel.x *= -1;
        pos.x += vel.x;
        bounces --;
      }
      
      pos.y += vel.y;
      if(p1.checkCollision(pos.x, pos.y, size)) { //split x and y collision scripts into two parts to properly register horizontal and vertical bounces
        vel.y *= -1;
        pos.y += vel.y;
        if(gravity > 0) {
          vel.y *= 0.8;
        }
        bounces --;
      }
    }
  }
  
  void display(float x, float y, float size) {
    circle(x, y, size);
  }
  
  boolean checkOffscreen(float x, float y) {
    if(x < 0 || y < 0 || x > width || y > height) { //if bullet is offscreen
      return true;
    } else {
      return false;
    }
  }
  
  boolean checkPlayerHit(float x, float y, int team) {
    if(team == 2) {
      if(x > p1.pos.x - p1.SIZE / 2 - size && y > p1.pos.y - p1.SIZE / 2 - size && x < p1.pos.x + p1.SIZE / 2 + size && y < p1.pos.y + p1.SIZE / 2 + size) {
        return true;
      } else {
        return false;
      }
    } else {
      if(x > p2.pos.x - p2.SIZE / 2 - size && y > p2.pos.y - p2.SIZE / 2 - size && x < p2.pos.x + p2.SIZE / 2 + size && y < p2.pos.y + p2.SIZE / 2 + size) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  /*boolean checkCollision(float x, float y, float bSize) {
    
    if(p1.checkCollision(x, y, size)) { //hijack the collision detection script in class Player to save on space and improve readability
      return true; //if it returns true, pass the value forward
    }
    return false;
  }*/
    
  
}