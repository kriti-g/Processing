import processing.sound.*; //<>// //<>// //<>// //<>//

// Running Spinner
// inputs: mouse left-right click, mouse-pos, keypress { 'n', 'm', 'p', LEFT, RIGHT, UP, DOWN }, microphone.
// Can be rendered in fullScreen(), current setup is 800 x 800.

final color RED = color(178, 40, 40);
final color BLUE = color(50, 163, 180);
final color BACKGROUND_COLOR = color(209, 204, 207);
// audio parameters
final AudioIn in = new AudioIn(this, 0);
final Amplitude amp = new Amplitude(this);
// base size of circles and squares
static int baseCRad, baseSLength;
// base radius of the spinner
static int baseRad;
// current size of circles and squares
int cRad, sLength;
// current radius of the spinner
int radius;
// number of shapes per circle
int numInShape;
// number of spinning circles
int numBigCircle;
// tick-count
int tick;
// x centre of the spinner
int centreX;
// y centre of the spinner
int centreY;
// the speed at which the spinner runs from the mouse
int fleeSpeed; 
// is the spinner experiencing a loud noise?
boolean tooLoud;
// number of lines holding it down
int numLines;

// initialisation
void setup() {
  size(800, 800);
  // for smooth animation
  smooth();
  frameRate(70);
  rectMode(CENTER);
  // initialise circles at 3
  numBigCircle = 4;
  // initialise number of circles per circle at 9
  numInShape = 9;
  // initialise number of restraints at 5
  numLines = 5;
  // spinner starts in the middle
  centreX = width / 2;
  centreY = height / 2;
  // baseRadius and changing radius optimised for screen size
  baseRad = max(width, height) / 9;
  radius = baseRad;
  // shape sizes synced with new radius
  baseCRad = radius / 5;
  baseSLength = 3 * radius / 20;
  cRad = baseCRad;
  sLength = baseSLength;
  // spinner speed optimised for screen size
  fleeSpeed = max(width, height) / 150;
  // begin audio input
  in.start();
  amp.input(in);
  // initialise tick count
  tick = 0;
}

// to draw the image
void draw() {
  background(BACKGROUND_COLOR);
  tick++;
  adjustCentre();
  drawStrokes();
  moodUpdate();
  drawCircles();
}

// updates the current 'mood' of this spinner
void moodUpdate() {
  float distance = dist(centreX, centreY, mouseX, mouseY);
  float current = amp.analyze();

  // recalculates spinner speed according to proximity
  int baseSpeed =  max(width, height) / 150;
  int recalcSpeed = (int) max(baseSpeed, (baseSpeed * dist(99, 99, width, height) /  (distance *1.5)));
  fleeSpeed = max(4, recalcSpeed - recalcSpeed * numLines / 20); // does not allow speed lower than 4 pixels a frame


  // Mouse is too close to center!! Spinner panics
  if (distance < baseRad * 0.8) {
    fill(RED);
    tooLoud = true;
    radius = baseRad;
    cRad = baseCRad;
    sLength = baseSLength;
    // noises are too loud! Spinner panics according to amplitude of sound
  } else if (current > 0.017) {
    if (distance > baseRad*1.5) {
      fill(lerpColor(BLUE, RED, min(current / 0.04, 1)));
    }
    radius = (int) (baseRad + current * 1000);
    cRad = radius / 5;
    sLength = 3 * radius / 20;
    tooLoud = true;
    // regular mood. Spinner is wary of the mouse and grows more flustered (red) as it grows closer.
  } else {
    fill(lerpColor(RED, BLUE, min(1, distance / (dist(99, 99, width, height)))));
    tooLoud = false;
    radius = baseRad;
    cRad = baseCRad;
    sLength = baseSLength;
  }
}

// draws the restraining strokes and their anchor.
void drawStrokes() {
  noFill();
  stroke(43, 39, 42, 40);
  int x, y;
  int[] sides = new int[]{0, 0, width, height};
  for (int i = 0; i < 4; i++) {
    for (int j = 1; j < numLines + 1; j++) {
      if (i % 2 == 0) {
        x = sides[i];
        y = j*height / (numLines + 1);
      } else {
        x = j*width / (numLines + 1);
        y = sides[i];
      }
      line(centreX, centreY, x, y);
    }
  }
  // anchor
  fill(BACKGROUND_COLOR);
  ellipse(centreX, centreY, 2*radius / numBigCircle, 2*radius / numBigCircle);
}

