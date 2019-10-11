/** //<>//
 NOTES:

 left/right keys to switch between colour palettes
 left-click to refresh
 right-click to pause/play
 'c' or 'C' to clear the drawn pattern
 's' or 'S' to take a screenshot
 **/


static final int NUM_BOXES = 300;
static final int BALL_RAD = 10;

Ball[] balls = new Ball[NUM_BOXES];

color[] PALETTE_ONE;
color[] PALETTE_TWO;
color[] PALETTE_THREE;
color[] PALETTE_FOUR;

color[][] PALETTES;

int palInd;

void setup() {
  colorMode(HSB, 360, 100, 100);

  PALETTE_ONE = new color[] { color(5.61, 0, 93.73),
    color(5.61, 74.03, 90.59), color(200.87, 34.86, 25.88), color(202.11, 37.62, 39.61),
    color(198.18, 14.86, 87.06) };

  PALETTE_TWO = new color[] { color(51.76, 21.07, 94.9),
    color(34.34, 59.67, 95.29), color(0, 60, 94.12), color(165.6, 26.32, 74.51),
    color(338.82, 18.48, 36.08) };

  PALETTE_THREE = new color[] { color(162.44, 50.8, 75.1),
    color(168.86, 100, 54.9), color(174.78, 100, 45.1), color(180.66, 100, 35.69),
    color(187.5, 100, 25.1) };

  PALETTE_FOUR = new color[] { color(102.5, 10.81, 87.06),
    color(180.65, 54.97, 67.06), color(201.32, 71.7, 41.57), color(165, 36.36, 25.88),
    color(95, 14.91, 63.14) };

  PALETTES = new color[][] { PALETTE_ONE, PALETTE_TWO, PALETTE_THREE, PALETTE_FOUR };

  palInd = 0;
  size(900, 900);
  background(PALETTES[palInd][0]);
  noStroke();
  initBounds();
}

void initBounds() {
  ArrayList<PVector[]> temp = new ArrayList<PVector[]>();
  temp.add(new PVector[] { new PVector(0, 0), new PVector(width, height) });
  while (temp.size() < NUM_BOXES) {
    int index = (int) random(temp.size());
    PVector[] rect = temp.get(index);
    boolean vert = (int) random(2) % 2 == 0;
    ArrayList<PVector[]> toAdd = new ArrayList<PVector[]>();
    PVector[] first, second;
    float bound;
    if (vert) {
      bound = random(rect[0].y, rect[1].y);
      if (bound - rect[0].y > BALL_RAD * 1.5 && rect[1].y - bound > BALL_RAD * 1.5) {
        first = new PVector[] { new PVector(rect[0].x, rect[0].y), new PVector(rect[1].x, bound) };
        second = new PVector[] { new PVector(rect[0].x, bound), new PVector(rect[1].x, rect[1].y) };
        toAdd.add(first);
        toAdd.add(second);
        temp.remove(index);
        temp.addAll(toAdd);
      }
    } else {
      bound = random(rect[0].x, rect[1].x);
      if (bound - rect[0].x > BALL_RAD * 1.5 && rect[1].x  - bound > BALL_RAD * 1.5) {
        first = new PVector[] { new PVector(rect[0].x, rect[0].y), new PVector(bound, rect[1].y) };
        second = new PVector[] { new PVector(bound, rect[0].y), new PVector(rect[1].x, rect[1].y) };
        toAdd.add(first);
        toAdd.add(second);
        temp.remove(index);
        temp.addAll(toAdd);
      }
    }
  }
  for (int i = 0; i < NUM_BOXES; i++) {
    int[] pick = new int[]{-1, 1};
    balls[i] = new Ball(new PVector((temp.get(i)[0].x + temp.get(i)[1].x) / 2, (temp.get(i)[0].y + temp.get(i)[1].y)/2),
      new PVector(pick[(int) random(2)], pick[(int) random(2)]));
    balls[i].addBounds(temp.get(i));
  }
}

void draw() {
  for (Ball b : balls) {
    b.drawBounds();
    b.drawBall();
    b.update();
  }
}

void updateColours() {
  for (Ball b : balls) {
    b.colour = PALETTES[palInd][(int)random(1, 5)];
  }
}

void keyPressed() {
  // since the code responds to arrow keys, we use keycodes
  if (key == CODED) {
    switch(keyCode) {
    case RIGHT :
      if (palInd == PALETTES.length - 1) {
        palInd = 0;
      } else {
        palInd++;
      }
      background(PALETTES[palInd][0]);
      updateColours();
      break;
    case LEFT :
      if (palInd == 0) {
        palInd = PALETTES.length - 1;
      } else {
        palInd--;
      }
      background(PALETTES[palInd][0]);
      updateColours();
      break;
    default:
      break;
    }
  } else if (key == 's' || key == 'S') {
    saveFrame("pattern-######.png");
  }
  else if (key == 'c' || key == 'C') {
    background(PALETTES[palInd][0]);
  }
}

void mousePressed() {
  if (mouseButton == LEFT && looping) {
    setup();
  }
  if (mouseButton == RIGHT) {
    if (looping) {
      noLoop();
    } else {
      loop();
    }
  }
}
