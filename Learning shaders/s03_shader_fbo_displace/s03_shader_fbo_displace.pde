/*
How to render a shader into an fbo and then use that fbo as a texture
for a second shader. 
The second shader takes the values from the texture and apply a displace 
to each vertices according to the colors of the texture.
*/

import peasy.*;

PeasyCam cam;

PShader shader;
PShader displace;
PShape plane;
PGraphics fbo;



void setup(){
  size(800,600,P3D);
  cam = new PeasyCam(this, 200);
  
  shader=loadShader("gradient.glsl");
  displace=loadShader("displaceFrag.glsl","displaceVert.glsl");
 
  shader.set("resolution",512.0,512.0);
  
  fbo = createGraphics(512,512,P2D);
  plane = createPlane(64,64,200); //x segments,y segments, size
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
  shader(displace);
  shape(plane);
}



//Function to create a plane of quads;
PShape createPlane(int rows,int cols, float size){
    //Arraylists to store positions and uv coordinates of each vertex;
    ArrayList<PVector> positions = new ArrayList<PVector>();
    ArrayList<PVector> uvs = new ArrayList<PVector>();
    float u,v;
    float uSize = 1/(float)rows;
    float vSize = 1/(float)cols;
    
    //Put data inside the arraylists
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
    
    for (int i=0;i<positions.size();i++){
       PVector p = positions.get(i);
       PVector t = uvs.get(i);
       mesh.vertex(p.x,p.y,p.z,t.x,t.y);
    }
     
    mesh.endShape();
    
    return mesh;
}