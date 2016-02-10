class Attractor{
   PVector position;
   float strength;
   float distance;
   float mass = 1;
   
   public Attractor(PVector pos, float s){
      position = pos.copy();
      strength = s;
   }
   
   void display(){
     
     if (strength > 0){
        //stroke(255);
        fill(30);
     }else{
        noStroke();
        fill(255); 
     }
     ellipse(position.x,position.y,10,10);
     noStroke();
   }
   
   
   PVector attract(Particle p) {
    PVector force = PVector.sub(position ,p.position);   // Calculate direction of force
    float d = force.mag();                              // Distance between objects
    d = constrain(d,1.0,10.0);                        // Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize();                                  // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    float str = (strength * mass * p.mass) / (d * d * 4 * PI);      // Calculate gravitional force magnitude
    force.mult(str);                                  // Get force vector --> magnitude * direction
    return force;
  }
  
}