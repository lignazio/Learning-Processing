import gab.opencv.*;
import processing.video.*;

Capture video;
ArrayList<Agent> agents;

FlowField field;

int totAgents = 1000;

int numPixels;
int[] backgroundPixels;

boolean debug ;

void setup(){
  size(1280,720);
  video = new Capture(this,160,90);
  video.start();
  
  agents = new ArrayList<Agent>();
  for (int i = 0; i < totAgents; i++){
    agents.add(new Agent(new PVector(random(width),random(height)),random(3,5),random(0.1,0.5)));
  }
  
  field = new FlowField(8);
  
  numPixels = video.width * video.height;
  backgroundPixels = new int[numPixels];
}


void draw(){
  if (video.available()){
      background(0,0,30);
      video.read();
     
      video.loadPixels();
      
     int presenceSum = 0;
      for (int x = 0; x < field.cols; x++){
        for (int y = 0; y < field.rows; y++){
          int loc = (video.width - x - 1) + y*video.width;
          
          color currColor = video.pixels[loc];
          color bkgdColor = backgroundPixels[loc];
          
          // Extract the red, green, and blue components of the current pixel's color
          int currR = (currColor >> 16) & 0xFF;
          int currG = (currColor >> 8) & 0xFF;
          int currB = currColor & 0xFF;
          // Extract the red, green, and blue components of the background pixel's color
          int bkgdR = (bkgdColor >> 16) & 0xFF;
          int bkgdG = (bkgdColor >> 8) & 0xFF;
          int bkgdB = bkgdColor & 0xFF;
          // Compute the difference of the red, green, and blue values
          int diffR = abs(currR - bkgdR);
          int diffG = abs(currG - bkgdG);
          int diffB = abs(currB - bkgdB);
          
          presenceSum = diffR + diffG + diffB;
          
          if (presenceSum < 20){
             video.pixels[loc] = 0;
          }
          
         
         color c = video.pixels[loc];
         float angle = map(brightness(c),0,255,-PI,PI);
         field.field[x][y] = new PVector(cos(angle),sin(angle));
          
        }
       }
       video.updatePixels();
       pushMatrix();
      scale(-1,1);
      image(video, -width, 0,width,height);
      popMatrix();
       
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
   }else{
      
   video.loadPixels();
   arraycopy(video.pixels, backgroundPixels);
   }
}