// draw the spinner
void drawCircles() {

  // no outline for every shape
  noStroke();

  // how much a shape moves per tick (in radians)
  // adjusted depending on the mouse proximity to the centre of the circle
  float aInc;
  float calc = 0.17 - 0.17 * dist(centreX, centreY, mouseX, mouseY) / dist(centreX, centreY, 99, 99);
  if (calc > 0) {
    aInc = calc;
  } else {
    aInc = 0.008;
  }
  float eXPos;
  float eYPos;
  float oXPos;
  float oYPos;

  // to draw the designated number of large circles
  for (int i = numBigCircle; i > 0; i--) {
    // to draw the designated number of shapes
    for (int j = 0; j <= numInShape; j++) {

      // determines spin direction depending on odd or even circle placement
      eXPos = centreX + (i*radius/numBigCircle)
        *cos(2*j*PI/numInShape+tick*aInc);
      eYPos = centreY + (i*radius/numBigCircle)
        *sin(2*j*PI/numInShape+tick*aInc);
      oXPos = centreX + (i*radius/numBigCircle)
        *cos(2*j*PI/numInShape-tick*aInc);
      oYPos = centreY + (i*radius/numBigCircle)
        *sin(2*j*PI/numInShape-tick*aInc);

      // exclamation marks take over the outermost circle, and continue that pattern
      // circles and squares alternate rings
      if (tooLoud && i % 2 == 0 && numBigCircle % 2 == 0) {
        triangle(eXPos - sLength / 2, eYPos - sLength, eXPos + sLength / 2, eYPos - sLength, eXPos, eYPos + sLength / 2);
        ellipse(eXPos, eYPos + sLength / 1, cRad/2, cRad /2);
      } else if (tooLoud && i % 2 == 1 && numBigCircle % 2 == 1) {
        triangle(oXPos - sLength / 2, oYPos - sLength, oXPos + sLength / 2, oYPos - sLength, oXPos, oYPos + sLength / 2);
        ellipse(oXPos, oYPos + sLength / 1, cRad/2, cRad /2);
      } else if (i % 2 == 0) {
        ellipse(eXPos, eYPos, cRad, cRad);
      } else {
        rect(oXPos, oYPos, sLength, sLength);
      }
    }
  }
}

// decides the direction and length of the spinner's movement away from the mouse
// and updates its centre accordingly
void adjustCentre() {
  float dx, dy, theta, moveX, moveY;
  int nCX, nCY;
  dx = centreX - mouseX;
  dy = centreY - mouseY;
  // avoid zero division error (i.e. the mouse is directly over the xcenter of the circle.)
  if (dx == 0) { 
    return;
  }

  theta = atan2(dy, dx);
  moveX = fleeSpeed * cos(theta);
  moveY = fleeSpeed * sin(theta);
  nCX = (int) (centreX + moveX);
  nCY = (int) (centreY + moveY);

  // set bounding boxes such that the spinner doesn't go offscreen
  // 99 being slightly less than the minimum radius, allows for
  // user mouse to get in the gap between screen edge and spinner
  // but prevents breakage through radius changes.
  if (nCX < width - 99 && nCX > 99) { 
    centreX = nCX;
  }
  if (nCY < height - 99 && nCY > 99) {
    centreY = nCY;
  }
}

// controls number of strokes on the screen
void mousePressed() {
  // decreases number of strokes, avoiding negatives
  if (mouseButton == LEFT && numLines > 0) {
    numLines--;
    // increases number of strokes
  } else if (mouseButton == RIGHT) {
    numLines++;
  }
}

// to handle key presses
void keyPressed() {
  // since the code responds to arrow keys, we use keycodes
  if (key == CODED) {
    switch(keyCode) {
      // right to increase number of shapes per spinning circle
    case RIGHT : 
      numInShape++;
      break;
      // left to decrease number of shapes per spinning circle,
      // making sure to leave at least 3
    case LEFT : 
      if (numInShape > 3) { 
        numInShape--;
      }
      break;
      // up to increase number of spinning circles
    case UP : 
      numBigCircle++;
      break;
      // down to decrease it, leaving at least one
    case DOWN : 
      if (numBigCircle > 2) { 
        numBigCircle--;
      }
      break;
    default: // ignore coded keys beyond these
      break;
    }
    // increase the base size of the spinner
  } else if (key == 'm' || key == 'M') { // chose m and n keys as they are a pair, and are closest to the arrow keys
    baseRad += 20;
    // decrease the base size of the spinner, ensuring that it is over 100 pixels.
  } else if (baseRad > 100 && (key == 'n' || key == 'N')) { 
    baseRad -= 20;
    // save a screenshot of the drawing
  } else if (key == 'p' || key == 'P') { // p for print
    saveFrame("spinner-######.png");
  }
}
