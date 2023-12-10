class Player {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector recoil = new PVector(0, 0);
  int coyoteTime; //coyote time - frames the player can jump after leaving an edge
  int pNum; //player number identifier
  int health = 100; //player health
  float FRICTION = 0.8; //the rate at which the player decelerates
  float MOVESPEED = 1; //the rate at which the player accelerates
  float GRAVITY = 1;
  float SIZE = 25;
  
  boolean onGround = false; //if the player is on the ground
  int jumpHold = 0; //the time in frames that the player has held jump down
  float gravMult = 1; //lower multiplier means less gravity. Used for variable jump height.
  
  int reload = 0;
  int weapon = 0;
  int ammo = 8;
  int maxAmmo = 8; //ammo maximmum, changes with weapon
  int maxReload = 120; //time in frames to reload a fresh clip, changes with weapon
  int clipsLeft = 0; //number of clips left before the weapon resets to default
  
  Player(float x, float y, int playerNumber, int pHealth) {
    pos.set(x, y);
    vel.set(0, 0);
    pNum = playerNumber;
    health = pHealth; //setup player
    changeWeapon(0); //reset weapon
    coyoteTime = 6; //reset coyote time
    
  }
  
  void display(float x, float y) {
    stroke(0);
    rect(x, y, SIZE, SIZE); //draw the player - TO BE UPDATED AFTER I ADD ART
  }
  
  void displayHealth(float x, float y, int pHealth) {
    stroke(0);
    fill(255, 0, 0);
    rect(x, y - 30, 50, 5);
    stroke(0);
    fill(0 + 2.55 * (100 - pHealth), 255, 0); //health bar gets yellower as it decreases
    rect(x, y - 30, pHealth / 2, 5);
  }
  
  void displayAmmo(float x, float y, int ammo, boolean doReload) {
    stroke(0);
    noFill();
    rect(x, y - 20, 50, 5);
    stroke(0);
    if(doReload) { //if the weapon doesn't need to reload
      fill(255, 255, 0);
      rect(x, y - 20, (float(ammo) / float(maxAmmo)) * 50, 5); //get percentage of remaining ammo by dividing current by maximum, then multiply by 50 to get bar width
    } else {
      fill(225, 225, 0);
      rect(x, y - 20, 50 - ((float(reload) / float(maxReload)) * 50), 5); //we convert to float to allow for precise division, use 50 - percentage of reload so that the bar fills up instead of draining
    }
    
    fill(255, 255, 0);
    for(int i = 0; i < clipsLeft; i++) {
      rect(x - 22 + 5 * i, y - 25, 3, 3); //display clips left
    }
    
    noFill();
  }
  
  void move(int horizontal, int vertical, /*<<<Maybe unnecessary?*/ boolean jumping) {
    if(jumping /*jumping, change key later */ && ((onGround && jumpHold == 0) /*just standing on ground */ || (jumpHold < 15 && jumpHold >= 0) /*held jump is between 0 and 15 */)) {
      if(onGround) {
        vel.y = -15;
        onGround = false; //jump
      }
      jumpHold ++;
      if(jumpHold == 15) { //at max value
        jumpHold = -1;
        gravMult = 1; //reset gravity
      } else {
        gravMult = 0.5; //lower gravity on the way up if jump is held
      }
    } else if(!jumping) { //if jump is not held (change when jump key is added)
      if(jumpHold > 0) {
        jumpHold = -2; //lower than normal
        gravMult = 1; //reset gravity. jumpHold sets to -2 to prevent holding jump to keep jumping as soon as you hit ground. Change this or add buffering, OR ELSE.
      }
    }
    
    vel.add(horizontal * MOVESPEED, GRAVITY * gravMult /*This is where gravity will go*/);
    vel.x *= FRICTION; //decrease x velocity
    pos.x += vel.x; //update position
    if(checkCollision(pos.x, pos.y, SIZE)) {
      pos.x -= vel.x;
      vel.x = 0;
    } //horizontal collision
        
    pos.y += vel.y; //vertical collision
    if(checkCollision(pos.x, pos.y, SIZE)) { //check if player is on ground based on position
      if(vel.y > 0) {
        onGround = true; //Update the player's "grounded" state if they've just landed on the ground
        coyoteTime = 6; //6 frames of grace - 1/10th of a second
        if(jumpHold > -2 && !jumping) {
          jumpHold = 0;
          gravMult = 1;
        } //make sure the player can jump after releasing jump on ground
        if(jumpHold < -1) {
          jumpHold = 0;
        }
      }
      vel.y *= -1; //invert y velocity to "bounce back"
      pos.y += vel.y; //change y position to guarantee the player doesn't get "stuck"
      if(checkCollision(pos.x, pos.y, SIZE)) {
        pos.y -= 1; //just in case, if the player is still stuck they should be pushed upwards, since they will never get stuck in the ceiling
      }
      pos.y = round(pos.y);
      vel.y = 0; //Reset y velocity to prevent bouncing
    } else {
      if(coyoteTime == 0) { //if no more grace frames are left
        onGround = false;
      } else {
        coyoteTime --; //reduce coyote time
      }
    }
    
    
    pos.set(constrain(pos.x, 13, width - 13), constrain(pos.y, 13, height - 13)); //keep the players in bounds
  }
  
  boolean checkCollision(float pX, float pY, float size) { //collision detection. Reused for bullets.
    for(int i = 0; i < tiles.size(); i++) { //iterate over all tile objects
      Tile current = tiles.get(i);
      float tX = current.pos.x;
      float tY = current.pos.y;
      float tW = current.dimensions.x;
      float tH = current.dimensions.y; //set up variables for readability
      if(pX + size / 2 > tX - tW / 2 && pX - size / 2 < tX + tW / 2 && pY + size / 2 > tY - tH / 2 && pY - size / 2 < tY + tH / 2) { //check if player center within bounds
        return true;
      }
    }
    return false;
  }
      
    
    /*if(y > height / 2) { //At the moment, just check if players are below the midway point on the screen. //IRRELEVANT
      return true;
    } else {
      return false;
    }
  } */
  
  int getPlayerAngle(int horizontal, int vertical, int prevAngle) { //figure out what angle the player is aiming at, based on horizontal and directional movement
    int angle = prevAngle;
    if(abs(horizontal) + abs(vertical) > 0) {
      angle = 0;
    }
    if(abs(horizontal) > 0) {
      if(horizontal < 0) {
        angle = 180;
      }
      if(abs(vertical) > 0) {
        angle += 45 * horizontal * vertical;
      }
    } else if(abs(vertical) > 0) {
      if(vertical > 0) {
        angle = 90;
      } else {
        angle = -90;
      }
    }
    
    return angle; //angle returned in degrees
  }
  
  void changeWeapon(int pWeapon) {
    weapon = pWeapon;
    
    switch(pWeapon) {
      
      case 0:
        maxReload = 120;
        maxAmmo = 8;
        clipsLeft = 0; //default pistol. Set reload to maximum every time a new weapon is picked up, so that players can't immediately start using it.
        break;
      case 1:
        maxReload = 240; //good rule of thumb: ammo * time between shots = clip reload time
        maxAmmo = 4; //half of default
        clipsLeft = 2; //12 shots max = 360 total damage = 120 per clip: default is 80 per
        break;
      case 2:
        maxReload = 300;
        maxAmmo = 100;
        clipsLeft = 1; //600 shots max = 600 total damage = 300 per clip - too much?
        break;
      case 3:
        maxReload = 360;
        maxAmmo = 1;
        clipsLeft = 5;
        break;
      case 4:
        maxReload = 250;
        maxAmmo = 10;
        clipsLeft = 2;
        break;
      case 5:
        maxReload = 270;
        maxAmmo = 6;
        clipsLeft = 2;
        break;
      case 6:
        maxReload = 160;
        maxAmmo = 8;
        clipsLeft = 4;
        break;
      case 7:
        maxReload = 100;
        maxAmmo = 10;
        clipsLeft = 5;
        break;
      case 8:
        maxReload = 250;
        maxAmmo = 5;
        clipsLeft = 2;
        break;
      case 9:
        maxReload = 300;
        maxAmmo = 5;
        clipsLeft = 3;
        break;
      
      default:
        println("Invalid weapon");
        break;
    }
    
    reload = maxReload;
    if(weapon > 0) {
      ammo = 0; //reset ammo if weapon is not default
    }
  }
  
  void shoot(int weapon, int angle, int team, int vertical) {
    recoil = PVector.fromAngle(radians((180 - angle) * -1)); //get a PVector from the player's shot angle, invert it, and BOOM - recoil!
    float variance = 0; //angle variance
    
    switch(weapon) {
      
      case 0: //basic pistol
        reload = 30; //30 frames of delay between shots - 0.5s
        variance = 2; //2 degrees of angle variance/spread
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 10, 10, 20, 0, 0, 1, 0, 1, team));
        recoil.mult(2); //2x recoil multiplier
        break;
      case 1:
        reload = 60; //1s
        variance = 2; //2 degrees
        bullets.add(new Bullet(pos.x, /*x */ pos.y, /*y */ radians(angle + random(-variance, variance)), /*angle (degrees) */ 30, /*damage */ 15, /*size */ 10, /*initial velocity */ 10, /*initial y velocity, useful for weapons with drop */ 0, /*bullet spawn delay */ 3, /*max bounces */ 1, /*gravity */ 0.99, /*air friction */ 1 /*team */));
        recoil.mult(15); //15x recoil
        break;
      case 2:
        reload = 3; //0.05s
        variance = 3; //3 deg
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 1, 5, 15, 0, 0, 1, 0, 1, team));
        recoil.mult(2.2); //2.2x recoil
        break;
      case 3:
        reload = 150; //2.5s
        variance = 0; //perfect accuracy
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 40, 6, 24, 0, 0, 3, 0, 1, team));
        recoil.mult(18); //18x recoil :skull:
        break;
      case 4:
        reload = 25; //~0.45s
        variance = 1;
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 15, 12, 2, 0, 0, 1, 0, 1.025, team));
        recoil.mult(3);
        break;
      case 5:
        reload = 45; //0.75s
        variance = 1.5;
        angle -= 6;
        for(int i = 0; i < 5; i++) {
          bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance) + i * 3), 8, 8, 24, 0, 0, 2, 0, 0.9, team));
        }
        recoil.mult(17);
        break;
      case 6:
        reload = 20; //0.33...s
        variance = 3; //potential 18 degree spread??? :Pogchamp:
        angle -= 6;
        for(int i = 0; i < 4; i++) {
          bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance) + i * 4), 4, 8, 24, 0, 0, 3, 0, 0.92, team)); //longer range and faster firing shotgun than weap 5, and give 'em 2 bounces just for fun
        }
        recoil.mult(10); //way less recoil than weap 5
        break;
      case 7:
        reload = 10; //0.15...s
        variance = 8; //HUGE spread for a chaotic gun
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 8, 10, 18, 0, 0, 5, 0, 1, team));
        recoil.mult(3.5);
        break;
      case 8:
        reload = 50; //~0.8s
        variance = 2;
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 20, 12, 18, 12, 0, 5, 1, 0.98, team));
        recoil.mult(6);
        break;
      case 9:
        reload = 60; //1s
        variance = 1;
        for(int i = 0; i < 3; i++) {
          bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 5, 10, 17, 0, i * 5, 1, 0, 1, team));
        }
        recoil.mult(3);
        break;
        
      default:
        println("Invalid weapon");
        break;
    }
    
    vel.x += recoil.x;
    if(vertical == 1) {  
      vel.y = recoil.y / 1; //may change if necessary
    } else {
      vel.y += recoil.y / 1; //may change if necessary
    }
    if(recoil.y < 0) {
      //onGround = false;
      jumpHold = 14;
    }
  }
}

  
  
