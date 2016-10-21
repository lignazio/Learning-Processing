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

PJOGL pgl;
GL2ES2 gl;

float[] data;
FloatBuffer dataBuffer;
int[] textId;

float[] positions;
float[] colors;
float[] uvs;
int[] indices;

FloatBuffer posBuffer;
FloatBuffer uvsBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;

int posVboId;
int colorVboId;
int uvsVboId;
int indexVboId;

int posLoc; 
int colorLoc;
int uvsLoc;
int textLoc;

void setup(){
  size(800,600,P3D);
  cam = new PeasyCam(this, 100);
  
  
  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL2ES2();
  shader = loadShader("frag.glsl","vert.glsl");  
  
  positions = new float[4*4];
  colors = new float[4*4];
  uvs = new float[4*2];
  indices = new int[4+2];
  
  
  
  posBuffer = allocateDirectFloatBuffer(4*4);
  colorBuffer = allocateDirectFloatBuffer(4*4);
  uvsBuffer = allocateDirectFloatBuffer(4*2);
  indexBuffer = allocateDirectIntBuffer(4+2);
  
  generateGeometry();
  
  // Get GL ids for all the buffers
  IntBuffer intBuffer = IntBuffer.allocate(4);  
  gl.glGenBuffers(4, intBuffer);
  posVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);
  uvsVboId = intBuffer.get(2);  
  indexVboId = intBuffer.get(3);   
   
  
  data = new float[512*512*4];
  int i = 0;
  for (int x = 0; x<512;x++){
   for (int y = 0; y<512;y++){
      data[i] = x/512.0;;
      data[i+1] = y/512.0;
      data[i+2] = 3.130;
      data[i+3] = 1.0;
      i+=4;
   }
  }
  
  dataBuffer = allocateDirectFloatBuffer(512*512*4);
  dataBuffer.put(data);
  dataBuffer.rewind();
  
  textId = new int[1];
  gl.glActiveTexture(GL.GL_TEXTURE0); 
  //gl.glEnable(GL.GL_TEXTURE_2D); 
  shader.bind();
 

  gl.glGenTextures(1, textId,0);
  gl.glBindTexture(GL.GL_TEXTURE_2D, textId[0]);
  gl.glTexImage2D(GL.GL_TEXTURE_2D, 0, GL.GL_RGBA32F, 512, 512, 0,  GL.GL_RGBA,  GL.GL_FLOAT, dataBuffer);
  
  posLoc = gl.glGetAttribLocation(shader.glProgram, "position");
  colorLoc = gl.glGetAttribLocation(shader.glProgram, "color");
  uvsLoc = gl.glGetAttribLocation(shader.glProgram, "uvs");
  textLoc = gl.glGetUniformLocation(shader.glProgram, "texture");

  
  shader.unbind();
  
  endPGL();
  
}

void draw(){
  background(100);
  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL2ES2();
  
  shader.bind();
  //gl.glEnable(GL.GL_TEXTURE_2D); 
  gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_NEAREST);

  gl.glBindTexture(GL.GL_TEXTURE_2D,textId[0]);
  
  gl.glEnableVertexAttribArray(posLoc);
  gl.glEnableVertexAttribArray(colorLoc);  
  gl.glEnableVertexAttribArray(uvsLoc);  
  gl.glUniform1i(textLoc,0);
  
   // Copy vertex data to VBOs
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, posVboId);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(posLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, colorVboId);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(colorLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);
  
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, uvsVboId);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * uvs.length, uvsBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(uvsLoc, 2, GL.GL_FLOAT, false, 2 * Float.BYTES, 0);
  
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);
  
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glDrawElements(PGL.TRIANGLES, indices.length, GL.GL_UNSIGNED_INT, 0);
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);    

  gl.glDisableVertexAttribArray(posLoc);
  gl.glDisableVertexAttribArray(colorLoc); 
  gl.glDisableVertexAttribArray(uvsLoc); 
  
  shader.unbind();
  
  endPGL();
}

void generateGeometry(){
    // Vertex 1
  positions[0] = -200;
  positions[1] = -200;
  positions[2] = 0;
  positions[3] = 1;

  colors[0] = 1.0f;
  colors[1] = 1.0f;
  colors[2] = 1.0f;
  colors[3] = 1.0f;

  // Vertex 2
  positions[4] = +200;
  positions[5] = -200;
  positions[6] = 0;
  positions[7] = 1;

  colors[4] = 1.0f;
  colors[5] = 1.0f;
  colors[6] = 1.0f;
  colors[7] = 1.0f;

  // Vertex 3
  positions[8] = +200;
  positions[9] = +200;
  positions[10] = 0;
  positions[11] = 1;    

  colors[8] = 1.0f;
  colors[9] = 1.0f;
  colors[10] = 1.0f;
  colors[11] = 1.0f;

  // Vertex 4
  positions[12] = -200;
  positions[13] = +200;
  positions[14] = 0;
  positions[15] = 1;

  colors[12] = 1.0f;
  colors[13] = 1.0f;
  colors[14] = 1.0f;
  colors[15] = 1.0f;  
  
  //UVS
  uvs[0] = 0.0f;
  uvs[1] = 0.0f;
  
  uvs[2] = 1.0f;
  uvs[3] = 0.0f;
  
  uvs[4] = 1.0f;
  uvs[5] = 1.0f;
  
  uvs[6] = 0.0f;
  uvs[7] = 1.0f;
  
  // Triangle 1
  indices[0] = 0;
  indices[1] = 1;
  indices[2] = 2;

  // Triangle 2
  indices[3] = 2;
  indices[4] = 0;
  indices[5] = 3;
  
  posBuffer.rewind();
  posBuffer.put(positions);
  posBuffer.rewind();

  colorBuffer.rewind();
  colorBuffer.put(colors);
  colorBuffer.rewind();
  
  uvsBuffer.rewind();
  uvsBuffer.put(uvs);
  uvsBuffer.rewind();

  indexBuffer.rewind();
  indexBuffer.put(indices);
  indexBuffer.rewind();
}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}


IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}