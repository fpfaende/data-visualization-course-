color cream = color(243, 237, 211);
color[] icecream = new color[] {
  color(1, 63, 89), color(25, 190, 192), color(32, 214, 199), color(213, 79, 88)
};
ArrayList<Ball> balls; 
boolean collectBalls = false;


void setup() {
  size(1000, 700);
  background(cream);
  balls = new ArrayList<Ball>();
}

void draw() {
  background(cream);

  for (Ball ball : balls) {
    stroke(ball.ballColor);
    fill(ball.ballColor);

    PVector mousePosition = new PVector(mouseX, mouseY);

    if (collectBalls) {
      if (!ball.isMovedByMouse) {
        if (ceil(mousePosition.dist(ball.position)) < ((float)ball.diameter/2)) {
          ball.isMovedByMouse = true;
        }
      } 
      if (ball.isMovedByMouse) {
        ball.position = mousePosition;
      } else {
        ball.position.add(ball.speed);
      }
    } else {
      ball.position.add(ball.speed);
    }

    ellipse((int)ball.position.x, (int)ball.position.y, ball.diameter, ball.diameter);

    if ((((int)ball.position.x - ball.diameter/2) <= 0) || ((ball.diameter/2 + (int)ball.position.x) >= width)) {
      ball.speed.x *= -1;
    }

    if ((((int)ball.position.y - ball.diameter/2) <= 0) || ((ball.diameter/2 + (int)ball.position.y) >= height)) {
      ball.speed.y *= -1;
    }
  }


  ArrayList<Ball>  otherBalls = (ArrayList<Ball>)balls.clone();
  for (Ball ball : balls) {
    otherBalls.remove(ball);
    if (ball.isMovedByMouse) {
      continue;
    }
    for (Ball otherBall : otherBalls) {
      if (!otherBall.isMovedByMouse) {
        if (ball.isCollidingWith(otherBall)) {
          resolveOverlap(ball, otherBall);
          collision(ball, otherBall);
        }
      }
    }
  }
}

void resolveOverlap(Ball ball1, Ball ball2){
  float target = (float)ball1.diameter/2 + (float)ball2.diameter/2;
  PVector nSpeed1 = new PVector(-ball1.speed.x,-ball1.speed.y);
  nSpeed1.normalize();
  PVector nSpeed2 = new PVector(-ball2.speed.x,-ball2.speed.y);
  nSpeed2.normalize();
 
  while(ball1.position.dist(ball2.position) < target) {
    ball1.position.add(nSpeed1);
    ball2.position.add(nSpeed2);
  }
}

// from http://www.vobarian.com/collisions/2dcollisions2.pdf
void collision(Ball ball1, Ball ball2) {
  PVector un = PVector.sub(ball2.position, ball1.position);
  un.normalize();
  PVector ut = new PVector(-un.y, un.x);

  float v1n = PVector.dot(un, ball1.speed);
  float v1t = PVector.dot(ut, ball1.speed);
  float v2n = PVector.dot(un, ball2.speed);
  float v2t = PVector.dot(ut, ball2.speed);


  float vp1n = (v1n*(float)(ball1.diameter - ball2.diameter) + v2n*(float)(2 * ball2.diameter)) / (float)(ball1.diameter + ball2.diameter); 
  float vp2n = (v2n*(float)(ball2.diameter - ball1.diameter) + v1n*(float)(2 * ball1.diameter)) / (float)(ball1.diameter + ball2.diameter);

  PVector vp1n2d = PVector.mult(un, vp1n);
  PVector vp1t2d = PVector.mult(ut, v1t);
  PVector vp2n2d = PVector.mult(un, vp2n);
  PVector vp2t2d = PVector.mult(ut, v2t);

  ball1.speed = PVector.add(vp1n2d, vp1t2d);
  ball2.speed = PVector.add(vp2n2d, vp2t2d);
}

void mouseClicked() {
  if (mouseButton == RIGHT)
    balls.add(new Ball());
}

void mousePressed() {
  if (mouseButton == LEFT) {
    collectBalls = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    collectBalls = false;
    for (Ball ball : balls) {
      ball.isMovedByMouse = false;
    }
  }
}

class Ball {
  PVector position;
  PVector speed;
  public int diameter;
  color ballColor;
  boolean isMovedByMouse = false;

  Ball() {
    diameter = (int)random(20, 60);

    int posX = (int)random(diameter/2, width-diameter/2);
    int posY = (int)random(diameter/2, height-diameter/2);
    position = new PVector((float)posX, (float)posY);

    int speedX = (int)random(1, 5);
    int speedY = (int)random(1, 5);
    int directionX = ((((int)random(1, 3)) % 2) == 0) ? 1 : -1;
    int directionY = ((((int)random(1, 3)) % 2) == 0) ? 1 : -1;
    speed = new PVector((float)speedX * (float)directionX, (float)speedY * (float)directionY);

    ballColor = icecream[floor(random(4))];
  }

  boolean isCollidingWith(Ball otherBall) {
    return (ceil(this.position.dist(otherBall.position)) < ((float)this.diameter/2+(float)otherBall.diameter/2));
  }
}

