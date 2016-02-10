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
  color c;
  float k = 0.001;
  int age = 0;
  int spawnAge = (int)random(80,120);
  float minr = 1.0;
  float maxr = 5.0;
  boolean spawned = false;
  
  Particle(float x, float y,int _id) {
    mass = 2;
    id = _id;
    r = 2;
    maxSpeed = 0.1;
    maxForce = 2;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    //PVector f = PVector.div(force, mass);
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
    //friction();
    borders();
    age+=1;
  }
  
  void friction(){
     friction = velocity.copy();
     friction.mult(-1);
     friction.normalize();
     friction.mult(k);
     
     applyForce(friction);
  }

  void display() {
    
    ellipse(location.x,location.y,r*2,r*2);
  }

  PVector attract(Particle p) {
    force = PVector.sub(p.location,location);             // Calculate direction of force
    distance = force.magSq(); 
    
      distance = constrain(distance, 1.0, 5000.0);                             // Limiting the distance to eliminate "extreme" results for very close or very far objects
      force.normalize();                                            // Normalize vector (distance doesn't matter here, we just want this vector for direction

      strength = (g) / (distance*4*PI); // Calculate gravitional force magnitude
      force.mult(strength);     // Get force vector --> magnitude * direction
      return force;
    
    
  }
  
  void setRadius (PImage img){
  
      loc = (int)location.x + (int)location.y*img.width;
      //c= img.get((int)location.x,(int)location.y);
      //c =  img.pixels[int(loc)];
      val = img.pixels[int(loc)] & 0xFF;
      r=  lerp(r,map(val,0.0,255.0,minr,maxr),0.01);
      
  }
  
  void borders() {
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