class Wall {

  float x, y, w, h;
  int id;
  Body b;

  Wall(float x_,float y_, float w_, float h_, int id_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    id = id_;

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    b.setUserData(this);

    b.createFixture(sd,1);
  }

  void display() {
    fill(100,255,100,150);
    noStroke();
    rectMode(CENTER);
    rect(x,y,w,h);
  }

}
