import megamu.mesh.*;
import controlP5.*;

ControlP5 cp5;
controlP5.Toggle c,d,e;
PImage[] images;
PImage image;
int seed,x,y,p;
int particles = 10000;
float power,mvalue,ratio,posx,posy,deltaX,deltaY,tStep;
float startX,startY,endX,endY;
float[][] points;
Delaunay myDelaunay;
float[][] myEdges;
color c1,c2;
boolean re, colorMode,drawDelaunay,lightMode,showGui = true;


void setup(){
  size(1280,720,P2D);
  pixelDensity(2);
  //noLoop();
  power = 1;
  particles = 10000;
  cp5 = new ControlP5(this);
  cp5.addSlider("source")
     .setPosition(50,20)
     .setSize(50,10)
     .setRange(0,6)
     .setNumberOfTickMarks(7)
     ;
  cp5.addSlider("particles").setPosition(50,50).setRange(0,20000);
  cp5.addSlider("power").setPosition(50,80).setRange(0.5,8.0);
   c= cp5.addToggle("toggle")
     .setPosition(50,110)
     .setSize(50,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
  
  d= cp5.addToggle("toggle2")
     .setPosition(50,140)
     .setSize(50,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
  
   e= cp5.addToggle("toggle3")
     .setPosition(50,170)
     .setSize(50,10)
     .setValue(true)
     .setMode(ControlP5.SWITCH);
     
  c.setLabel("Color");
  d.setLabel("Draw Delaunay");
  e.setLabel("Light or Dark");
  images = new PImage[7];
  for (int i=0; i< images.length;i++){
     images[i] = loadImage("source"+i+".jpg");
     images[i].loadPixels();  
  }
  image = images[0];
}


void draw(){
 // println(re);
   
  if (re == true){
   re = false;   
  println(colorMode);
  particles = (int)cp5.getController("particles").getValue();
  power = cp5.getController("power").getValue();
  ratio = min(float(width-50)/(float)image.width,float(height-50)/ (float)image.height);
  posx = (width-image.width*ratio)/2;
  posy = (height-image.height*ratio)/2;
  
  background(0);
  noFill();
  noStroke();
  if(colorMode){
    background(image.get(0,0));
  }
  
  points = new float[particles][2];
  println(image.width,image.height);
  while (particles > 0){
    x = (int)random(image.width);
    y = (int)random(image.height);
    p = x+y*image.width;
    mvalue = map(brightness(image.pixels[p]),0,255,1,0);
   // println(mvalue,value);
   
   
    if(!drawDelaunay){
      fill(255);
    }
    boolean condition;
    if (lightMode){
      condition = random(1.0) < pow(mvalue,power);
    }else{
      condition = random(1.0) < pow(1 - mvalue,power);
    }
   
  
    if(condition){
      particles--;
      points[particles][0] = x;
      points[particles][1] = y;
    
      if(!drawDelaunay){
          if (colorMode){
            fill(image.get(x,y));
        }
         ellipse(posx+x*ratio,posy+y*ratio,2,2); 
      }
    }
  }
 
  if (drawDelaunay){
  myDelaunay = new Delaunay( points );
  myEdges = myDelaunay.getEdges();
  //stroke(0);
  for(int i=0; i<myEdges.length; i++)
  {
    
    startX = posx + myEdges[i][0]* ratio;
    startY = posy + myEdges[i][1]*ratio;
    endX = posx + myEdges[i][2]* ratio;
    endY = posy + myEdges[i][3]* ratio;
    if (colorMode){
      c1 = image.get((int)myEdges[i][0],(int)myEdges[i][1]);
      c2 = image.get((int)myEdges[i][2],(int)myEdges[i][3]);
      gradientLine( startX, startY, endX, endY,c1,c2 );
    }else{
      stroke(250,200);
      
      line(startX, startY, endX, endY);
    }
  }
  }

 // fill(255);
 // text(seed, 10, height-10);
  }
}

void gradientLine(float x1, float y1, float x2, float y2, color a, color b) {
  deltaX = x2-x1;
  deltaY = y2-y1;
  tStep = 1.0/dist(x1, y1, x2, y2);
  for (float t = 0.0; t < 1.0; t += tStep) {
    fill(lerpColor(a, b, t));
    ellipse(x1+t*deltaX,  y1+t*deltaY, 1, 1);
  }
}

void toggle(boolean theFlag) {
  
  if(theFlag==true) {
    colorMode = true;
  } else {
    colorMode = false;
  }
  println("a toggle event.",theFlag);
}

void toggle2(boolean theFlag) {
  
  if(theFlag==true) {
    drawDelaunay = true;
  } else {
    drawDelaunay = false;
  }
  println("a toggle event.",theFlag);
}


void toggle3(boolean theFlag) {
  
  if(theFlag==true) {
    lightMode = true;
  } else {
    lightMode = false;
  }
  println("a toggle event.",theFlag);
}

void source(int i) {
  image = images[i];
 
  println("a toggle event.",i);
}


void mousePressed(){
  println("ciao");
   seed = (int)random(10000);
   randomSeed(seed);
   re = true;
}

void keyPressed(){
  if (key == 'h'){
    showGui = !showGui;
     cp5.setVisible(showGui);  
  }
  if (key == 's'){
    saveFrame(); 
  }
}