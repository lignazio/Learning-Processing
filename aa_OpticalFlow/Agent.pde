class Agent{
  
  PVector position, velocity, acceleration;
  
  float maxSpeed, maxForce;
  
  PVector pastTarget, futPosition;
  
  float r = 5.0;
  color c;
  float dist = 50; 
  
  float desiredSeparation = 50;
  
 public Agent(PVector p, float ms, float mf){
   pastTarget = new PVector(0,0);
   
   r=5.0;
   c = 255;
   position = p.copy();
   maxSpeed = ms;
   maxForce = mf;
   velocity = new PVector(0,0);
   acceleration = new PVector(0,0);
 }
 
 void run(){
   update();
   borders();
   //boundaries();
   display();
 }
 
 void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  

  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxSpeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
  
 void steer(PVector desired){
   PVector steer = PVector.sub(desired,velocity);
   steer.limit(maxForce);
   applyForce(steer);
 }
 
 
 void seek(PVector target){
   PVector desired = PVector.sub(target,position);
   desired.normalize();
   
   desired.mult(maxSpeed);
   steer(desired);
   
 }
 
 
 
 
 void flee(PVector target){
   PVector desired = PVector.sub(target,position);
   desired.normalize();
   
   desired.mult(-maxSpeed);
   
   steer(desired);
 }
 
 
 
 
 
  void fleeStop(PVector target){
   PVector desired = PVector.sub(target,position);
   
   float d = desired.mag();
   desired.normalize();
   
   if (d > 400){
     float m = map(d,400,500,-maxSpeed,0);
     desired.mult(m);
   }else{
     desired.mult(-maxSpeed); 
   }
   
   steer(desired);
 }
 
 
 
 
 void arrive(PVector target){
   PVector desired = PVector.sub(target,position);
   float d = desired.mag();
   desired.normalize();
   if (d < 100){
     float m = map(d,0,100,0,maxSpeed);
     desired.mult(m);
   }else{
     desired.mult(maxSpeed); 
   }
   steer(desired);
 }
 
 
 
 
 
 void pursuit(PVector target){
   PVector targetVel = PVector.sub(target,pastTarget);
   PVector distance = PVector.sub(target,position);
   targetVel.normalize();
   targetVel.mult(distance.mag()*0.5);
   targetVel.add(target);
   
   arrive(targetVel);
   pastTarget = target.copy();
 }
 
 
 
 
 
 
  void evasion(PVector target){
   PVector targetVel = PVector.sub(target,pastTarget);
   PVector distance = PVector.sub(target,position);
   targetVel.normalize();
   targetVel.mult(distance.mag()*0.5);
   targetVel.add(target);
   
   fleeStop(targetVel);
   pastTarget = target.copy();
 }
 
 
 
 
 void followForward(FlowField field){
     futPosition = velocity.copy();
     futPosition.normalize();
     futPosition.mult(r*4);
     futPosition.add(position);
     PVector desired = field.lookup(futPosition);
     desired.mult(maxSpeed);
     
     steer(desired);
 }
 
 void follow(FlowField field){
     PVector desired = field.lookup(position);
     desired.mult(maxSpeed);
     
     steer(desired);
 }
 
 
 
 
 
 void separate(ArrayList<Agent> others){
   PVector sum = new PVector();
   int count = 0;
   
   for (Agent other : others){
     float d = PVector.dist(position, other.position);
     if (d > 0 && d < desiredSeparation){
       PVector diff = PVector.sub(position,other.position);
       diff.normalize();
       sum.add(diff);
       count++;
     }
   }
   
   if (count > 0){
     sum.div(count); 
     sum.setMag(maxSpeed);
     steer(sum);
   }
 }
 
 
 
 void displayTarget(){
   fill(c);
   noStroke();
   ellipse(futPosition.x,futPosition.y,6,6);
 }
 
 
 
 void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(c);
    noStroke();
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }
 
 // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
  
  void boundaries() {

    PVector desired = null;

    if (position.x < dist) {
      desired = new PVector(maxSpeed, velocity.y);
    } 
    else if (position.x > width - dist) {
      desired = new PVector(-maxSpeed, velocity.y);
    } 

    if (position.y < dist) {
      desired = new PVector(velocity.x, maxSpeed);
    } 
    else if (position.y > height-dist) {
      desired = new PVector(velocity.x, -maxSpeed);
    } 

    if (desired != null) {
      desired.normalize();
      desired.mult(maxSpeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      applyForce(steer);
    }
  }  
}