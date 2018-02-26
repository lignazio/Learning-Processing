import controlP5.*;

ControlP5 cp5;
CallbackListener cb;
FlowField f;
ArrayList<Agent> agents;
float noiseScale = 1;
float noiseStrength = TWO_PI;
int totAgents = 45000;
PImage palette;
float minSpeed = 2;
float maxSpeed = 5;
float minForce = 0.5;
float maxForce = 5;
float bgOpacity = 10;
float pOpacity = 50;

boolean drawGui = false;

void setup(){
  size(1280,720,P2D);
  pixelDensity(2);
  f = new FlowField(2);
  agents = new ArrayList<Agent>();
  
  palette = loadImage("palette.jpg");
  palette.loadPixels();
  
  cb = new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.RELEASED):
         for (Agent a : agents) {
            a.updateData();   
          }
        break;

      }
    }
  };

  for (int i = 0; i < totAgents; i++) {
    PVector pos = new PVector (random(width),random(height));
    Agent a = new Agent(pos);
    a.col = palette.get(int(pos.x),int(pos.y));
      agents.add(a);
    }
    
   background(0);
   cp5 = new ControlP5(this);
  
  cp5.setColorForeground(0xffcccccc);
  cp5.setColorBackground(0xff111111);
  cp5.setColorActive(0xff666666);
  


  
  cp5.begin(100,50);
  //cp5.addSlider("noiseStrength",1,100).linebreak();
  //cp5.addSlider("noiseScale",1,1000).linebreak();
  cp5.addSlider("minSpeed",0,5).linebreak();
  cp5.addSlider("maxSpeed",1,10).linebreak();
  cp5.addSlider("minForce",0,5).linebreak();
  cp5.addSlider("maxForce",1,10).linebreak();
  cp5.addSlider("bgOpacity",0,255).linebreak();
  cp5.addSlider("pOpacity",0,255).linebreak();
  cp5.addBang("toggle")
     .setSize(50,10)
     .setCaptionLabel("reset field");
  cp5.end();
  
   // add the above callback to controlP5
  cp5.addCallback(cb);
  cp5.setAutoDraw(false);
  //blendMode(SCREEN);
}

void draw(){
  //background(0);
  noStroke();
  fill(0,bgOpacity);
  rect(0,0,width,height);
  //f.update();
 //f.display();
  //blendMode(SCREEN);
  for (Agent v : agents) {
    v.futureLocation();
    v.follow(f);
     //v.futureLocation();
    v.deposit(f);
    //v.wander();
    v.run();
  }
  
  blendMode(NORMAL);
  if (drawGui) cp5.draw();
}

void toggle(){
   f.init(); 
}


void keyPressed(){
  if (key == 'g') drawGui = !drawGui;
}

 