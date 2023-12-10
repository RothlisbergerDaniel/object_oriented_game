class Crate {
  
  PVector pos = new PVector(0, 0);
  int life;
  int type;
  
  float SIZE = 20;
  
  Crate(float x, float y, int dropType, int lifespan) {
    pos.set(x, y);
    life = lifespan;
    type = dropType;
    
  }
  
  void update() {
    if(life > 0) {
      life --;
      if(checkCollision(pos.x, pos.y, p1.pos.x, p1.pos.y, SIZE, p1.SIZE) || checkCollision(pos.x, pos.y, p2.pos.x, p2.pos.y, SIZE, p2.SIZE)) { //outline in white or something, idk
        stroke(255);
      } else {
        stroke(0, 255 * type, 0);
      }
      rect(pos.x, pos.y, SIZE, SIZE);
    } else if(life < 0) { //negative lifespan means the crate is on cooldown
      life ++;
      if(life == 0) { //if the crate has made it to neutral
         life = 600; //10 seconds, may change if it's too long or short later
         type = int(random(0, 2)); //0 = weapon, 1 = ammo for current weapon. High is 2 to allow even distribution
      }
    } else {
      life = int(random(3, 10)) * -60; //set spawn delay to random value between 3 and 10 seconds
    }
  }
  
  
  boolean checkCollision(float x, float y, float pX, float pY, float cSize, float pSize) { //collision detection. Reused for bullets.
   
    if(pX + pSize / 2 > x - cSize / 2 && pX - pSize / 2 < x + cSize / 2 && pY + pSize / 2 > y - cSize / 2 && pY - pSize / 2 < y + cSize / 2) { //check if player center within crate
      return true;
    }
    return false;
  }
  
}
