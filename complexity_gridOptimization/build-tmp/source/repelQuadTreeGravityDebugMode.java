import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.awt.Rectangle; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class repelQuadTreeGravityDebugMode extends PApplet {

;



ArrayList<Particle> particles;
ArrayList<Particle> check;
Particle newp;
Quadtree qt;
int nParticles = 8000;
int count = 0;
PImage img;
float rythm = 0;
float growRatio = 1;
Particle p;
float g = 3.0f;
boolean debugMode = false;
int debugId = 10;
float distance = 2;
float angle = random(TWO_PI);

public void setup(){
  
  
  img = loadImage("background3.jpg");
  img.loadPixels();
  
  qt = new Quadtree(0,new Rectangle(0,0,width,height));
  particles = new ArrayList<Particle>();
  check = new ArrayList<Particle>();
  for (int i=0; i<1; i++){
    particles.add(new Particle(width/2+1,height/2,count));
    count++;
  }
  noStroke();
  fill(255);
}

public void draw(){
 
  background(0);
  fill(255);
   qt.clear();
  
  for (int i = 0; i < particles.size(); i++) {
    qt.insert(particles.get(i));
    
  }
  for (int i = particles.size()-1; i >= 0; i--) {
    p = particles.get(i);
    check.clear();
    qt.retrieve(check, p);
    for (int j = 0; j < check.size(); j++){
      if (p.id != check.get(j).id){
        p.applyForce(check.get(j).attract(p));
      }
    }
    
    p.setRadius(img);
    p.update();
    p.display();
    
    if (p.age > p.spawnAge && p.velocity.magSq() < 1 && !p.spawned && count<nParticles){
       p.spawned = true;  
       angle = p.velocity.heading();
       angle -= PI;
       
       newp = new Particle(p.location.x+sin(angle)*distance,p.location.y+cos(angle)*distance,count);
       count++;
       newp.spawnAge+=floor(rythm);
       particles.add(newp);
       newp = new Particle(p.location.x-sin(angle)*distance,p.location.y-cos(angle)*distance,count);
       newp.spawnAge+=floor(rythm);
       particles.add(newp);
       count++;
       rythm+=growRatio;
       
    }
    
    
  }
  
  text("count:" + count, 10, height-30); 
  
  if (debugMode){
      p = particles.get(debugId);
      fill(255,0,0);
      p.display();
      fill(0,255,0);
      check.clear();
      qt.retrieve(check, p);
      for (int j = 0; j < check.size(); j++){
        if (p.id != check.get(j).id){
          check.get(j).display();
        }
      }
  }
  
  
}

public void keyPressed(){
  if (key=='d'){
    debugMode = !debugMode; 
    println(particles.get(debugId).id);
  }
}
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Particle {

  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force,friction;
  float mass,r,distance,loc;
  float maxForce, maxSpeed,strength;
  int id,val;
  int c;
  float k = 0.01f;
  int age = 0;
  int spawnAge = (int)random(80,120);
  float minr = 1.0f;
  float maxr = 5.0f;
  boolean spawned = false;
  
  Particle(float x, float y,int _id) {
    mass = 2;
    id = _id;
    r = 2;
    maxSpeed = 0.1f;
    maxForce = 2;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  public void applyForce(PVector force) {
    //PVector f = PVector.div(force, mass);
    acceleration.add(force);
  }

  public void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
    friction();
    borders();
    age+=1;
  }
  
  public void friction(){
     friction = velocity.copy();
     friction.mult(-1);
     friction.normalize();
     friction.mult(k);
     
     applyForce(friction);
  }

  public void display() {
    
    ellipse(location.x,location.y,r*2,r*2);
  }

  public PVector attract(Particle p) {
    force = PVector.sub(p.location,location);             // Calculate direction of force
    distance = force.magSq(); 
    
      distance = constrain(distance, 1.0f, 5000.0f);                             // Limiting the distance to eliminate "extreme" results for very close or very far objects
      force.normalize();                                            // Normalize vector (distance doesn't matter here, we just want this vector for direction

      strength = (g) / (distance*4*PI); // Calculate gravitional force magnitude
      force.mult(strength);     // Get force vector --> magnitude * direction
      return force;
    
    
  }
  
  public void setRadius (PImage img){
  
      loc = (int)location.x + (int)location.y*img.width;
      //c= img.get((int)location.x,(int)location.y);
      //c =  img.pixels[int(loc)];
      val = img.pixels[PApplet.parseInt(loc)] & 0xFF;
      r=  lerp(r,map(val,0.0f,255.0f,minr,maxr),0.01f);
      
  }
  
  public void borders() {
      if ( location.x < r || location.x > width-r){
          velocity.x = -velocity.x;
      }
      if ( location.y < r || location.y > height-r){
          velocity.y = -velocity.y;
      }
      
      if (location.x> width-r) location.x = width-r;
      if (location.x< r) location.x = r;
      if (location.y> height-r) location.y = height-r;
      if (location.y< r) location.y = r;
      
  }

}
  class Quadtree {
    private int maxObjects = 10;
    private int maxLevels = 5;

    private int level;
    private ArrayList<Particle> objects;
    private Rectangle bounds;
    private Quadtree[] nodes;

    public Quadtree(int pLevel, Rectangle pBounds)
    {
      level = pLevel;
      objects = new ArrayList<Particle>();
      bounds = pBounds;
      nodes = new Quadtree[4];
    }

    public void clear() 
    {
      objects.clear();

      for (int i = 0; i < nodes.length; i++) {
       if (nodes[i] != null) {
         nodes[i].clear();
         nodes[i] = null;
       }
     }
   }

   public void split() {
     int subWidth = (int)(bounds.getWidth() / 2);
     int subHeight = (int)(bounds.getHeight() / 2);
     int x = (int)bounds.getX();
     int y = (int)bounds.getY();

     nodes[0] = new Quadtree(level+1, new Rectangle(x + subWidth, y, subWidth, subHeight));
     nodes[1] = new Quadtree(level+1, new Rectangle(x, y, subWidth, subHeight));
     nodes[2] = new Quadtree(level+1, new Rectangle(x, y + subHeight, subWidth, subHeight));
     nodes[3] = new Quadtree(level+1, new Rectangle(x + subWidth, y + subHeight, subWidth, subHeight));
   }
   
   
   private List getIndexes(Particle pParticle){
    ArrayList indexes = new ArrayList();

    double verticalMidpoint = bounds.getX() + (bounds.getWidth() / 2);
    double horizontalMidpoint = bounds.getY() + (bounds.getHeight() / 2);

    boolean topQuadrant = (pParticle.location.y + pParticle.r) <= horizontalMidpoint;
    boolean bottomQuadrant = (pParticle.location.y - pParticle.r) >= horizontalMidpoint;
    boolean topAndBottomQuadrant = pParticle.location.y - pParticle.r - 1 <= horizontalMidpoint && pParticle.location.y + pParticle.r + 1 <= horizontalMidpoint;

    if(topAndBottomQuadrant)
    {
      topQuadrant = false;
      bottomQuadrant = false;
    }

    if (pParticle.location.x + pParticle.r + 1 >= verticalMidpoint && pParticle.location.x -1 <= verticalMidpoint) 
    {
      if(topQuadrant)
      {
        indexes.add(2);
        indexes.add(3);
      }
      else if(bottomQuadrant)
      {
        indexes.add(0);
        indexes.add(1);
      }
      else if(topAndBottomQuadrant)
      {
        indexes.add(0);
        indexes.add(1);
        indexes.add(2);
        indexes.add(3);
      }
    }


              // Check if object is in just right quad
    else if(pParticle.location.x + 1 >= verticalMidpoint)
    {
      if(topQuadrant)
      {
        indexes.add(3);
      }
      else if(bottomQuadrant)
      {
        indexes.add(0);
      }
      else if(topAndBottomQuadrant)
      {
        indexes.add(3);
        indexes.add(0);
      }
    }
          // Check if object is in just left quad
    else if(pParticle.location.x - pParticle.r <= verticalMidpoint)
    {
      if(topQuadrant)
      {
        indexes.add(2);
      }
      else if(bottomQuadrant)
      {
        indexes.add(1);
      }
      else if(topAndBottomQuadrant)
      {
        indexes.add(2);
        indexes.add(1);
      }
    }
    else
    {
      indexes.add(-1);
    }

    return indexes;
  }



      /*
   * Insert the object into the quadtree. If the node
   * exceeds the capacity, it will split and add all
   * objects to their corresponding nodes.
   */
      public void insert(Particle pParticle) {
       if (nodes[0] != null) {

         List indexes = getIndexes(pParticle);
          
         for(int ii = 0; ii < indexes.size(); ii++)
         {
          int index = (int)indexes.get(ii);
          if(index != -1)
          {
            nodes[index].insert(pParticle);
            return;
          }
        }
      }

      objects.add(pParticle);

      if (objects.size() > maxObjects && level < maxLevels) {
        if (nodes[0] == null) { 
         split(); 
       }

       int i = 0;
       while (i < objects.size()) {
        Particle p = (Particle)objects.get(i);
        List indexes = getIndexes(p);
        
        for(int ii = 0; ii < indexes.size(); ii++)
        {
          int index = (int)indexes.get(ii);
          if (index != -1)
          {
            nodes[index].insert((Particle)objects.remove(i));
           // objects.remove(i);
           
          }
          else
          {
            i++;
          }
        }
      }
    }
  }


 public List retrieve(List returnObjects, Particle pParticle) {
   List indexes = getIndexes(pParticle);
   for(int ii = 0; ii < indexes.size(); ii++)
   {
    int index = (int)indexes.get(ii);
    if (index != -1 && nodes[0] != null) {
     nodes[index].retrieve(returnObjects, pParticle);
   }

   returnObjects.addAll(objects);

 }
 
 return returnObjects;
}
}
  public void settings() {  size(1280, 720,P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "repelQuadTreeGravityDebugMode" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
