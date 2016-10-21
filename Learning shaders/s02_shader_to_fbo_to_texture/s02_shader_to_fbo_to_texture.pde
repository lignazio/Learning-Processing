/*
How to render a fragment shader inside a fbo object
and then use that fbo as a texture for a 3D plane

Use the mouse to rotate the view;
*/

import peasy.*;

PeasyCam cam;

PShader shader;
PShape plane;
PGraphics fbo;

void setup(){
  size(800,600,P3D);
  cam = new PeasyCam(this, 200);
  
  shader=loadShader("gradient.glsl");
  shader.set("resolution",1024.0,1024.0);
  
  fbo = createGraphics(1024,1024,P2D);
  plane = createPlane();
}

void draw(){
  background(0);
  
  shader.set("time",millis()/1000.0);
  
  //Update the fbo
  fbo.beginDraw();
  fbo.shader(shader);
  fbo.rect(0,0,fbo.width,fbo.height);
  fbo.resetShader();
  fbo.endDraw();
  
  //Draw my plane
  shape(plane);
}

PShape createPlane(){
    //use normalized texture coordinates
    textureMode(NORMAL);
    
    //create a plane
    PShape mesh = createShape(); 
    mesh.beginShape(QUADS);  
    mesh.noStroke();
    mesh.texture(fbo);
     
    mesh.vertex(-100,-100,0,0,0); //add vertices (R,G,B,U,V);
    mesh.vertex(100,-100,0,1,0);
    mesh.vertex(100,100,0,1,1);
    mesh.vertex(-100,100,0,0,1);
    mesh.endShape();
    
    return mesh;
}