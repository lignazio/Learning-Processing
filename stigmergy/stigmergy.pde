FlowField f;
ArrayList<Agent> agents;

int totAgents = 35000;

void setup(){
  size(1280,720,P2D);
  f = new FlowField(4);
  agents = new ArrayList<Agent>();

  

  for (int i = 0; i < totAgents; i++) {
      agents.add(new Agent(new PVector(random(width), random(height)), random(2, 5), random(.5, 6)));
    }
    
   background(0);
   
}

void draw(){
  
  fill(0,80);
  rect(0,0,width,height);
  //f.update();
 //f.display();
  noStroke();
 blendMode(ADD);
  for (Agent v : agents) {
    v.futureLocation();
    v.follow(f);
     //v.futureLocation();
    v.deposit(f);
    v.wander();
    v.run();
  }
  blendMode(NORMAL);
  filter(BLUR);
  saveFrame("particlesFEW-######.png");
}