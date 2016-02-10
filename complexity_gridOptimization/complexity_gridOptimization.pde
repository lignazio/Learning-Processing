
import java.util.*;
import java.awt.Rectangle;

PImage sprite; 

ArrayList<Particle> particles;
ArrayList<Particle> check;
Particle newp;
Grid qt;
PGraphics circle;

int nParticles = 15000;
int count = 0;
PImage img;
float rythm = 0;
float growRatio = 0.8;
Particle p;
float g = 50.0;
boolean debugMode = false;
int debugId = 0;
float distance = 2;
float angle = random(TWO_PI);

void setup(){
  size(1200, 700,OPENGL);
  pixelDensity(2);
  
  img = loadImage("background3.jpg");
  img.loadPixels();
  
  sprite = loadImage("sprite.png");

  
  qt = new Grid(48,28);
  particles = new ArrayList<Particle>();
  check = new ArrayList<Particle>();
  for (int i=0; i<1; i++){
    particles.add(new Particle(width/2+1,height/2,count));
    count++;
  }
  noStroke();
  fill(255);
  hint(DISABLE_DEPTH_MASK);
  hint(DISABLE_DEPTH_TEST);
  //hint(ENABLE_ACCURATE_2D);
}

void draw(){
 
  background(0);
  fill(255);
 
   qt.clear();
  
  for (int i = 0; i < particles.size(); i++) {
    qt.insert(particles.get(i));
    
  }
  for (int i = particles.size()-1; i >= 0; i--) {
    p = particles.get(i);
    check = qt.getInsideCircle(p,30);
    for (int j = 0; j < check.size(); j++){
      if (p.id != check.get(j).id){
        p.applyForce(check.get(j).attract(p));
      }
    }
    
    p.setRadius(img);
    p.update();
    drawParticle(p);
    //p.display();
    
    if (p.age > p.spawnAge && p.velocity.magSq() < 1 && !p.spawned && count<nParticles){
       p.spawned = true;  
       angle = random(TWO_PI);
       //angle -= PI;
       
       newp = new Particle(p.location.x+sin(angle)*distance,p.location.y+cos(angle)*distance,count);
       count++;
       newp.spawnAge+=floor(rythm);
       particles.add(newp);
       newp = new Particle(p.location.x-sin(angle)*distance,p.location.y-cos(angle)*distance,count);
       newp.spawnAge+=floor(rythm);
       particles.add(newp);
       count++;
       rythm+=growRatio;
       
    }
    
    
  }
  
  println(frameRate);
  
  if (debugMode){
    text("count:" + count, 10, height-30); 
      p = particles.get(debugId);
      fill(255,0,0);
      p.display();
      fill(0,255,0);
      check = qt.getInsideCircle(p,30);
      for (int j = 0; j < check.size(); j++){
        if (p.id != check.get(j).id){
          check.get(j).display();
        }
      }
      stroke(50);
      qt.drawGrid();
      noStroke();
  }
  
  
}

void drawParticle(Particle p) {
  beginShape(QUAD);
  //noStroke();
  tint(255);
  texture(sprite);
  normal(0, 0, 1);
  vertex(p.location.x - p.r, p.location.y - p.r, 0, 0);
  vertex(p.location.x + p.r, p.location.y - p.r, sprite.width , 0);
  vertex(p.location.x + p.r, p.location.y + p.r, sprite.width, sprite.height);
  vertex(p.location.x - p.r, p.location.y + p.r, 0, sprite.height);                
  endShape();  
}

void keyPressed(){
  if (key=='d'){
    debugMode = !debugMode; 
    println(particles.get(debugId).id);
  }
}