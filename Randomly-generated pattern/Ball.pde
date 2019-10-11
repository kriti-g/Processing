class Ball {
  PVector velocity;
  PVector direction;
  PVector position;
  PVector[] bounds;
  color colour;


  Ball(PVector pos, PVector dir) {
    this.velocity = new PVector(0, 0);
    this.direction = dir;
    this.position = pos;
    this.colour = PALETTES[palInd][(int)random(1, 5)];
  }

  void addBounds(PVector[] bounds) {
    this.bounds = bounds;
    updateVel();
  }

  void updateVel() {
    float area = (this.bounds[1].x - this.bounds[0].x) * (this.bounds[1].y - this.bounds[0].y);
    this.velocity = new PVector(min(map(area, width*height / 1000, width * height / 40, 0.6, 2.5), 2.5), min(map(area, width*height / 700, width * height / 70, 0.9, 2.3), 2.3));
  }

  void update() {
    this.position = new PVector(position.x + velocity.x * direction.x, position.y + velocity.y * direction.y);
    if (position.x > bounds[1].x -BALL_RAD || position.x < bounds[0].x + BALL_RAD) {
      direction.x *= -1;
    }
    if (position.y > bounds[1].y -BALL_RAD || position.y < bounds[0].y + BALL_RAD) {
      direction.y *= -1;
    }
  }

  void drawBounds() {
    float area = (this.bounds[1].x - this.bounds[0].x) * (this.bounds[1].y - this.bounds[0].y);
    float alpha = max(map(area, width*height / 15000, width * height / 200, 25, 5), 5);
    fill(PALETTES[palInd][0], alpha);
    rect(this.bounds[0].x, this.bounds[0].y, this.bounds[1].x - this.bounds[0].x, this.bounds[1].y - this.bounds[0].y);
  }  

  void drawBall() {
    fill(colour);
    ellipse(position.x, position.y, BALL_RAD, BALL_RAD);
  }
}
