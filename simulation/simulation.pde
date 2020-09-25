import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import oscP5.*;
import netP5.*;



Box2DProcessing box2d;
Box marbleObject;
ArrayList<Wall> walls;

PImage background; 
Vec2 poolCoords, poolSize;
float wallW;

Vec2 minPos, maxPos;
float marbleW, marbleH;
float initKinetic;



OscP5 oscLocal;
NetAddress oscServer;
OscMessage msgCoords, msgEnergy, msgColl;


void setup() {

  size(1300, 850);
  smooth();
  background = loadImage("data/background.jpg");
  textSize(16);

  poolCoords = new Vec2(495, 425);
  poolSize = new Vec2(800, 680);
  wallW = 10;
  marbleW = 340;
  marbleH = 220;

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  box2d.listenForCollisions();

  marbleObject = new Box(545, 370, marbleW, marbleH);
  initKinetic =  marbleObject.getKineticEnergy();

  walls = new ArrayList<Wall>();
  walls.add(new Wall(poolCoords.x, poolCoords.y - poolSize.y/2, poolSize.x, wallW, 0));
  walls.add(new Wall(poolCoords.x + poolSize.x/2, poolCoords.y, wallW, poolSize.y, 1));
  walls.add(new Wall(poolCoords.x, poolCoords.y + poolSize.y/2, poolSize.x, wallW, 2));
  walls.add(new Wall(poolCoords.x - poolSize.x/2, poolCoords.y, wallW, poolSize.y, 3));

  float wallWWorld = box2d.scalarPixelsToWorld(wallW/2);
  float marbleWWorld = box2d.scalarPixelsToWorld(marbleW/2);
  float marbleHWorld = box2d.scalarPixelsToWorld(marbleH/2);

  Vec2 topLeft = new Vec2(box2d.coordPixelsToWorld(poolCoords.x - poolSize.x/2, 
    poolCoords.y - poolSize.y/2));
  Vec2 bottomRight = new Vec2(box2d.coordPixelsToWorld(poolCoords.x + poolSize.x/2, 
    poolCoords.y + poolSize.y/2));

  minPos = new Vec2(topLeft.x + wallWWorld + marbleWWorld, bottomRight.y + wallWWorld + marbleHWorld);
  maxPos = new Vec2(bottomRight.x - wallWWorld - marbleWWorld, topLeft.y - wallWWorld - marbleHWorld);


  oscLocal = new OscP5(this, 11000);
  oscServer = new NetAddress("127.0.0.1", 12000);
  msgCoords = new OscMessage("/sonification/coordinates");
  msgColl = new OscMessage("/sonification/collision");
  msgEnergy = new OscMessage("/sonification/energy");
}

