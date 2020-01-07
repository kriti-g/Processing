/** //<>// //<>//

INTERACTION: Press and hold the mouse to see under the tiling at that position. 

What is identity? As a third-culture kid from an international school, and now studying abroad,
this question is one I consider often. In this piece I explore identity documentation, the most 
concrete proof of your identity in today's world in the eyes of governmental systems and thus 
most-anything else. 

Yet - my birth certificate is in ---- (-------- being a place I have no memory of), 
documents tying me to my home country of +++++ are no longer valid due to restrictions against
dual nationality, meaning I get a tourist visa whenever I visit my family, my diplomatic papers
which tie me to my father's work and which first allowed me into ****** are equally now invalid, 
and even my process in obtaining **** citizenship was decided by a clerk checking my papers 
and shrugging, "I mean, you were BASICALLY born here." Despite the importance of official 
papers and their supposed permanence, they have come and gone throughout my life, and rarely 
are they wholly reflective of my identity. 

I took every identity piece I own, shrinking them into near insignificance to reveal an image
of the only geographical place in which I can truly anchor my own identity - my living room in
****, a rented apartment we've been living in for just over 11 years, and which my parents 
are likely moving out of in a couple of years.

**/

static final int TO_USE = 23; // the number of identity piece images
static final int MINI = 11; // the width of every mini 'tile'
static final int MAX_BRIGHT = 256; //basic brightness scale 0 - 255
int WINDOW_LENGTH; // the side-length of the peek window

PImage truth; //<>//

PImage[] ids;
PImage[] closest;
float[] idBright;

void setup() {
  WINDOW_LENGTH = (int)(displayHeight * 0.075);
  truth = loadImage("living_room.JPG");
  truth.resize(displayWidth, 0);
  fullScreen();
  background(0);
  String[] fileNames = new File(dataPath("everyID")).list();
  ids = new PImage[TO_USE]; //<>//
  idBright = new float[TO_USE];
  closest = new PImage[MAX_BRIGHT];
  for (int i = 0; i < TO_USE; i++) {

    PImage current = loadImage("/data/everyID/" + fileNames[i]);
    current.resize(MINI, 0);
    ids[i] = current;
    ids[i].loadPixels();

    float avgBrightness = 0;
    for (int j = 0; j < ids[i].pixels.length; j++) {
      color c = ids[i].pixels[j];
      avgBrightness += brightness(c);
    }
    avgBrightness /= ids[i].pixels.length;
    idBright[i] = avgBrightness;
  }

  for (int i = 0; i < closest.length; i++) {
    float closestDiff = MAX_BRIGHT;
    for (int j = 0; j < idBright.length; j++) {
      if (abs(i - idBright[j]) < closestDiff) {
        closestDiff = abs(i - idBright[j]);
        closest[i] = ids[j];
      }
    }
  }
}

void draw() {
  image(truth, 0, 0);
  
  // cast MINI to float to avoid any gaps as a result of integer division
  for (int i = 0; i < width / (float)MINI; i++) {
    // use while loop to remove 'grid' like feeling, at least vertically
    float currentY = 0;
    while (currentY < truth.height) {
      // the current pixel we're considering
      color c = get(i * MINI, (int)currentY);
      PImage close = closest[(int)brightness(c)];
      // place the closest-in-brightness image at the current position
      image(close, i*MINI, currentY, MINI, close.height);
      currentY += close.height;
    }
  }
  //// creates the peek window
  if (mousePressed == true) {
    PImage look = createImage(WINDOW_LENGTH, WINDOW_LENGTH, RGB);
    look.copy(truth, mouseX, mouseY, WINDOW_LENGTH, WINDOW_LENGTH, 0, 0, WINDOW_LENGTH, WINDOW_LENGTH);
    image(look, mouseX, mouseY, WINDOW_LENGTH, WINDOW_LENGTH);
  }
}
