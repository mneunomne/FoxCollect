// A fox that has to collect some things and to avoid traps
//
// Tim Laue, September 2022

// This is version 0.5, updates are coming

// DO NOT CHANGE THIS FILE

Fox fox;
FoxController foxController;
Map map;
boolean debugDrawing = false;

enum State {
  RUN, WON, LOST
};
State state;

void setup() {
  size(700, 700);
  init();
}

void keyPressed() {
  /* Do not use these controls, they are made for debugging.
   if (keyCode == RIGHT) fox.move(fox.RIGHT);
   if (keyCode == LEFT) fox.move(fox.LEFT);
   if (keyCode == UP) fox.move(fox.UP);
   if (keyCode == DOWN) fox.move(fox.DOWN);*/

  if (keyCode == 'D') debugDrawing = !debugDrawing;
  if (keyCode == ENTER) init();
}

void init() {
  state = State.RUN;
  fox = new Fox(width/2, height/2);
  map = new Map(fox, 4, 3);            // Here, you can control the number of collectibles and traps
  foxController = new FoxController(fox, map);
}

void draw() {
  if (state == State.RUN) {
    background(255);
    foxController.step();
    map.update();
    map.draw();
    fox.draw();
    if (debugDrawing) {
      fill(255, 0, 0, 50);
      ellipseMode(RADIUS);
      ellipse(fox.getCenterX(), fox.getCenterY(), fox.getCollisionRadius(), fox.getCollisionRadius());
    }
    if (map.hasCollided())
      state = State.LOST;
    else if (map.allCollected())
      state = State.WON;
  } else if (state == State.WON) {
    text("You won!", 200, 200);
  } else {// if (state == State.LOST)
    text("You lost!", 200, 200);
  }
}
