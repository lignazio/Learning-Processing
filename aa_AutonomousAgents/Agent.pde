/*
Autonomous Agents Behaviours
see: http://www.red3d.com/cwr/steer/
*/

class Agent{
  
  PVector position, velocity, acceleration;
  
  float maxSpeed, maxForce;
  
  PVector pastTarget, futPosition;
  
  float r = 5.0;
  color c;
  float dist = 50; 
  float fov = radians(90);
  
  float desiredSeparation = r*3;
  
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
  
 /*
 Autonomous Agents behaviours
 see: http://www.red3d.com/cwr/steer/
 */
 
 /*
 Steer Formula by Reynolds
 */  
  
 PVector steer(PVector desired){
   PVector steer = PVector.sub(desired,velocity);
   steer.limit(maxForce);
   return steer;
 }
 
 /*
 Seek
 */  
 PVector seek(PVector target){
   PVector desired = PVector.sub(target,position);
   desired.normalize();
   
   desired.mult(maxSpeed);
   return steer(desired);
   
 }
 
 /*
 Flee
 */ 
 
 PVector flee(PVector target){
   PVector desired = PVector.sub(target,position);
   desired.normalize();
   
   desired.mult(-maxSpeed);
   
   return steer(desired);
 }
 
 
 /*
 Flee and arrive
 */ 
 
 
  PVector fleeStop(PVector target){
   PVector desired = PVector.sub(target,position);
   
   float d = desired.mag();
   desired.normalize();
   
   if (d > 400){
     float m = map(d,400,500,-maxSpeed,0);
     desired.mult(m);
   }else{
     desired.mult(-maxSpeed); 
   }
   
   return steer(desired);
 }
 
 
 /*
 Seek and arrive
 */ 
 
 PVector arrive(PVector target){
   PVector desired = PVector.sub(target,position);
   float d = desired.mag();
   desired.normalize();
   if (d < 100){
     float m = map(d,0,100,0,maxSpeed);
     desired.mult(m);
   }else{
     desired.mult(maxSpeed); 
   }
   return steer(desired);
 }
 
  /*
 Pursuit
 */ 
 
 PVector pursuit(PVector target){
   PVector targetVel = PVector.sub(target,pastTarget);
   PVector distance = PVector.sub(target,position);
   targetVel.normalize();
   targetVel.mult(distance.mag()*0.5);
   targetVel.add(target);
   
   PVector force = arrive(targetVel);
   pastTarget = target.copy();
   return force;
 }
 
 /*
 Evasion
 */ 
 
  PVector evasion(PVector target){
   PVector targetVel = PVector.sub(target,pastTarget);
   PVector distance = PVector.sub(target,position);
   targetVel.normalize();
   targetVel.mult(distance.mag()*0.5);
   targetVel.add(target);
   
   PVector force = fleeStop(targetVel);
   pastTarget = target.copy();
   
   return force;
 }
 
 
 /*
 Follow flowfield on future position
 */ 
 
 PVector followForward(FlowField field){
     futPosition = velocity.copy();
     futPosition.normalize();
     futPosition.mult(r*4);
     futPosition.add(position);
     PVector desired = field.lookup(futPosition);
     desired.mult(maxSpeed);
     
     return steer(desired);
 }
 
  /*
 Follow flowfield on current position
 */
 
 PVector follow(FlowField field){
     PVector desired = field.lookup(position);
     desired.mult(maxSpeed);
     
     return steer(desired);
 }
 
 /*
 Group Behaviours: Separate
 It includes a Field of view limitation
 */
 
 PVector separate(ArrayList<Agent> others){
   PVector sum = new PVector();
   int count = 0;
   
   for (Agent other : others){
     
     float d = PVector.dist(position, other.position);
     PVector dif = PVector.sub(other.position,position);
     boolean isInView = false;
     if (d>0 ){
    
     float a = velocity.heading2D();
     float da = dif.heading2D();
     
     isInView =  (abs(a-da) < fov/2);
     
     
     }
     if (isInView && d < 200){
        //other.c = color(255,0,0); 
     }
     
     if (d > 0 && d < desiredSeparation && isInView){
       PVector diff = PVector.sub(position,other.position);
       
       diff.normalize();
       sum.add(diff);
       count++;
     }
   }
   
   if (count > 0){
     sum.div(count); 
     sum.setMag(maxSpeed);
     return steer(sum);
   }
   return new PVector(0,0);
 }
 
 
  /*
 Group Behaviours: Align
 */
 
 PVector align(ArrayList<Agent> agents){
   float neighbordist = 50;
   PVector sum = new PVector(0,0);
   int count = 0;
   
   for (Agent other : agents){
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)){
        sum.add(other.velocity);
        count++;
      }
   }
   
   if (count > 0){
     sum.div(count);
     sum.normalize();
     sum.mult(maxSpeed);
     return steer(sum);
   }else{
     return new PVector(0,0); 
   }
 }
 
  /*
 Group Behaviours: Cohesion
 */
 
 PVector cohesion(ArrayList<Agent> agents){
   float neighbordist = 50;
   PVector sum = new PVector(0,0);
   int count = 0;
   
   for (Agent other : agents){
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)){
        sum.add(other.position);
        count++;
      }
   }
   
   if (count > 0){
     sum.div(count);
    
     return arrive(sum);
   }else{
     return new PVector(0,0); 
   }
 }
 
  /*
 Group Behaviours: flock
 It unites and weight each behaviours
 */
 
 void flock(ArrayList<Agent> agents){
   PVector sep = separate(agents);
   PVector ali = align(agents);
   PVector coh = cohesion(agents);
   
   sep.mult(1.5);
   ali.mult(0.6);
   coh.mult(0.5);
   applyForce(sep);
   applyForce(ali);
   applyForce(coh);
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