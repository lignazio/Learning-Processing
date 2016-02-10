/*
Complexity, grid structure allow calculations to be made
in the neighbourood only.
*/

import java.util.*;
import java.awt.Rectangle;

Grid grid;
ArrayList<Particle> particles;
ArrayList<Particle> check;
Particle p;

float g = 1;


boolean debugMode;
int debugId = 0;

void setup(){
  size(800,600);
  grid = new Grid(8,6); 
  particles = new ArrayList<Particle>();
  check = new ArrayList<Particle>();
  for (int i = 0; i < 1000; i++){
    particles.add(new Particle(random(width),random(height),i));
  }
}

void draw(){
  background(0);
  fill(255);
  noStroke();
  grid.clear();
  for (int i = 0; i < particles.size(); i++) {
    grid.insert(particles.get(i));   
  }
 
  for (int i = 0; i < particles.size(); i++) {
    p = particles.get(i);
 
    check.clear();
    check = grid.getInsideCircle(p,100);
    
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
      check = grid.getInsideCircle(p,100);
      for (int j = 0; j < check.size(); j++){
        if (p.id != check.get(j).id){
          check.get(j).display();
        }
      }
      stroke(50);
      grid.drawGrid();
       
  }
 
}


void keyPressed(){
  if (key=='d'){
    debugMode = !debugMode; 
    println(particles.get(debugId).id);
  }
}