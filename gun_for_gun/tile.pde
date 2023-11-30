class Tile {
  
  PVector pos = new PVector(0, 0);
  PVector dimensions = new PVector(0, 0);
  
  Tile(float x, float y, float w, float h) {
    pos.set(x, y);
    dimensions.set(w, h); //define x, y, width and height as PVectors
    
  }
  
  void display(float x, float y, float w, float h) {
    noFill();
    stroke(0);
    rect(x, y, w, h); //display rectangle primitive
  }
  
}
