class Agent{
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector futVec,futLoc,prevLoc;
  
  float maxspeed;
  float maxforce;

  float mass;
  float angle;
  float r;
  
  float wanderRadius = 20.0;
  float dt = 0+random(500);

  
  ArrayList<PVector> tail;
  int tLength = 5;
  int tStep = 1;
  int tCount = 0;
  float rndValue = random(1.0);
  color col = 255;
  
  public Agent(PVector pos, float ms, float mf){
    location = new PVector(pos.x, pos.y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    tail = new ArrayList<PVector>();
    
    mass = 1;
    r = 4.0;
    maxspeed = ms;
    maxforce = mf;
    angle = 0;
  }
  public Agent(PVector pos){
    location = new PVector(pos.x, pos.y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    tail = new ArrayList<PVector>();
    
    mass = 1;
    r = 4.0;
    maxspeed = minSpeed + rndValue*(maxSpeed-minSpeed);
    maxforce = minForce + rndValue*(maxForce-minForce);
    angle = 0;
  }
  
  void updateData(){
    maxspeed = minSpeed + rndValue*(maxSpeed-minSpeed);
    maxforce = minForce + rndValue*(maxForce-minForce); 
  }

  void update(){
    prevLoc = location.copy();
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(maxspeed);
    acceleration.mult(0);
    angle = velocity.heading();
  }  

  void display(){
    stroke(col,pOpacity);
    //pushMatrix();
    //translate(location.x, location.y);
    //rotate(angle);
    //rectMode(CENTER);
   if (prevLoc.dist(location) < 30) line(prevLoc.x,prevLoc.y,location.x,location.y);
    //popMatrix();
  }

  void applyForce(PVector force){
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }


  void futureLocation() {

    futVec = velocity.copy();
    futVec.normalize();
    futVec.mult(2.0);
    futLoc = futVec.add(location);
    
  }

  void follow(FlowField flow){
    PVector desired = flow.lookup(futLoc);
    //desired.normalize();
    desired.mult(maxspeed);

    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);

  }

   void run() {
      update();
      borders();
      display();
      //drawTail();
   }

  void seek(PVector target){
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(maxspeed);
    
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
 void turn(PVector target){
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    
    
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
   void deposit(FlowField flow){
    flow.depositPher(location, velocity);
  }
  
  void wander(){
     dt += 0.2;
     PVector futurePos = velocity.copy();
     futurePos.add(location);
     
  
     float angleWander = velocity.heading() + map(noise(dt),0,1,-0.4,0.4);
     PVector wanderPos = new PVector(futurePos.x + cos(angleWander)*wanderRadius, futurePos.y + sin(angleWander)*wanderRadius);
     
     seek(wanderPos);
     /*
     noFill();
     stroke(100);
     ellipse(futurePos.x,futurePos.y,wanderRadius*2,wanderRadius*2);
     noStroke();
     fill(255,0,0);
     ellipse(wanderPos.x,wanderPos.y,4,4);
     */
  }
  
  void drawTail(){
     tCount++;
     
     if (tCount > tStep){
        tail.add(location.copy());
        tCount = 0;
     }
     
     if (tail.size() > tLength){
        tail.remove(0);
     }
     
     for (int i = 1; i < tail.size(); i++){
        PVector a = tail.get(i-1);
        PVector b = tail.get(i);
        
        if (a.dist(b) < 30){
           stroke(col,map(i, 0, tail.size(),0, 200));
           line(a.x,a.y,b.x,b.y);
        }
     }
  }

  // Wraparound
    void borders() {
      if (location.x < -r) location.x = width+r;
      if (location.y < -r) location.y = height+r;
      if (location.x > width+r) location.x = -r;
      if (location.y > height+r) location.y = -r;
    }
}