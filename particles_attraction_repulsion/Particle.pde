class Particle{

  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float r;
  float c;
  float maxForce;
  float maxSpeed;
  boolean colliding = false;
  
  public Particle(float x, float y){
     acceleration = new PVector (0,0);
     velocity = new PVector (0,0);
     location = new PVector (x,y);
     c=noise(mouseX,mouseY)*255;
     r= random(10,60);
     maxSpeed = 4;
     maxForce = 0.3;
  }
  
  void applyForce(PVector force){
      acceleration.add(force);
  }
  
  void update(){
     velocity.add(acceleration);
     velocity.limit(maxSpeed);
     location.add(velocity);
     acceleration.mult(0);
    // borders();
  }
  
   void applyBehaviors(ArrayList<Particle> particles) {
     PVector separateForce = separate(particles);
     PVector seekForce = seek(new PVector(width/2,height/2));
     separateForce.mult(1.5);
     seekForce.mult(1);
     applyForce(separateForce);
     applyForce(seekForce); 
     //collide(particles);
  }
  
  PVector seek(PVector target){
     PVector desired = PVector.sub(target,location);
     desired.normalize();
     desired.mult(maxSpeed);
     
     PVector steer = PVector.sub(desired,velocity);
     steer.limit(maxForce);
    return steer;
  }
  void collide(ArrayList<Particle> particles){
    
    for (Particle other : particles){
        collideEqualMass(other); 
      }
  }
  
  PVector cohesion(ArrayList<Particle> particles){
      float desiredSep = 1000;
      PVector sum = new PVector();
      int count = 0;
      for (Particle other : particles){
         float d = PVector.dist(location, other.location);
         if ((d > 0) && (d < desiredSep)){
            sum.add(other.location);
            count++;
         }
      }
      if (count > 0){
          return seek(sum);
      }else{
        return new PVector(0,0);
      }
  }
  
  void collideEqualMass(Particle other) {
    float d = PVector.dist(location,other.location);
    float sumR = r + other.r;
    // Are they colliding?
    if (!colliding && d < sumR) {
      // Yes, make new velocities!
      colliding = true;
      println("colliding");
      // Direction of one object another
      PVector n = PVector.sub(other.location,location);
      n.normalize();

      // Difference of velocities so that we think of one object as stationary
      PVector u = PVector.sub(velocity,other.velocity);

      // Separate out components -- one in direction of normal
      PVector un = componentVector(u,n);
      // Other component
      u.sub(un);
      // These are the new velocities plus the velocity of the object we consider as stastionary
      velocity = PVector.add(u,other.velocity);
      other.velocity = PVector.add(un,other.velocity);
    } 
    else if (d > sumR) {
      colliding = false;
    }
  }
  
  PVector separate(ArrayList<Particle> particles){
      PVector sum = new PVector();
      int count = 0;
      for (Particle other : particles){
        
         float d = PVector.dist(location, other.location);
          
         if ((d > 0) && (d < (r+other.r))){
           PVector diff = PVector.sub (location,other.location);
            diff.normalize();
            diff.div(d);
            sum.add(diff);  
            stroke(250);
            line (location.x,location.y,other.location.x,other.location.y);
            noStroke();
            count++;
         }       
      }
      if (count > 0){
          sum.div(count);
          sum.normalize();
          sum.setMag(maxSpeed);
          sum.sub(velocity);
          sum.limit(maxForce);
      }   
      return sum;
  }
  
  
  
  void display(){
     stroke(c,50,50,150);
     noFill();
     pushMatrix();
     translate(location.x,location.y);
     ellipse(0,0,r*2,r*2);
     popMatrix();
  } 
  
  void borders() {
      if (location.x < -r) location.x = width+r;
      if (location.y < -r) location.y = height+r;
      if (location.x > width+r) location.x = -r;
      if (location.y > height+r) location.y = -r;
    }
}

PVector componentVector (PVector vector, PVector directionVector) {
  //--! ARGUMENTS: vector, directionVector (2D vectors)
  //--! RETURNS: the component vector of vector in the direction directionVector
  //-- normalize directionVector
  directionVector.normalize();
  directionVector.mult(vector.dot(directionVector));
  return directionVector;
}