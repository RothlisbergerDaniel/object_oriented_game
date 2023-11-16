class Player {
  
  PVector pPos = new PVector(0, 0);
  int pNum;
  float health;
  
  Player(float x, float y, int playerNumber, float pHealth) {
    pPos.set(x, y);
    pNum = playerNumber;
    health = pHealth;
    
  }
  
  
  
}
