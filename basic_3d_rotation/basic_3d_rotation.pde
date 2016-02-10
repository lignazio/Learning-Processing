import peasy.*;
PeasyCam cam;
PVector[] v;
PVector linea;
float r=5;

PVector x,y,z;

void setup(){
  size(1280,720,P3D); 
  cam = new PeasyCam(this,100);
  
  linea = new PVector(.3,.2,.5);
  linea.normalize();

  v = new PVector[5];
    v[0] = new PVector(0, -r*2, 0);                                      // top of the pyramid
    v[1] = new PVector(r*cos(HALF_PI), r*2, r*sin(HALF_PI)); // base point 1
    v[2] = new PVector(r*cos(PI), r*2, r*sin(PI));           // base point 2
    v[3] = new PVector(r*cos(1.5*PI), r*2, r*sin(1.5*PI));   // base point 3
    v[4] = new PVector(r*cos(TWO_PI), r*2, r*sin(TWO_PI));   // base point 4

    x = new PVector(1,0,0);
    y = new PVector(0,1,0);
    z = new PVector(0,0,1);
}

void draw(){
  background(255);
  stroke(255,0,0);
  line(0,0,0,20,0,0);
  stroke(0,255,0);
  line(0,0,0,0,20,0);
  stroke(0,0,255);
  line(0,0,0,0,0,20);
  stroke(0);
  linea.mult(20);
  line(0,0,0,linea.x,linea.y,linea.z);
  linea.normalize();
  
  
  
  pushMatrix();
    translate(0,0,0);
    float rx = asin(-linea.y)-HALF_PI;
    float ry = atan2(linea.x, linea.z);
    rotateY(ry);
    rotateX(rx);
    beginShape(TRIANGLE_FAN);
    for (int i=0; i<5; i++) {
      vertex(v[i].x, v[i].y, v[i].z); // set the vertices based on the object coordinates defined in the createShape() method
    }
    vertex(v[1].x, v[1].y, v[1].z);
    endShape();
    popMatrix();
}