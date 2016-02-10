/*
Autonomous Agents Behaviours
see: http://www.red3d.com/cwr/steer/
*/
ArrayList<Agent> agents;

Agent a,b,c,d,e,f;

FlowField field;

boolean debug ;

void setup(){
  size(1280,720,P2D);
  agents = new ArrayList<Agent>();
  field = new FlowField(16);
  
  
  a = new Agent(new PVector(width/2,height/2),4,4);
  
  b = new Agent(new PVector(width/2,height/2),4,4);
  b.c = color(255,0,0);
  
  c = new Agent(new PVector(width/2,height/2),4,4);
  c.c = color(0,255,0);
  
  d = new Agent(new PVector(width/2,height/2),4,4);
  d.c = color(0,0,255);
  
  e = new Agent(new PVector(width/2,height/2),4,0.5);
  e.c = color(255,0,255);
  
  f = new Agent(new PVector(width/2,height/2),4,0.5);
  f.c = color(0,255,255);
  
  for (int i = 0; i < 200; i++){
    Agent g = new Agent(new PVector(random(width),random(height)),4,0.5);
    g.c = color(255,255,0);
    g.r = 2;
    
    agents.add(g);
  }
}


void draw(){
  background(0,0,30);
  PVector mouseTarget = new PVector(mouseX,mouseY);
   
    a.applyForce(a.arrive(mouseTarget));
    a.run(); 
    
    b.applyForce(b.pursuit(mouseTarget));
    b.run();
    
    c.applyForce(c.fleeStop(mouseTarget));
    c.run();
    
    d.applyForce(d.evasion(mouseTarget));
    d.run();
    
    
    field.update();
    if (debug) field.display();
    
    e.applyForce(e.followForward(field));
    //if (debug) e.displayTarget();
    e.run();
    
    f.applyForce(f.follow(field));
    f.run();
    
    for (Agent g : agents){
     PVector seek = g.arrive(mouseTarget);
     PVector follow = g.follow(field);
     g.flock(agents);
     seek.mult(0.7);
     follow.mult(0.5);
     //g.applyForce(seek);
     g.applyForce(follow);
     g.run(); 
    }
    
}



void keyPressed(){
   if (key=='d'){
      debug = !debug; 
   }
}