class Player {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  int pNum;
  float health;
  float FRICTION = 0.8;
  
  Player(float x, float y, int playerNumber, float pHealth) {
    pos.set(x, y);
    vel.set(0, 0);
    pNum = playerNumber;
    health = pHealth;
    
  }
  
  void display(float x, float y) {
    stroke(0);
    rect(x, y, 25, 25);
  }
  
  void move(int horizontal) {
    vel.add(horizontal, 0 /*This is where gravity will go*/);
    vel.mult(FRICTION);
    pos.add(vel);
    pos.set(constrain(pos.x, 13, width - 13), constrain(pos.y, 13, height - 13));
  }
  
  
  
}
