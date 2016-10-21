/*
Same as before with a slightly more appealing cloud
*/

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;
import com.jogamp.opengl.GL2ES2;

import peasy.*;

PeasyCam cam;

PShader shader;
PGraphics gradient;
color[] palette;
float a;

PJOGL pgl;
GL2ES2 gl;

int nop = 1000000;

float[] positions;
float[] colors;
float[] sizes;
int[] indices;

FloatBuffer posBuffer;
FloatBuffer colorBuffer;
FloatBuffer sizeBuffer;
IntBuffer indexBuffer;

int posVboId;
int colorVboId;
int sizeVboId;
int indexVboId;

int posLoc; 
int colorLoc;
int sizeLoc;

PVector randomPos,pv;
float x, y, z;
float noiseScale = 100;

void setup() {
  size(800, 600, P3D);
  pixelDensity(2);
  cam = new PeasyCam(this, 100);
  shader = loadShader("frag.glsl", "vert.glsl");  

  positions = new float[nop*4];
  colors = new float[nop*4];
  sizes = new float[nop];
  indices = new int[nop];

  createPalette();
  generateParticles();

  posBuffer = allocateDirectFloatBuffer(nop*4);
  colorBuffer = allocateDirectFloatBuffer(nop*4);
  sizeBuffer = allocateDirectFloatBuffer(nop);
  indexBuffer = allocateDirectIntBuffer(nop);

  posBuffer.put(positions);
  posBuffer.rewind();

  colorBuffer.put(colors);
  colorBuffer.rewind();

  sizeBuffer.put(sizes);
  sizeBuffer.rewind();

  indexBuffer.put(indices);
  indexBuffer.rewind();

  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL2ES2();

  // Get GL ids for all the buffers
  IntBuffer intBuffer = IntBuffer.allocate(4);  
  gl.glGenBuffers(4, intBuffer);
  posVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);
  sizeVboId = intBuffer.get(2);
  indexVboId = intBuffer.get(3);   

  shader.bind();
  posLoc = gl.glGetAttribLocation(shader.glProgram, "position");
  colorLoc = gl.glGetAttribLocation(shader.glProgram, "color");
  sizeLoc = gl.glGetAttribLocation(shader.glProgram, "size");
  shader.unbind();

  endPGL();
}

void draw() {
  background(100);
  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL2ES2();

  shader.bind();

  gl.glEnableVertexAttribArray(posLoc);
  gl.glEnableVertexAttribArray(colorLoc);  
  gl.glEnableVertexAttribArray(sizeLoc);  

  // Copy vertex data to VBOs
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, posVboId);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(posLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, colorVboId);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(colorLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, sizeVboId);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * sizes.length, sizeBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(sizeLoc, 1, GL.GL_FLOAT, false, 1 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);


  gl.glEnable(GL3.GL_PROGRAM_POINT_SIZE);

  // Draw the triangle elements
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glDrawElements(GL.GL_POINTS, nop, GL.GL_UNSIGNED_INT, 0);

  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);

  gl.glDisableVertexAttribArray(posLoc);
  gl.glDisableVertexAttribArray(colorLoc); 
  gl.glDisableVertexAttribArray(sizeLoc); 
  shader.unbind();
  endPGL();
}


void generateParticles() {

  int index = 0;
  for (int i = 0; i<nop; i++) {
    indices[i] = i;
    randomPos = getRandomPos(200);
    positions[index] = randomPos.x-100;
    positions[index+1] = randomPos.y-100;
    positions[index+2] = randomPos.z-100;
    positions[index+3] = 1.0;
    float a = noise(randomPos.x/noiseScale, randomPos.y/noiseScale, randomPos.z/noiseScale);
    sizes[i] = 4.0+16*a;
    color c = palette[floor(a*100)];
    colors[index] =   (c >> 16 & 0xFF)/255.0;
    colors[index+1] = (c >> 8 & 0xFF)/255.0;
    colors[index+2] = (c & 0xFF)/255.0;
    colors[index+3] = 1.0;

    index+=4;
  }
}

PVector getRandomPos(float size) {
  float a = 0;
  float trying = 0;
   while (a<0.5 || trying < 10) {
    pv = PVector.random3D(); 
    pv.mult(random(size));
    pv.add(new PVector(size*0.5,size*0.5,size*0.5));
    a = noise(pv.x/noiseScale, pv.y/noiseScale, pv.z/noiseScale);
    trying++;
  }
  return pv;
}

  

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}

IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}


//utility function to create a custom gradient;
void createPalette(){
  gradient = createGraphics(100,100,P3D);
  gradient.beginDraw();
  gradient.beginShape();
  gradient.strokeWeight(100);
  gradient.stroke(26,81,115);
  gradient.vertex(0,50);
  gradient.stroke(26,81,115);
  gradient.vertex(20,50);
  gradient.stroke(231,137,166);
  gradient.vertex(30,50);
  gradient.stroke(253,255,237);
  gradient.vertex(50,50);
  gradient.stroke(253,255,237);
  gradient.vertex(100,50);
  gradient.endShape();
  gradient.endDraw();
  
  palette = new color[100];
  for (int i = 0; i<100;i++){
    palette[i] = gradient.get(i,20); 
  }

}