class Box {

  Body body;
  float w, h;
  color col;
  boolean colliding = false;

  Box(float x, float y, float w_, float h_) {
    w = w_;
    h = h_;
    col = color(218, 218, 210);
    makeBody(new Vec2(x, y), w, h);
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(col);
    //noFill();
    noStroke();
    rect(0, 0, w, h);
    popMatrix();
  }

  void makeBody(Vec2 center, float w_, float h_) {

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;
    fd.friction = 0;
    fd.restitution = 0.75;
    //fd.restitution = 1;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.setUserData(this);
    body.createFixture(fd);

    body.setLinearDamping(0.001);
    body.setAngularDamping(0.001);
    body.setLinearVelocity(new Vec2(random(-5, 5), random(-5, 5)));
    body.setAngularVelocity(random(-2, 2));
  }

  void beginColl() {
    col = color(255, 0, 0);
    colliding = true;
  }

  void endColl() {
    col = color(218, 218, 210);
    colliding = false;
  }
  
  float getLinEnergy() {
    return (float)(body.getMass()*Math.pow(body.getLinearVelocity().length(), 2));
  }

  float getRotEnergy() {
    return (float)(body.getInertia()* Math.pow(body.getAngularVelocity(), 2));
  }

  float getKineticEnergy() {
    return getLinEnergy() + getRotEnergy();
  }

}
