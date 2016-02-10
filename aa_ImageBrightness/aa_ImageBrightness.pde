/*
Autonomous Agent on flowfield
The flowfield vectors orientation is based 
on the brightness of the webcam capture
*/

import gab.opencv.*;
import processing.video.*;

Capture video;

ArrayList<Agent> agents;

FlowField field;
int totAgents = 1000;

boolean debug ;

void setup(){
  size(1280,720,P2D);
  //there is a bug with the camera and the P2D render
  //if it doesn't work, remove P2D
  
  video = new Capture(this,160,90);
  video.start();
  
  agents = new ArrayList<Agent>();
  for (int i = 0; i < totAgents; i++){
    agents.add(new Agent(new PVector(random(width),random(height)),random(3,5),random(0.1,0.5)));
  }
  
  field = new FlowField(8);
}


void draw(){
  if (video.available()){
      background(0,0,30);
      video.read();
      
      if (debug){
        pushMatrix();
        scale(-1,1);
        image(video, -width, 0,width,height);
        popMatrix();
        video.loadPixels();
      }
      
     
      for (int x = 0; x < field.cols; x++){
        for (int y = 0; y < field.rows; y++){
         int loc = (video.width - x - 1) + y*video.width;
         color c = video.pixels[loc];
         float angle = map(brightness(c),0,255,-PI,PI);
         field.field[x][y] = new PVector(cos(angle),sin(angle));
          
        }
       }
       
       
        //field.update();
    if (debug) field.display();
    
    for (Agent e : agents){
    
      e.follow(field);
      if (debug) e.displayTarget();
      e.run();
    }   
  }  
}

void keyPressed(){
   if (key=='d'){
      debug = !debug; 
   }
}