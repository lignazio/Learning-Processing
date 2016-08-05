//REACTION DIFFUSION ALGORITHM, GRAY-SCOTT MODEL 

// 'r' to clear the screen
// 'k' to pause/restart the simulation
// 's' to save an image
// 'h' to show/hide the GUI


import controlP5.*;

PGraphics canvas;
PShader grayscott,render;
ControlP5 cp5;
ColorPicker cpa,cpb;

PImage img;

PShader shader;

boolean effect = true;
boolean hideGUI = false;

float dA = 1.0;
float dB = 0.5;
float f = 0.0545;
float k = 0.062;
float dt = 1.0;
int iterations = 1;

void setup(){
  size(1280,720,P2D);
  cp5 = new ControlP5(this);  
  grayscott = loadShader("grayscott.glsl");
  render = loadShader("render.glsl");
  canvas = createGraphics(1280, 720, P2D);
  canvas.beginDraw();
  canvas.background(255,0,0);
  canvas.stroke(200);
  canvas.strokeWeight(15);
  canvas.endDraw();
  
  setGUI();
          
  render.set("ca",new PVector(0,0,0));
  render.set("cb",new PVector(1.0,1.0,1.0));
}

void draw(){
  grayscott.set("f",f);
  grayscott.set("k",k);
  grayscott.set("dA",dA);
  grayscott.set("dB",dB);
  grayscott.set("dt",dt);
  
  
  canvas.beginDraw();
    if (effect){
      for (int i = 0; i < iterations; i++){
         canvas.filter(grayscott);
      }
    }
      
    if (mousePressed){
      canvas.line(pmouseX,pmouseY,mouseX,mouseY);
    }
    
    canvas.endDraw(); 
   
  image(canvas, 0, 0, width, height);
  filter(render);
}

void keyPressed(){
  if (key == 'r'){
    canvas.beginDraw();
    canvas.fill(255,0,0);
    canvas.noStroke();
    canvas.rect(0,0,width,height);
    canvas.stroke(0,255,0);
    canvas.endDraw(); 
  }
  
  if (key == 'k'){
    effect = !effect;
  }
  
  if (key == 's'){
    saveFrame("rda-###.png");
  }
  
  if (key == 'h'){
    hideGUI = !hideGUI;
    if (hideGUI){cp5.hide();} else {cp5.show();};
  }
}

void setGUI(){
  
  cp5.addSlider("dA", 0.00, 2.00, 1.00, 10, 10, 100, 14)
  .setColorValue(color(255)).setColorActive(color(155)).setColorForeground(color(155)).setColorLabel(color(50)).setColorBackground(color(50));
  cp5.addSlider("dB", 0.00, 2.00, 0.50, 10, 30, 100, 14)
  .setColorValue(color(255)).setColorActive(color(155)).setColorForeground(color(155)).setColorLabel(color(50)).setColorBackground(color(50));
  cp5.addSlider("f", 0.00, .20, 0.0540, 10, 50, 100, 14)
  .setColorValue(color(255)).setColorActive(color(155)).setColorForeground(color(155)).setColorLabel(color(50)).setColorBackground(color(50));
  cp5.addSlider("k", 0.00, .20, 0.0620, 10, 70, 100, 14)
  .setColorValue(color(255)).setColorActive(color(155)).setColorForeground(color(155)).setColorLabel(color(50)).setColorBackground(color(50));
  cp5.addSlider("dt", 0.0, 2.0, 1.0, 10, 90, 100, 14)
  .setColorValue(color(255)).setColorActive(color(155)).setColorForeground(color(155)).setColorLabel(color(50)).setColorBackground(color(50));
  cp5.addSlider("iterations", 1, 10, 5, 10, 110, 100, 14)
  .setColorValue(color(255)).setColorActive(color(155)).setColorForeground(color(155)).setColorLabel(color(50)).setColorBackground(color(50));
  
  cpa = cp5.addColorPicker("pickera")
          .setPosition(10, 140)
          .setColorValue(color(0, 0, 0, 0));
  cpb = cp5.addColorPicker("pickerb")
          .setPosition(10, 200)
          .setColorValue(color(255, 255, 255, 0));
          
}

public void controlEvent(ControlEvent c) {
  if(c.isFrom(cpa)) {
    float r = c.getArrayValue(0)/255;
    float g = c.getArrayValue(1)/255;
    float b = c.getArrayValue(2)/255;
    render.set("ca",new PVector(r,g,b));
    
    println("event \tred:"+r+"\tgreen:"+g+"\tblue:"+b);
  }
  if(c.isFrom(cpb)) {
    float r = c.getArrayValue(0)/255;
    float g = c.getArrayValue(1)/255;
    float b = c.getArrayValue(2)/255;
    render.set("cb",new PVector(r,g,b));

    println("event \tred:"+r+"\tgreen:"+g+"\tblue:"+b);
  }
}