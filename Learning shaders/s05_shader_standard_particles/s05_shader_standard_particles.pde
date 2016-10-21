/*
 Renders one million particles with the standard processing point shader.
 The downside of this method is that for each vertex, processing creates 
 at least 4 more vertices to render the particles;
 
 The standard processing point shader doesn't scale the points;
 
 //Use the mouse to interact
*/

import peasy.*;

PeasyCam cam;
PShape particles;

PVector randomPos;
float x,y,z;
float noiseScale = 50;

int nop = 1000000;

void setup(){
  size(800, 600, P3D);
  pixelDensity(2);
  cam = new PeasyCam(this, 100);
  
  generateParticles();
}


void draw(){
  background(10);
  shape(particles);
  
}

void generateParticles(){
  particles = createShape();
  particles.beginShape(POINTS);
  
  for (int i=0; i<nop;i++){
    randomPos = getRandomPos(200);
    particles.strokeWeight(random(8));
    particles.stroke(randomPos.x/200*255,randomPos.y/200*255,randomPos.z/200*255);
    particles.vertex(randomPos.x,randomPos.y,randomPos.z);
  }
  
  particles.endShape();
    
}

//Get a random point using the noise function;
PVector getRandomPos(float size){
  float a = 0;
  while (a<0.5){
     x = random(size);
     y = random(size);
     z = random(size);
     a = noise(x/noiseScale,y/noiseScale,z/noiseScale);
  }
  return new PVector(x,y,z);
}