void draw() {

  box2d.step();

  Vec2 normPos = new Vec2();
  normPos.x = map(marbleObject.body.getPosition().x, minPos.x, maxPos.x, 0, 1);
  normPos.y = map(marbleObject.body.getPosition().y, minPos.y, maxPos.y, 0, 1);

  float normAngle = marbleObject.body.getAngle()/TWO_PI;
  normAngle = normAngle - (int)normAngle;
  if (normAngle < 0) {
    normAngle = normAngle+1;
  }

  //Vec2 vel = marbleObject.body.getLinearVelocity();

  float normE = marbleObject.getKineticEnergy()/initKinetic;

  Vec2 ene = new Vec2(marbleObject.getLinEnergy(), marbleObject.getRotEnergy());
  ene.normalize();
  ene.mulLocal(normE);

  boolean clockwise = marbleObject.body.getAngularVelocity() < 0;

  //image(background, 0, 0);
  background(220);

  strokeWeight(3);
  fill(12, 16, 19);
  stroke(83, 88, 81);
  rect(poolCoords.x, poolCoords.y, poolSize.x*1.20, poolSize.y*1.20);

  fill(66, 73, 75);
  stroke(149, 175, 193);
  rect(poolCoords.x, poolCoords.y, poolSize.x-wallW/2-4, poolSize.y-wallW/2-4);

  fill(59, 64, 66);
  stroke(37, 42, 40);
  rect(poolCoords.x, poolCoords.y, poolSize.x*0.70, poolSize.y*0.70);

  stroke(37, 42, 40);
  line (poolCoords.x-0.7*poolSize.x/2, 
    poolCoords.y-0.7*poolSize.y/2, 
    poolCoords.x-poolSize.x/2 +wallW/2, 
    poolCoords.y-poolSize.y/2+wallW/2);
  line(poolCoords.x+0.7*poolSize.x/2, 
    poolCoords.y-0.7*poolSize.y/2, 
    poolCoords.x+poolSize.x/2 -wallW/2, 
    poolCoords.y-poolSize.y/2+wallW/2);
  line(poolCoords.x-0.7*poolSize.x/2, 
    poolCoords.y+0.7*poolSize.y/2, 
    poolCoords.x-poolSize.x/2 +wallW/2, 
    poolCoords.y+poolSize.y/2-wallW/2);  
  line(poolCoords.x+0.7*poolSize.x/2, 
    poolCoords.y+0.7*poolSize.y/2, 
    poolCoords.x+poolSize.x/2 -wallW/2, 
    poolCoords.y+poolSize.y/2-wallW/2);

  marbleObject.display();

  stroke(149, 175, 193);
  line(poolCoords.x-poolSize.x/2 +wallW/2, 
    poolCoords.y-poolSize.y/2+wallW/2, 
    poolCoords.x-1.2*poolSize.x/2, 
    poolCoords.y-1.2*poolSize.y/2);
  line(poolCoords.x+poolSize.x/2 -wallW/2, 
    poolCoords.y-poolSize.y/2+wallW/2, 
    poolCoords.x+1.2*poolSize.x/2, 
    poolCoords.y-1.2*poolSize.y/2);
  line(poolCoords.x-poolSize.x/2 +wallW/2, 
    poolCoords.y+poolSize.y/2-wallW/2, 
    poolCoords.x-1.2*poolSize.x/2, 
    poolCoords.y+1.2*poolSize.y/2);
  line(poolCoords.x+poolSize.x/2 -wallW/2, 
    poolCoords.y+poolSize.y/2-wallW/2, 
    poolCoords.x+1.2*poolSize.x/2, 
    poolCoords.y+1.2*poolSize.y/2);    

  //for (Wall wall : walls) {
  //  stroke(0, 200, 0);
  //  wall.display();
  //}

  fill(0);  

  text("Pos*: " + String.format("(%.3f, %.3f)", normPos.x, normPos.y), 1004, 30);
  text("Ang*: " + String.format("%.3f", normAngle), 1004, 60);

  text("Coll: " + marbleObject.colliding, 1004, 90);


  //text("Linear vel.: " + String.format("%.3f", vel.length()), 1004, 120);
  //text(String.format("(%.3f, %.3f)", vel.x, vel.y), 1090, 150);
  //text("Angular vel.: " + String.format("%.3f", marbleObject.body.getAngularVelocity()), 1004, 180);
  //text("Clockwise: " + clockwise, 1004, 210);

  text("Energy*: " + String.format("%.3f", normE), 1004, 270);
  text("LinEne*: " + String.format("%.3f", ene.x), 1004, 300);
  text("RotEne*: " + String.format("%.3f", ene.y), 1004, 330);


  msgCoords.add(normPos.x); 
  msgCoords.add(normPos.y); 
  msgCoords.add(normAngle); 
  oscLocal.send(msgCoords, oscServer);   
  msgCoords.clearArguments();

  msgColl.add(marbleObject.colliding?1:0); 
  oscLocal.send(msgColl, oscServer);   
  msgColl.clearArguments();

  
  msgEnergy.add(normE); 
  msgEnergy.add(ene.x); 
  msgEnergy.add(ene.y); 
  oscLocal.send(msgEnergy, oscServer);   
  msgEnergy.clearArguments();

  //text("Corners: " + minPos, 1053, 30);
  //text("" + maxPos, 1123, 60);
  //text("Position: " + marbleObject.body.getPosition(), 1053, 90);

  //text("Angle: " + marbleObject.body.getAngle(), 1071, 210);
  //text("Angular velocity: " + marbleObject.body.getAngularVelocity(), 990, 240);
}

void beginContact(Contact cp) {

  Wall w;

  Object o1 = cp.getFixtureA().getBody().getUserData();
  Object o2 = cp.getFixtureB().getBody().getUserData();
  if (o1.getClass() == Wall.class) {
    w = (Wall)o1;
  } else {
    w = (Wall)o2;
  }
  //print(w.id);

  marbleObject.beginColl();
}

void endContact(Contact cp) {
  marbleObject.endColl();
}


void keyPressed() {
  if (key==' ') {
    box2d.destroyBody(marbleObject.body);
    marbleObject = new Box(545, 370, marbleW, marbleH);
    initKinetic =  marbleObject.getKineticEnergy();
    //marbleObject.reset();
    //marbleObject.body
  }
}
