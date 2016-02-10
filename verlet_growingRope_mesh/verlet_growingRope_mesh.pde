
import toxi.physics2d.constraints.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

import java.util.*;
import toxi.geom.*;
import toxi.math.*;

import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

WB_Render render;
WB_BSpline C;
WB_Point[] points;
HE_Mesh mesh;


int numParticles = 50;
float restLength = 10.0;
float ropeRadius = 8;
boolean cCircle,cSquare,meshCreated = false;
float diameter = 720;
Vec2D center;

VerletPhysics2D physics;
VerletParticle2D head,tail;

Iterator<VerletParticle2D> it;

void setup(){
  size(1280,800,P3D);
  pixelDensity(2);
  
  center = new Vec2D(width/2,height/2);
  
  physics = new VerletPhysics2D();
  physics.setDrag(0.05f);
  physics.setWorldBounds(new Rect(ropeRadius, ropeRadius, width-ropeRadius*2, height-ropeRadius*2));
  drawRope();

  strokeWeight(ropeRadius);
  strokeCap(ROUND);
}
VerletParticle2D addParticle(Vec2D pos){
   VerletParticle2D p = new VerletParticle2D(pos);
   physics.addParticle(p);
   physics.addBehavior(new AttractionBehavior(p, 40, -0.6f, 0.01f));
   return p;
}

void draw(){
  background(0,0,255);
  noFill();
  stroke(255);
  
  if (cCircle){
    ellipse(center.x,center.y,diameter+ropeRadius*4,diameter+ropeRadius*4);
  }
  if (cSquare){
    rect(center.x-diameter/2,center.y-diameter/2,diameter,diameter);
    physics.setWorldBounds(new Rect(center.x-diameter/2+ropeRadius,center.y-diameter/2+ropeRadius,diameter-ropeRadius*2,diameter-ropeRadius*2));
  }else{
    physics.setWorldBounds(new Rect(ropeRadius, ropeRadius, width-ropeRadius*2, height-ropeRadius*2));
  }
  
  
  
  it = physics.particles.iterator();
  beginShape();
  while(it.hasNext()){
  	VerletParticle2D p = it.next();
    if (cCircle){
       if ((dist(p.x, p.y, center.x, center.y) > diameter/2)){
        float a = PVector.sub(new PVector(p.x,p.y),new PVector(center.x,center.y)).heading();
        p.x = center.x  + diameter/2 * cos (a);
        p.y = center.y  + diameter/2 * sin (a);
             
       }
    }
    curveVertex(p.x,p.y);
  }
  endShape();
  
  
  
  if (meshCreated){
    directionalLight(255, 255, 255, 1, 1, -1);
     noStroke();
     fill(200);
     render.drawFaces(mesh); 
  }
  
  physics.update();
}
void removeEverything(){
  for (int i = physics.particles.size() - 1; i >= 0; i--) {
    physics.particles.remove(i);
  }
  
  for (int i = physics.behaviors.size() - 1; i >= 0; i--) {
    physics.behaviors.remove(i);
  }
  
  for (int i = physics.springs.size() - 1; i >= 0; i--) {
    physics.springs.remove(i);
  } 
}

void doubleSize(){
  ArrayList<VerletParticle2D> particles = new ArrayList<VerletParticle2D>(physics.particles);
  removeEverything();
  
  
  VerletParticle2D p0 = addParticle(particles.get(0));
  
  for (int i=1; i<numParticles; i++){
    Vec2D p1 = particles.get(i);
    Vec2D p2 = particles.get(i-1);
    Vec2D pos = new Vec2D((p1.x+p2.x)/2,(p1.y+p2.y)/2);
    VerletParticle2D p = addParticle(pos);
    VerletParticle2D prev = physics.particles.get(physics.particles.size()-2);
    VerletSpring2D s = new VerletSpring2D(p,prev,restLength,1);
    physics.addSpring(s);
    
    p = addParticle(particles.get(i));
    prev = physics.particles.get(physics.particles.size()-2);
    s = new VerletSpring2D(p,prev,restLength,1);
    physics.addSpring(s);
    
  }
  println(numParticles);
  numParticles = numParticles*2 -1;
  println(numParticles,physics.particles.size()); 
  
}

void mousePressed(){
 doubleSize();

}

void keyPressed(){
   if (key == 'r'){
     removeEverything();
     numParticles = 100;
     drawRope();
   }
   
   if (key == 'c'){
    cCircle = !cCircle;
    
    cSquare = false;
   }
   
    if (key == 's'){
    cCircle = false;
    cSquare = !cSquare;
   }
   
   if (key == 'd'){
     doubleSize();
   }
   
   if (key == 'm'){
     createMesh();
   } 
   
   if (key == 'e'){
     saveMesh();
   } 
}

void saveMesh(){
  HET_Export.saveToOBJ(mesh,sketchPath(""),"rope");
}

void createMesh(){
  int n = physics.particles.size();
  points = new WB_Point[n];
  for (int i=0;i<n;i++) {
    VerletParticle2D p = physics.particles.get(i);
    points[i]=new WB_Point(p.x, p.y, 0);
  }
  C=new WB_BSpline(points, 4);

  HEC_SweepTube creator=new HEC_SweepTube();
  creator.setCurve(C);//curve should be a WB_BSpline
  creator.setRadius(12);
  creator.setSteps(n*2);
  creator.setFacets(16);
  creator.setCap(true, true);  
  mesh=new HE_Mesh(creator); 
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this); 
  
  meshCreated = true;
}

void drawRope(){
  Vec2D startPos = new Vec2D(width/2-numParticles*restLength*0.5,height/2);
  addParticle(startPos);
  
  for (int i=0; i<numParticles-1; i++){
    VerletParticle2D p = addParticle(startPos.addSelf(restLength,0));
    VerletParticle2D prev = physics.particles.get(physics.particles.size()-2);
    VerletSpring2D s = new VerletSpring2D(p,prev,restLength,1);
    physics.addSpring(s);
  }
}