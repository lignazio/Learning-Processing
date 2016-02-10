/*
3D Implementation of a flock
*/

import peasy.*;

ArrayList<Agent> agents;
Agent a,b,c,d,e,f;
FlowField field;

PVector x,y,z;
float scale = 0.01;
float dt = 0;
boolean debug ;
PeasyCam cam;

void setup(){
  size(1280,720,P3D);
  agents = new ArrayList<Agent>();
  //agents.add(new Agent(new PVector(width/2,height/2),4,4));
  field = new FlowField(16);
  cam = new PeasyCam(this,100);
  
  x = new PVector(1,0,0);
  y = new PVector(0,1,0);
  z = new PVector(0,0,1);
  
  a = new Agent(new PVector(width/2,height/2),4,4);
  
  b = new Agent(new PVector(width/2,height/2),4,4);
  b.c = color(255,0,0);
  
  c = new Agent(new PVector(width/2,height/2),4,4);
  c.c = color(0,255,0);
  
  d = new Agent(new PVector(width/2,height/2),4,4);
  d.c = color(0,0,255);
  
  e = new Agent(new PVector(width/2,height/2),4,0.5);
  e.c = color(255,0,255);
  
  f = new Agent(new PVector(width/2,height/2),4,0.5);
  f.c = color(0,255,255);
  
  for (int i = 0; i < 400; i++){
    Agent g = new Agent(new PVector(random(width),random(height),random(width)),4,0.5);
    g.c = color(255,255,0);
    g.r = 2;
    
    agents.add(g);
  }
}


void draw(){
  background(0,0,30);
  stroke(255);
  noFill();
  pushMatrix();
  //translate(-500,-500,-500);
  box(1000, 1000, 1000);
  popMatrix();
  PVector target = new PVector(mouseX,mouseY);
   
    a.arrive(target);
    a.run(); 
    
    b.pursuit(target);
    b.run();
    
    c.fleeStop(target);
    c.run();
    
    d.evasion(target);
    d.run();
    
    
    field.update();
    
    if (debug) field.display();
    
    e.followForward(field);
    if (debug) e.displayTarget();
    e.run();
    
    f.follow(field);
    f.run();
    
    for (Agent a : agents){
     //a.separate(agents);
     a.flock(agents);
     //a.followForward(field);
     float dx =map(noise(a.position.x*scale, a.position.y*scale,a.position.z*scale+1.352+dt),0,1,-1,1);
     float dy =map(noise(a.position.x*scale, a.position.y*scale,a.position.z*scale+12.814+dt),0,1,-1,1); 
     float dz =map(noise(a.position.x*scale, a.position.y*scale,a.position.z*scale+42.814+dt),0,1,-1,1);
     
     PVector force = new PVector(dx,dy,dz);
     a.applyForce(force);
     a.run(); 
    }
    dt+=0.01;
}



void keyPressed(){
   if (key=='d'){
      debug = !debug; 
   }
}