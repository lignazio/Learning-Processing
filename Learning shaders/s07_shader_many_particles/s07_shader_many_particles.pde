/*
This sketch uses native jogl calls and a custom shader
to render one million particles.

This runs much faster than native point shader because
the custom shader uses only one vertex for each particles

The code is based on: https://github.com/processing/processing/wiki/Advanced-OpenGL
*/

//Import java libraries
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;
import com.jogamp.opengl.GL2ES2;

//import peasycam to interact with the scene
import peasy.*;

PeasyCam cam;

PShader shader;
float a;

// declare processing gl and standard gl objects
PJOGL pgl;
GL2ES2 gl;

int nop = 1000000; //set the number of particles

//declare arrays to store position,color, size and index of each particles
float[] positions;
float[] colors;
float[] sizes;
int[] indices;

//declare buffers to contain each of the data;
FloatBuffer posBuffer;
FloatBuffer colorBuffer;
FloatBuffer sizeBuffer;
IntBuffer indexBuffer;

//Integers to store and id for each buffer
int posVboId;
int colorVboId;
int sizeVboId;
int indexVboId;
//Integers to store each attribute
int posLoc; 
int colorLoc;
int sizeLoc;

PVector randomPos;
float x, y, z;
float noiseScale = 50;

void setup() {
  size(800, 600, P3D);
  pixelDensity(2);
  cam = new PeasyCam(this, 100);
  shader = loadShader("frag.glsl", "vert.glsl");  
  
  //create arrays
  //note: positions and colors contain 4 values for each particles
  //positions: x,y,z,w
  //colors: r,g,b,a,
  positions = new float[nop*4];
  colors = new float[nop*4];
  sizes = new float[nop];
  indices = new int[nop];

  //function to generate particles and store each attribute inside the arrays
  generateParticles();
  
  //allocate space for the buffers to be passed on the opengl call
  posBuffer = allocateDirectFloatBuffer(nop*4);
  colorBuffer = allocateDirectFloatBuffer(nop*4);
  sizeBuffer = allocateDirectFloatBuffer(nop);
  indexBuffer = allocateDirectIntBuffer(nop);
  
  //fill each buffer with data
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
  
  // get an unique id for each attribute
  shader.bind();
  posLoc = gl.glGetAttribLocation(shader.glProgram, "position");
  colorLoc = gl.glGetAttribLocation(shader.glProgram, "color");
  sizeLoc = gl.glGetAttribLocation(shader.glProgram, "size");
  shader.unbind();

  endPGL();
}

void draw() {
  background(10);
  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL2ES2();

  shader.bind();
  
  // enable attributes
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

  // Draw the vertices
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glDrawElements(GL.GL_POINTS, nop, GL.GL_UNSIGNED_INT, 0);

  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);
  
  // disable attributes
  gl.glDisableVertexAttribArray(posLoc);
  gl.glDisableVertexAttribArray(colorLoc); 
  gl.glDisableVertexAttribArray(sizeLoc); 
  shader.unbind();
  endPGL();
}








void generateParticles() {
  float size = 200.0;
  int index = 0;
  for (int i = 0; i<nop; i++) {
    indices[i] = i;
    randomPos = getRandomPos(size);
    positions[index] = randomPos.x - size/2;
    positions[index+1] = randomPos.y - size/2;
    positions[index+2] = randomPos.z - size/2;
    positions[index+3] = 1.0;
    float a = noise(randomPos.x/noiseScale, randomPos.y/noiseScale, randomPos.z/noiseScale);
    sizes[i] = 4.0+10*a;

    colors[index] =   randomPos.x/200;
    colors[index+1] = randomPos.y/200;
    colors[index+2] = randomPos.z/200;
    colors[index+3] = 1.0;

    index+=4;
  }
}

PVector getRandomPos(float size) {
  float a = 0;
  while (a<0.5) {
    x = random(size);
    y = random(size);
    z = random(size);
    a = noise(x/noiseScale, y/noiseScale, z/noiseScale);
  }
  return new PVector(x, y, z);
}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}

IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}