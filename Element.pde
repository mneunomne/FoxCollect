// DO NOT CHANGE THIS FILE

abstract class Element {

  protected float x, y;
  protected float size;

  Element(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.size = radius;
  }

  abstract void draw();

  float getRadius() {
    return size;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
}

class Trap extends Element {
  Trap(float x, float y, float radius) {
    super(x,y,radius);
  }
  
  void draw() {
    ellipseMode(RADIUS);
    fill(0);
    ellipse(x, y, size, size);
  }
}

class Collectible extends Element {
  Collectible(float x, float y, float radius) {
    super(x,y,radius);
  }
  
  void draw() {
    ellipseMode(RADIUS);
    fill(255, 255, 0);
    ellipse(x, y, size, size);
  }
}
