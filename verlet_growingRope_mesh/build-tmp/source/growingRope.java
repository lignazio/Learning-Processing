import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.physics.*; 
import toxi.physics.behaviors.*; 
import toxi.physics.constraints.*; 
import toxi.physics2d.*; 
import toxi.physics2d.behaviors.*; 
import toxi.physics2d.constraints.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class growingRope extends PApplet {








int numParticles = 100;
float restLength = 10.0f;

VerletPhysics2D physics;
VerletParticle2D head,tail;

Iterator<VerletParticle2D> it;

public void setup(){
  

  physics = new VerletPhysics2D();
  Vec2D stepDir = new Vec2D(1,0).normalizeTo(REST_LENGTH);
  ParticleString2D s = new ParticleString2D(physics, new Vec2D(), stepDir, NUM_PARTICLES, 1, 0.1f);
  head = s.getHead();
  tail = s.getTail();

   noFill();
   stroke(255);
}

public void draw(){
  background(0);
  physics.update();
  it = physics.particles.iterator();
  beginShape();

  while(it.hasNext()){
  	VerletParticle2D p = (VerletParticle2D)it.next();
  	vertex(p.x,p.y);
  }
  endShape();
}
  public void settings() {  size(1280,720,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "growingRope" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
