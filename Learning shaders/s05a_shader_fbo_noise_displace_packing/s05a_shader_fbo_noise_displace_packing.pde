/*
The shaders now encode and decode a float value to RGBA.
This technique allows to keep precision.
In order to achieve that I used 3 more textures
Each texture takes care of one axis
*/

import peasy.*;

PeasyCam cam;

PShader shader,dispx,dispy,dispz;
PShader displace;
PShape plane;
PGraphics fbo,fbox,fboy,fboz;

float planeSize = 200.0;

void setup(){
  size(800,600,P3D);
  cam = new PeasyCam(this, 200);
  shader=loadShader("noise.glsl");
  dispx=loadShader("displaceNoise.glsl");
  dispy=loadShader("displaceNoise.glsl");
  dispz=loadShader("displaceNoise.glsl");
  displace=loadShader("displaceFrag.glsl","displaceVert.glsl");
 
  shader.set("resolution",512.0,512.0);
  dispx.set("resolution",512.0,512.0);
  dispx.set("offset",0.0);
  dispy.set("resolution",512.0,512.0);
  dispy.set("offset",100.0);
  dispz.set("resolution",512.0,512.0);
  dispz.set("offset",200.0);
  
  displace.set("pscale",planeSize);
  fbo = createGraphics(512,512,P2D);
  fbox = createGraphics(512,512,P2D);
  fboy = createGraphics(512,512,P2D);
  fboz = createGraphics(512,512,P2D);
  plane = createPlane(512,512,200.0);//try 512*512 = 262144 points
  
  ((PGraphicsOpenGL)g).textureSampling(2);
}

void draw(){
  background(50);

  shader.set("time",millis()/1000.0);
  dispx.set("time",millis()/1000.0);
  dispy.set("time",millis()/1000.0);
  dispz.set("time",millis()/1000.0);

  //Update the fbos
  fbo.beginDraw();
  fbo.shader(shader);
  fbo.rect(0,0,fbo.width,fbo.height);
  fbo.resetShader();
  fbo.endDraw();
  
  fbox.beginDraw();
  fbox.shader(dispx);
  fbox.rect(0,0,fbox.width,fbox.height);
  fbox.resetShader();
  fbox.endDraw();
  
  fboy.beginDraw();
  fboy.shader(dispy);
  fboy.rect(0,0,fboy.width,fboz.height);
  fboy.resetShader();
  fboy.endDraw();
  
  fboz.beginDraw();
  fboz.shader(dispz);
  fboz.rect(0,0,fboz.width,fboz.height);
  fboz.resetShader();
  fboz.endDraw();
  //Show fbo for debug
  //image(fboy,0,0);
  
  displace.set("texturex",fbox);
  displace.set("texturey",fboy);
  displace.set("texturez",fboz);
  //Draw my plane
  shader(displace);
  shape(plane);
}

PShape createPlane(int rows,int cols, float size){
    ArrayList<PVector> positions = new ArrayList<PVector>();
    ArrayList<PVector> uvs = new ArrayList<PVector>();
    float u,v;
    float uSize = 1/(float)rows;
    float vSize = 1/(float)cols;
    
    for (int x=0; x<rows;x++){
      for (int y=0; y<cols; y++){
         u = x/(float)rows;
         v = y/(float)cols;
         
         positions.add(new PVector(u-0.5,v-0.5,0).mult(size));
         positions.add( new PVector(u+uSize-0.5, v-0.5, 0).mult(size) );
         positions.add( new PVector(u+uSize-0.5, v+vSize-0.5, 0).mult(size) );
         positions.add( new PVector(u-0.5, v+vSize-0.5, 0).mult(size) );
         
         uvs.add( new PVector(u, v) );
         uvs.add( new PVector(u+uSize, v) );
         uvs.add( new PVector(u+uSize, v+vSize) );
         uvs.add( new PVector(u, v+vSize) );
      }
    }
    
    
    //use normalized texture coordinates
    textureMode(NORMAL);
    
    //create a plane
    PShape mesh = createShape(); 
    mesh.beginShape(QUADS);  
    mesh.noStroke();
    mesh.texture(fbo);
    
    println(positions.size());
    for (int i=0;i<positions.size();i++){
       PVector p = positions.get(i);
       PVector t = uvs.get(i);
       mesh.vertex(p.x,p.y,p.z,t.x,t.y);
    }
     
    mesh.endShape();
    
    return mesh;
}