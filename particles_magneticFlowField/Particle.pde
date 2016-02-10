class Particle{
   PVector position, velocity, acceleration;
   float maxSpeed, maxForce;
   
   float radius, mass,angle;
   int lifeSpan = floor(random(50,100));
   
   public Particle(PVector pos, float maxspeed, float maxforce){
     position = new PVector (pos.x,pos.y);
     velocity = new PVector(0,0);
     acceleration = new PVector(0,0);
     
     maxSpeed = maxspeed;
     maxForce = maxforce;
     
     mass = 1.0;
     radius = 1.0;  
   }
   
   void update(){
     velocity.add(acceleration);
     position.add(velocity);
     velocity.limit(maxSpeed);
     acceleration.mult(0);
     angle = velocity.heading();  
     lifeSpan--;
   }
   
   void display(PGraphics l){
     
     l.pushMatrix();
     l.translate(position.x,position.y);
     l.rotate(angle);
     l.line(0,0,velocity.mag()*2,0);
     
     l.popMatrix();
   }
   
   void applyForce(PVector force){
     PVector f = force.copy(); 
     f.div(mass);
     acceleration.add(f);
   }
   
   void follow(Field field){
     PVector desired = field.lookup(position);
     desired.mult(maxSpeed);
     
     PVector steer = PVector.sub(desired,velocity);
     steer.limit(maxForce);
     applyForce(steer);
   }
   
   void run(PGraphics l){
     update();
     //borders();
     display(l);
   }
   
   boolean isDead(){
    if (lifeSpan < 0) {
      return true;
    } else {
      return false;
    }
  }
   
   // Wraparound
   void borders() {
      if (position.x < - radius) position.x = width + radius;
      if (position.y < - radius) position.y = height + radius;
      if (position.x > width + radius) position.x = - radius;
      if (position.y > height + radius) position.y = - radius;
   }
   
}