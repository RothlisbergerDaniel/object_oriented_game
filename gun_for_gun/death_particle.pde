class DeathParticle {
  
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  
  float friction;
  int team;
  
  DeathParticle(float x, float y, PVector velocity, float velMag, float airFriction, int pTeam) {
    pos.set(x, y);
    vel = velocity;
    vel.mult(velMag);
    friction = airFriction;
    team = pTeam;
  }
  
  void update(float size) {
    noStroke();
    if(team == 1) {
      fill(251, 107, 29); //p1 highlight red colour
    } else {
      fill(77, 155, 230); //p2 highlight blue colour
    }
    pos.x += vel.x;
    pos.y += vel.y;
    circle(pos.x, pos.y, size);
    vel.mult(friction);
    
  }
  
  
}
