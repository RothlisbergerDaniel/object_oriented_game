class Player {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  int pNum; //player number identifier
  float health; //player health
  float FRICTION = 0.8; //the rate at which the player decelerates
  float MOVESPEED = 1; //the rate at which the player accelerates
  float GRAVITY = 1;
  
  boolean onGround; //if the player is on the ground
  int jumpHold; //the time in frames that the player has held jump down
  float gravMult; //lower multiplier means less gravity. Used for variable jump height.
  
  Player(float x, float y, int playerNumber, float pHealth) {
    pos.set(x, y);
    vel.set(0, 0);
    pNum = playerNumber;
    health = pHealth; //setup player
    
  }
  
  void display(float x, float y) {
    stroke(0);
    rect(x, y, 25, 25); //draw the player - TO BE UPDATED AFTER I ADD ART
  }
  
  void move(int horizontal, int vertical) {
    if(vertical < 0 /*jumping, change key later */ && ((onGround && jumpHold == 0) /*just standing on ground */ || (jumpHold < 15 && jumpHold >= 0) /*held jump is between 0 and 15 */)) {
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
    } else if(vertical > -1) { //if jump is not held (change when jump key is added)
      if(jumpHold > 0) {
        jumpHold = -2; //lower than normal
        gravMult = 1; //reset gravity. jumpHold sets to -2 to prevent holding jump to keep jumping as soon as you hit ground. Change this or add buffering, OR ELSE.
      }
    }
    
    vel.add(horizontal * MOVESPEED, GRAVITY * gravMult /*This is where gravity will go*/);
    vel.x *= FRICTION; //decrease x velocity
    pos.add(vel); //update position
    
    if(checkOnGround(pos.x, pos.y)) { //check if player is on ground based on position
      if(vel.y > 0) {
        onGround = true; //Update the player's "grounded" state if they've just landed on the ground
        if(jumpHold > -2 && vertical > -1) {
          jumpHold = 0;
          gravMult = 1;
        } //make sure the player can jump after releasing jump on ground
        if(jumpHold < -1) {
          jumpHold = 0;
        }
      }
      vel.y *= -1; //invert y velocity to "bounce back"
      pos.y += vel.y; //change y position to guarantee the player doesn't get "stuck"
      vel.y = 0; //Reset y velocity to prevent bouncing
    }
    
    
    pos.set(constrain(pos.x, 13, width - 13), constrain(pos.y, 13, height - 13)); //keep the players in bounds
  }
  
  boolean checkOnGround(float x, float y) { //TO BE UPDATED AFTER I ADD TILE OBJECTS
    
    if(y > height / 2) { //At the moment, just check if players are below the midway point on the screen.
      return true;
    } else {
      return false;
    }
  }
  
  
  
}
