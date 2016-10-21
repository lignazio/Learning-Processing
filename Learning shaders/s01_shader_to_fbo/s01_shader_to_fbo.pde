/*
Create an fbo object (PShape) and run a shader to render inside the fbo
*/

PShader shader;
PGraphics fbo;

void setup(){
  size(800,600,P3D);
  
  shader=loadShader("gradient.glsl");
  shader.set("resolution",float(512),float(512));
  
  fbo = createGraphics(512,512,P2D);
}

void draw(){
  fbo.beginDraw();
    shader(shader);
    shader.set("time",millis()/1000.0);
    
    rect(0,0,width,height);
    resetShader();
  fbo.endDraw();
  
  //Show fbo to debug;
  image(fbo,0,0);
}