
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
  
  boolean randomState = false;

  // just for better debuging
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
    
    // create distance vector to the next target collectable
    PVector dist = distNextTarget();

    // random state is a way to attempt a different triangle path after the fox waas close to the trap, avoiding most infinite loops (but apparenetly not all)
    if (randomState) {
      //debug triangle 
      //stroke(255, 0, 0);
      //triangle(foxX, foxY, nextTarget.x, nextTarget.y, foxX-dist.x, nextTarget.y+dist.y);
      
      // walking on straight lines...
      if (dist.y > -foxRadius && dist.y < foxRadius) {
        // first walk right left
        if (dist.x < 0) {
          nextTargetMovement=fox.RIGHT;
        } else {
          nextTargetMovement=fox.LEFT;
        }
      } else {
        // then up down
        if (dist.y < 0) {
          nextTargetMovement=fox.DOWN;
        } else {
          nextTargetMovement=fox.UP;
        }
      }
    } else {
      //debug triangle 
      //stroke(0, 255, 0);
      //triangle(foxX, foxY, nextTarget.x, nextTarget.y, foxX, nextTarget.y);
      
      // walking on straight lines
      if (dist.x > -foxRadius && dist.x < foxRadius) {
        // first walk up and down
        if (dist.y < 0) {
          nextTargetMovement=fox.DOWN;
        } else {
          nextTargetMovement=fox.UP;
        }
      } else {
        if (dist.x < 0) {
          nextTargetMovement=fox.RIGHT;
        } else {
          nextTargetMovement=fox.LEFT;
        }
      }
    }
    
    // if its close to a trap...
    if (distanceToClosestTrap() < 70) {
      prevDistTrap = distanceToClosestTrap();
      Trap closestTrap = getClosestTrap();
      PVector trapDist = PVectorToClosestTrap();

      //println("CLOSE TRAP!!!", PVectorToClosestTrap());
      //noFill();
      //triangle(foxX, foxY, closestTrap.x, closestTrap.y, foxX-trapDist.x, getClosestTrap().y+trapDist.y);
      
      // if the fox was previously going on vertical, the fox escapes the trap from the sides
      if (prevTargetMovement == fox.DOWN || prevTargetMovement == fox.UP) {
        // if it was going left or right, escape from trap by going up or down
        text("RUN AWAY SIDE", foxX +20, foxY);
        if (trapDist.x > 0) {
          nextMovement=fox.RIGHT;
        } else {
          nextMovement=fox.LEFT;
        }
       // if the fox was previously going on sides, the fox escapes the trap from the verticals
      } else if (prevTargetMovement == fox.LEFT || prevTargetMovement == fox.RIGHT) {
        // if it was going up or down, escape from trap by going left or right
        text("RUN AWAY VERTICAL", foxX +20, foxY);
        if (trapDist.y > 0) {
          nextMovement=fox.DOWN;
        } else {
          nextMovement=fox.UP;
        }
      }
      // switch between states after it was on a trap
      randomState = !randomState;
    } else {
      // store intended target path
      prevTargetMovement=nextTargetMovement;
      nextMovement = nextTargetMovement;
    }
  
    fox.move(nextMovement);
  }
  
  // not used code, for the angled walk attempt
  float getCurrentAngle () {
    float a1 = PVector.angleBetween(new PVector(foxX-width/2, foxY-height/2), new PVector(nextTarget.x-foxX, nextTarget.y-foxY));
    float a2 = PVector.angleBetween(new PVector(foxX-width/2, foxY-height/2), new PVector(nextTarget.x-foxX, nextTarget.y-foxY));
    return degrees(a1);
  }
  
  // get distance of next target
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
