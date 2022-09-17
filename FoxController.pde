
// Add your code to this class.

class FoxController {

  Fox fox;
  Map map;
  ArrayList<Trap> traps;
  ArrayList<Collectible> collectibles;

  ArrayList<Float> angles;

  float foxX;
  float foxY;
  float foxRadius;
  // Add new variables, if necessary
  boolean isFirstStep = true;

  int nextDirection;

  PVector nextTarget;

  float nextTargetAngle;

  float prevDistTrap = 99999;

  int nextMovement;
  int nextTargetMovement;
  int prevTargetMovement;

  boolean wasOnTrap = false;

  int randomState = 0;

  String movements[]  = {"", "RIGHT", "LEFT", "UP", "DOWN"};

  FoxController(Fox fox, Map map) {
    this.fox = fox;
    this.map = map;
    traps = map.getTraps();
    foxRadius = fox.getCollisionRadius();
    angles = new ArrayList<Float>();
  }

  // Do not change this method
  void step() {
    collectibles = map.getCollectibles();
    nextTarget=new PVector(getClosestCollectible().x, getClosestCollectible().y);
    nextTargetAngle = getCurrentAngle();
    foxX = fox.getCenterX();
    foxY = fox.getCenterY();
    action();
  }

  void action() {
    //fox.move(fox.UP);
    if (isFirstStep) readScene();
    isFirstStep=false;
    /*
    beginShape();
     noFill();
     vertex(width/2, height/2);
     for (Collectible c : collectibles) {
     vertex(c.x, c.y);
     }
     endShape();
     */

    float angle = getCurrentAngle();
    println(angle);

    PVector dist = distNextTarget();
    // println("dist", dist);

    stroke(0, 0, 255);
    noFill();



    if (randomState == 0) {
      triangle(foxX, foxY, nextTarget.x, nextTarget.y, foxX-dist.x, nextTarget.y+dist.y);
      // walking on straight lines
      if (dist.x > -foxRadius && dist.x < foxRadius) {
        if (dist.y < 0) {
          nextTargetMovement=fox.DOWN;
        } else {
          nextTargetMovement=fox.UP;
        }
      } else {
        if (foxX < foxX-dist.x) {
          nextTargetMovement=fox.RIGHT;
        } else {
          nextTargetMovement=fox.LEFT;
        }
      }
    } else {
      triangle(foxX, foxY, nextTarget.x, nextTarget.y, foxX, nextTarget.y);
      // walking on straight lines
      if (dist.x > -foxRadius && dist.x < foxRadius) {
        if (dist.y < 0) {
          nextTargetMovement=fox.DOWN;
        } else {
          nextTargetMovement=fox.UP;
        }
      } else {
        if (foxX < foxX-dist.x) {
          nextTargetMovement=fox.RIGHT;
        } else {
          nextTargetMovement=fox.LEFT;
        }
      }
    }


    text("nextTargetMovement:" + movements[nextTargetMovement], foxX, foxY-30);

    if (distanceToClosestTrap() < 80) {
      prevDistTrap = distanceToClosestTrap();
      Trap closestTrap = getClosestTrap();
      PVector trapDist = PVectorToClosestTrap();
      println("CLOSE TRAP!!!", PVectorToClosestTrap());
      stroke(255, 0, 0);
      noFill();
      triangle(foxX, foxY, closestTrap.x, closestTrap.y, foxX-trapDist.x, getClosestTrap().y+trapDist.y);

      if (prevTargetMovement == fox.DOWN || prevTargetMovement == fox.UP) {
        // if it was going left or right, escape from trap by going up or down
        text("RUN AWAY SIDE", foxX +20, foxY);
        if (trapDist.x > 0) {
          nextMovement=fox.RIGHT;
        } else {
          nextMovement=fox.LEFT;
        }
      } else if (prevTargetMovement == fox.LEFT || prevTargetMovement == fox.RIGHT) {
        // if it was going up or down, escape from trap by going left or right
        text("RUN AWAY VERTICAL", foxX +20, foxY);
        if (trapDist.y > 0) {
          nextMovement=fox.DOWN;
        } else {
          nextMovement=fox.UP;
        }
      }
      randomState=int(random(1));
    } else {
      prevTargetMovement=nextTargetMovement;
      nextMovement = nextTargetMovement;
    }

    fox.move(nextMovement);

    // Add your code here!

    // All necessary input information is in
    // - collectibles
    // - traps
    // - foxX, foxY, foxRadius

    // Fox is moved by
    // - fox.move(fox.UP);
    // - fox.move(fox.DOWN);
    // - fox.move(fox.LEFT);
    // - fox.move(fox.RIGHT);
  }

  void readScene () {
    noFill();
    PVector lastPVector = new PVector(width/2, height/2);
    for (Collectible c : collectibles) {
      PVector currentPVector = new PVector(c.x, c.y);
      float a = PVector.angleBetween(currentPVector, lastPVector);
      lastPVector=currentPVector;
      angles.add(a);
      println("a", a);
    }
    //println(angles);
  }

  float getCurrentAngle () {

    float a1 = PVector.angleBetween(new PVector(foxX-width/2, foxY-height/2), new PVector(nextTarget.x-foxX, nextTarget.y-foxY));

    float a2 = PVector.angleBetween(new PVector(foxX-width/2, foxY-height/2), new PVector(nextTarget.x-foxX, nextTarget.y-foxY));
    return degrees(a1);
  }

  PVector distNextTarget() {
    return new PVector(foxX - nextTarget.x, foxY - nextTarget.y);
  }

  float distanceToClosestCollectible() {
    float dist = 999999;
    for (Collectible c : collectibles) {
      float d = dist(foxX, foxY, c.x, c.y);
      dist = min(dist, d);
    }
    return dist;
  }

  Collectible getClosestCollectible() {
    float dist = 999999;
    int closestCollectibleIndex = 0;
    for (int i = 0; i < collectibles.size(); i++) {
      Collectible c = collectibles.get(i);
      float d = dist(foxX, foxY, c.x, c.y);
      if (d < dist) {
        closestCollectibleIndex=i;
      }
      dist = min(dist, d);
    }
    return collectibles.get(closestCollectibleIndex);
  }

  Trap getClosestTrap() {
    float dist = 999999;
    int closestTrapIndex = 0;
    for (int i = 0; i < traps.size(); i++) {
      Trap t = traps.get(i);
      float d = dist(foxX, foxY, t.x, t.y);
      if (d < dist) {
        closestTrapIndex=i;
      }
      dist = min(dist, d);
    }
    return traps.get(closestTrapIndex);
  }

  float distanceToClosestTrap() {
    float dist = 999999;
    for (Trap t : traps) {
      float d = dist(foxX, foxY, t.x, t.y);
      dist = min(dist, d);
    }
    return dist;
  }


  PVector PVectorToClosestTrap() {
    return new PVector(foxX - getClosestTrap().x, foxY - getClosestTrap().y);
  }

  PVector nextTargetVector () {
    PVector target = new PVector (getClosestCollectible().x, getClosestCollectible().y);
    PVector origin = new PVector (foxX, foxY);
    PVector result = target.sub(origin);
    return result;
  }
}

float angleBetweenPV_PV(PVector a, PVector mousePV) {

  // calc angle : the core of the sketch

  PVector d = new PVector();

  // calc angle
  pushMatrix();
  translate(a.x, a.y);
  // delta
  d.x = mousePV.x - a.x;
  d.y = mousePV.y - a.y;
  // angle
  float angle1 = atan2(d.y, d.x);
  popMatrix();

  return angle1;
}
