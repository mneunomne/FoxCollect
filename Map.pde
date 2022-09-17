// DO NOT CHANGE THIS FILE

class Map {

  ArrayList<Collectible> collectibles;
  ArrayList<Trap> traps;
  float initialFoxDist = 128;
  float defaultObjectRadius = 20;
  float collisionDist;
  boolean gameOver = false;

  Map(Fox fox, int numOfCollectibles, int numOfTraps) {
    collectibles = new ArrayList<Collectible>();
    traps = new ArrayList<Trap>();
    for (int i=0; i<numOfTraps; i++) {
      Trap t = null;
      while (t == null) {
        t = new Trap(random(2*defaultObjectRadius, width-2*defaultObjectRadius),
          random(2*defaultObjectRadius, height - 2*defaultObjectRadius), defaultObjectRadius);
        if (dist(t.getX(), t.getY(), fox.getCenterX(), fox.getCenterY()) >= initialFoxDist)
          traps.add(t);
        else
          t = null;
      }
    }
    for (int i=0; i<numOfCollectibles; i++) {
      Collectible c = null;
      while (c == null) {
        c = new Collectible(random(2*defaultObjectRadius, width-2*defaultObjectRadius),
          random(2*defaultObjectRadius, height - 2*defaultObjectRadius), defaultObjectRadius);
        if (dist(c.getX(), c.getY(), fox.getCenterX(), fox.getCenterY()) >= initialFoxDist)
          collectibles.add(c);
        else
          c = null;
      }
    }
  }

  void update() {
    // Check for collectibles
    for (int i=collectibles.size()-1; i>=0; i--) {
      Collectible c = collectibles.get(i);
      if (dist(fox.getCenterX(), fox.getCenterY(), c.x, c.y) < fox.getCollisionRadius() + c.getRadius()) {
        collectibles.remove(i);
      }
    }
    // Check for traps
    for (Trap t : traps) {
      if (dist(fox.getCenterX(), fox.getCenterY(), t.x, t.y) < fox.getCollisionRadius() + t.getRadius()) {
        gameOver = true;
        break;
      }
    }
    // Update score
    // TODO
  }

  void draw() {
    for (Collectible c : collectibles)
      c.draw();
    for (Trap t : traps)
      t.draw();
  }

  ArrayList<Collectible> getCollectibles() {
    return new ArrayList<Collectible>(collectibles);
  }

  ArrayList<Trap> getTraps() {
    return new ArrayList<Trap>(traps);
  }

  boolean hasCollided() {
    return gameOver;
  }

  boolean allCollected() {
    return collectibles.size() == 0;
  }
}
