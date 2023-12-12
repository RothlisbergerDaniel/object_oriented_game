class Crate {
  
  PVector pos = new PVector(0, 0);
  int life; //crate lifespan and spawn delay
  int type; //type of crate - weapon or ammo
  float[] spawnsX = new float[3];
  float[] spawnsY = new float[3]; //crate spawn positions, random each time
  int spawnPos;
  
  float SIZE = 20;
  
  PImage[] crates = new PImage[2];
  
  Crate(float x, float y, int dropType, int lifespan) {
    pos.set(x, y);
    life = lifespan;
    type = dropType;
    spawnsX[0] = x; //width / 2
    spawnsY[0] = y; //height / 2 + 86
    spawnsX[1] = width / 2;
    spawnsY[1] = 272;
    spawnsX[2] = width / 2;
    spawnsY[2] = height - 112; //set potential crate spawn points
    
    crates[0] = loadImage("gun_for_gun_crates0.png");
    crates[1] = loadImage("gun_for_gun_crates1.png"); //load crate images
    
  }
  
  void update() {
    if(life > 0) {
      life --;
      if(checkCollision(pos.x, pos.y, p1.pos.x, p1.pos.y, SIZE, p1.SIZE) || checkCollision(pos.x, pos.y, p2.pos.x, p2.pos.y, SIZE, p2.SIZE)) { //outline in white or something, idk
        stroke(255);
      } else {
        stroke(0);
      }
      tint(255, 255 - (300 - life) / 2);
      image(crates[type], pos.x, pos.y);
      tint(255, 255);
      strokeWeight(2);
      rect(pos.x, pos.y, SIZE, SIZE);
    } else if(life < 0) { //negative lifespan means the crate is on cooldown
      life ++;
      if(life == 0) { //if the crate has made it to neutral
         life = 600; //10 seconds, may change if it's too long or short later
         type = int(random(0, 2)); //0 = weapon, 1 = ammo for current weapon. High is 2 to allow even distribution
         spawnPos = int(random(0, 3));
         pos.set(spawnsX[spawnPos], spawnsY[spawnPos]);
      }
    } else {
      life = int(random(3, 10)) * -60; //set spawn delay to random value between 3 and 10 seconds
    }
    strokeWeight(1);
  }
  
  
  boolean checkCollision(float x, float y, float pX, float pY, float cSize, float pSize) { //collision detection. Reused for bullets.
   
    if(pX + pSize / 2 > x - cSize / 2 && pX - pSize / 2 < x + cSize / 2 && pY + pSize / 2 > y - cSize / 2 && pY - pSize / 2 < y + cSize / 2) { //check if player center within crate
      return true;
    }
    return false;
  }
  
}
