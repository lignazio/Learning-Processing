/*
Sketch to test the fragment coordinates.
In the fragment shader the upper left corner of the screen isn't (0,0) but (0,1);
so it has to be flipped (see shader code);

  f. shader            processing 
0,1--------1,1       0,0--------1,0
 |          |         |          |
 |          |         |          |
0,0--------1,0       0,1--------1,1

Notice: I cannot use the word texture as uniform name, so I used texture1,
maybe the word texture is reserved?
*/

PImage image;
PShader shader;

void setup(){
  size(800,600,P3D);
  
  shader = loadShader("frag.glsl");
  image = loadImage("texture.jpg");
  
  shader.set("texture1",image);
  shader.set("resolution",float(width),float(height));
}

void draw(){
  background(0);
  shader(shader);
  rect(0,0,width,height);
}