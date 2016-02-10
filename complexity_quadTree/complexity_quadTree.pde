import java.util.*;
import java.awt.Rectangle;

Quadtree qt;
ArrayList<Particle> particles;
ArrayList<Particle> check;
Particle p;

float g = 0.3;


boolean debugMode;
int debugId = 0;

void setup(){
  size(600,600);
  qt = new Quadtree(0, new Rectangle(0,0,600,600)); 
  particles = new ArrayList<Particle>();
  check = new ArrayList<Particle>();
  for (int i = 0; i < 1000; i++){
    particles.add(new Particle(random(width),random(height),i));
  }
}

void draw(){
  background(0);
  fill(255);
  qt.clear();
  for (int i = 0; i < particles.size(); i++) {
    qt.insert(particles.get(i));   
  }
 
  for (int i = 0; i < particles.size(); i++) {
    p = particles.get(i);
 
    check.clear();
    qt.retrieve(check, p);
    
    for (int j = 0; j < check.size(); j++){
      if (p.id != check.get(j).id){
        p.applyForce(check.get(j).attract(p));
      }
    }
    p.update();
    p.display(); 
  }
  
  if (debugMode){
      p = particles.get(debugId);
      fill(255,0,0);
      p.display();
      fill(0,255,0);
      check.clear();
      qt.retrieve(check, p);
      println(check.size());
      for (int j = 0; j < check.size(); j++){
        if (p.id != check.get(j).id){
          check.get(j).display();
        }
      }
  }
 
}


void keyPressed(){
  if (key=='d'){
    debugMode = !debugMode; 
    println(particles.get(debugId).id);
  }
}