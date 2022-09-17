// Walking fox with animations for all directions
// Animation is based on a state machine, too.
//
// Udo Frese, Tim Laue, 2013 - 2019

// DO NOT CHANGE THIS FILE

class Fox {
  // Loads a set of numbered images
  // filenames is a relative filename with TWO 00s
  // e.g. images/fox-00.png. The function then tries
  // to load images/fox-00.png, images/fox-01.png, ..
  // as long as these files exist.
  ArrayList<PImage> loadImages (String filePattern) {
    // Count number of question marks
    String qmString="";
    while (filePattern.indexOf (qmString+"?")>=0) qmString += "?";
    // The largest sequence of question marks is qmString
    ArrayList<PImage> images = new ArrayList<PImage>();
    PImage image;
    int ctr=0;
    do {
      String fname = filePattern.replace(qmString, nf(ctr, qmString.length()));
      InputStream input = createInput(fname);
      if (input==null) break;
      PImage img = loadImage (fname);
      if (img==null) break;
      images.add(img);
      ctr++;
    } while (true);
    return images;
  }

  // Images of the fox animation for different phases
  ArrayList<PImage> foxImgs;
  // fox position (l.u.-corner)
  float foxX, foxY;
  // size of fox (given by image)
  float foxW, foxH;
  // phase of the animation (see finite state machine in IfG 1 slides)
  int foxPhase;

  float xVelocity = 64;  // Fox velocity in x direction in pixels per second
  float yVelocity = 48;  // Fox velocity in y direction in pixels per second
  int animationStepsPerSecond = 8; // How many images per second
  float phaseLength = 1.0 / animationStepsPerSecond; // Time for which one image is shown
  float subPhase = 0; // Timer for currently shown image

  int STOP = 0, RIGHT = 1, LEFT = 2, UP = 3, DOWN = 4; // Four directions

  Fox(float x, float y) {
    foxX = x;
    foxY = y;
    foxPhase = 0;
    foxImgs = loadImages ("images/fx-??.png");
    foxW = foxImgs.get(0).width;
    foxH = foxImgs.get(0).height;
  }

  void move(int dir) {
    // Change coordinates
    if (1<=foxPhase && foxPhase<=4) foxY+=yVelocity / frameRate;
    else if (6<=foxPhase && foxPhase<=9) foxX-= xVelocity / frameRate;
    else if (11<=foxPhase && foxPhase<=14) foxY-= yVelocity / frameRate;
    else if (16<=foxPhase && foxPhase<=19) foxX+= xVelocity / frameRate;
    // Change phase
    if (foxPhase==0 || foxPhase==5 || foxPhase==10 || foxPhase==15 ||  // Standing
      foxPhase==4 || foxPhase==9 || foxPhase==14 || foxPhase==19) { // End of a walking cylce
      // One of the states indicated by a red dot
      if (dir != STOP) { // Change according to key to start of walking cycle
        if (dir==DOWN) foxPhase = 1;
        else if (dir==LEFT) foxPhase = 6;
        else if (dir==UP) foxPhase = 11;
        else if (dir==RIGHT) foxPhase = 16;
      } else if (foxPhase==4 || foxPhase==9 || foxPhase==14 || foxPhase==19)
        foxPhase -= 4; // goto respective standing phase
      subPhase = 0;
    } else {
      subPhase += 1.0 / frameRate;   // Measure time of currently shown image
      if (subPhase > phaseLength) {   // If time per image is reached ...
        subPhase = 0;                // ... reset timer and
        foxPhase++;                  // go to next animation phase
      }
    }
  }

  void draw() {
    image(foxImgs.get(foxPhase), foxX, foxY);
  }

  float getX() {
    return foxX;
  }

  float getY() {
    return foxY;
  }

  float getCenterX() {
    return foxX + foxW/2;
  }

  float getCenterY() {
    return foxY + foxH/2;
  }

  float getCollisionRadius() {
    return 25;
  }
}
