class Agent{
  
  PVector position, velocity, acceleration;
  
  float maxSpeed, maxForce;
  
  PVector pastTarget, futPosition;
  
  PVector[] v;
  
  float r = 5.0;
  color c;
  float dist = 50; 
  float fov = radians(90);
  
  float desiredSeparation = r*3;
  
 public Agent(PVector p, float ms, float mf){
   pastTarget = new PVector(0,0,0);
   v = new PVector[5];
   r=5.0;
   c = 255;
   position = p.copy();
   maxSpeed = ms;
   maxForce = mf;
   velocity = PVector.random3D();
   acceleration = new PVector(0,0,0);
   
    v[0] = new PVector(0, -r*2, 0);                                      // top of the pyramid
    v[1] = new PVector(r*cos(HALF_PI), r*2, r*sin(HALF_PI)); // base point 1
    v[2] = new PVector(r*cos(PI), r*2, r*sin(PI));           // base point 2
    v[3] = new PVector(r*cos(1.5*PI), r*2, r*sin(1.5*PI));   // base point 3
    v[4] = new PVector(r*cos(TWO_PI), r*2, r*sin(TWO_PI));   // base point 4
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
  
 PVector steer(PVector desired){
   PVector steer = PVector.sub(desired,velocity);
   steer.limit(maxForce);
   return steer;
 }
 
 
 PVector seek(PVector target){
   PVector desired = PVector.sub(target,position);
   desired.normalize();
   
   desired.mult(maxSpeed);
   return steer(desired);
   
 }
 
 
 
 
 PVector flee(PVector target){
   PVector desired = PVector.sub(target,position);
   desired.normalize();
   
   desired.mult(-maxSpeed);
   
   return steer(desired);
 }
 
 
 
 
 
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
 
 
 
 
 PVector followForward(FlowField field){
     futPosition = velocity.copy();
     futPosition.normalize();
     futPosition.mult(r*4);
     futPosition.add(position);
     PVector desired = field.lookup(futPosition);
     desired.mult(maxSpeed);
     
     return steer(desired);
 }
 
 PVector follow(FlowField field){
     PVector desired = field.lookup(position);
     desired.mult(maxSpeed);
     
     return steer(desired);
 }
 
 
 
 
 
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
        other.c = color(255,0,0); 
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
    PVector linea = velocity.copy();
    linea.normalize();
    float rx = asin(-linea.y)-HALF_PI;
    float ry = atan2(linea.x, linea.z);
    
    
    fill(c);
    noStroke();
    pushMatrix();
    translate(position.x,position.y,position.z);
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
 
 // Wraparound
  void borders() {
    if (position.x < -500-r) position.x = 500+r;
    if (position.y < -500-r) position.y = 500+r;
    if (position.z < -500-r) position.z = 500+r;
    if (position.x > 500+r) position.x = -500-r;
    if (position.y > 500+r) position.y = -500-r;
    if (position.z > 500+r) position.z = -500-r;
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