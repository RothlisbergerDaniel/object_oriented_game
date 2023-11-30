class Tile {
  
  PVector pos = new PVector(0, 0);
  PVector dimensions = new PVector(0, 0);
  
  Tile(float x, float y, float w, float h) {
    pos.set(x, y);
    dimensions.set(w, h);
    
  }
  
  void display(float x, float y, float w, float h) {
    noFill();
    rect(x, y, w, h);
  }
  
}
