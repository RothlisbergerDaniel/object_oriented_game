class Player {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector recoil = new PVector(0, 0);
  int pNum; //player number identifier
  float health; //player health
  float FRICTION = 0.8; //the rate at which the player decelerates
  float MOVESPEED = 1; //the rate at which the player accelerates
  float GRAVITY = 1;
  float SIZE = 25;
  
  boolean onGround = false; //if the player is on the ground
  int jumpHold = 0; //the time in frames that the player has held jump down
  float gravMult = 1; //lower multiplier means less gravity. Used for variable jump height.
  
  int reload = 0;
  int weapon = 0;
  
  Player(float x, float y, int playerNumber, float pHealth) {
    pos.set(x, y);
    vel.set(0, 0);
    pNum = playerNumber;
    health = pHealth; //setup player
    
  }
  
  void display(float x, float y) {
    stroke(0);
    rect(x, y, SIZE, SIZE); //draw the player - TO BE UPDATED AFTER I ADD ART
  }
  
  void displayHealth(float x, float y, int health) {
    stroke(255, 0, 0);
    rect(x, y - 30, 50, 5);
    stroke(0 + 2.55 * (100 - health), 255, 0); //health bar gets yellower as it decreases
    rect(x, y - 30, health / 2, 5);
  }
  
  void displayAmmo(float x, float y, int ammo) {
    stroke(255, 150, 0);
    rect(x, y - 20, 50, 5);
    stroke(255, 255, 0);
    rect(x, y - 20, ammo / 2, 5);
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
      pos.y = round(pos.y);
      vel.y = 0; //Reset y velocity to prevent bouncing
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
  
  void shoot(int weapon, int angle, int team) {
    recoil = PVector.fromAngle(radians((180 - angle) * -1)); //get a PVector from the player's shot angle, invert it, and BOOM - recoil!
    int variance = 0; //angle variance
    
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
        bullets.add(new Bullet(pos.x, /*x */ pos.y, /*y */ radians(angle + random(-variance, variance)), /*angle (degrees) */ 20, /*damage */ 15, /*size */ 10, /*initial velocity */ 10, /*initial y velocity, useful for weapons with drop */ 0, /*bullet spawn delay */ 3, /*max bounces */ 1, /*gravity */ 0.99, /*air friction */ 1 /*team */));
        recoil.mult(15); //15x recoil
        break;
      case 2:
        reload = 3; //0.05s
        variance = 3; //3 deg
        bullets.add(new Bullet(pos.x, pos.y, radians(angle + random(-variance, variance)), 1, 5, 15, 0, 0, 1, 0, 1, team));
        recoil.mult(2.2); //2.2x recoil
        break;
        
      default:
        println("Invalid weapon");
        break;
    }
    
    vel.x += recoil.x;
    vel.y += recoil.y / 1; //may change if necessary
    if(recoil.y < 0) {
      //onGround = false;
      jumpHold = 14;
    }
  }
}

  
  
