import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Capture video;

ArrayList<Agent> agents;

Agent a,b,c,d,e;

FlowField field;

int totAgents = 200;

boolean debug ;

void setup(){
  size(1280,720,P2D);
  video = new Capture(this,160,90);
  opencv = new OpenCV(this,160,90);
  video.start();
  
  agents = new ArrayList<Agent>();
  for (int i = 0; i < totAgents; i++){
    agents.add(new Agent(new PVector(random(width),random(height)),random(3,5),random(0.1,0.5)));
  }
  
  field = new FlowField(8);
}


void draw(){
  //background(0,0,30);
  fill(0,10);
  rect(0,0,width,height);
  if (video.available()){
      
      video.read();
      opencv.loadImage(video);
      opencv.calculateOpticalFlow();
      
      for (int x = 0; x < field.cols; x++){
        for (int y = 0; y < field.rows; y++){
          PVector flow = opencv.getFlowAt(160-x-1,y);
          if (field.field[x][y].mag() < flow.mag()){
            flow.x *= -1;
            field.field[x][y] = flow;
          }
          field.field[x][y].mult(0.98);
        }
       }
   
     }
    
        
       //field.update();
    if (debug) field.display();
    
    for (Agent e : agents){
      
      e.follow(field);
      e.separate(agents);
      //if (debug) e.displayTarget();
      e.run();
    
    }
    
}



void keyPressed(){
   if (key=='d'){
      debug = !debug; 
   }
}