import controlP5.*;

Field f;
int totParticles = 10000;
Particle[] particles;
ArrayList<Attractor> attractors;
boolean displayField, isDragging = false;
int selected =-1;
int strength = 300;

float distance = 50.0;
PGraphics particlesLayer;
ControlP5 cp5;

void setup(){
  size(1280,720,P2D);
  pixelDensity(2);
  particlesLayer = createGraphics(1280, 720,P2D); 
  particlesLayer.pixelDensity = 2;
  particlesLayer.beginDraw();
  particlesLayer.background(0);
  particlesLayer.endDraw();
  
  cp5 = new ControlP5(this);
  
  cp5.setColorForeground(0xffcccccc);
  cp5.setColorBackground(0xff111111);
  cp5.setColorActive(0xff666666);
  


  
  cp5.begin(100,50);
  cp5.addSlider("strength",0,1000).linebreak();
  cp5.addSlider("distance",0,500).linebreak();
  
  cp5.addToggle("toggle")
     .setSize(50,10)
     .setValue(true)
     .setCaptionLabel("rotation");
  cp5.end();
  
  f = new Field(8);
  attractors = new ArrayList<Attractor>();
  f.attractors = attractors;
  
  particles = new Particle[totParticles];
  for (int i = 0; i < totParticles; ++i){
    particles[i] = new Particle(new PVector(random(width),random(height)), 4, 1);
  }
  
}

void draw(){
  f.distance = distance;
  
  background(0);
  image(particlesLayer,0,0);
  noStroke();
  
  f.update();
  if (displayField) f.display();
  
  //attractorsLayer.beginDraw();
  //attractorsLayer.background(0,0);
  
  for (Attractor a : attractors){
    a.display();
  }
  //attractorsLayer.endDraw();
  
  
  particlesLayer.beginDraw();
  
  particlesLayer.blendMode(BLEND);
  particlesLayer.fill(0,10);
  particlesLayer.rect(0,0,width,height);
  //particlesLayer.stroke(255,30);
  particlesLayer.blendMode(ADD);
  for (int i = 0; i < particles.length; ++i){
   
    Particle p = particles[i];
     particlesLayer.stroke(255,map(p.velocity.mag(),0,p.maxSpeed,5,50));
    //PVector force = new PVector(0,0);
    for (Attractor a : attractors){
      //force.add(a.attract(p));
      PVector dir = PVector.sub(a.position,p.position);
     if (dir.magSq() < 100){
     p.lifeSpan = 0; 
     };
      
      
      //p.applyForce(force);
    }
    if (p.isDead()){
       particles[i] = new Particle(new PVector(random(width),random(height)),10,0.5);
    }
    p.follow(f);
    p.run(particlesLayer);
  }
  particlesLayer.endDraw();
  
  //image(attractorsLayer,0,0);
  //image(particlesLayer,0,0);
}

void keyPressed(){
  if (key == 'd'){
    displayField = !displayField;
  }else if ( key == 'n'){
     f.noised = !f.noised; 
  }else if (key == 'h'){
    cp5.setVisible(!cp5.isVisible());
  }
}

void mousePressed(){
  if (cp5.getWindow().getMouseOverList().size() == 0){
   for (int i=0;i<attractors.size();i++){
     Attractor a = attractors.get(i);
    if (dist(mouseX,mouseY,a.position.x,a.position.y) < 10){
       isDragging = true;
       selected = i;
    }
   }
   if (!isDragging){
   float str = strength;
   if (mouseButton == RIGHT){
     str = -str;
   }
   attractors.add(new Attractor(new PVector(mouseX,mouseY),str));
   }
  }
}

void mouseDragged()
{
  if(selected!=-1){
    attractors.get(selected).position = new PVector(mouseX,mouseY);
  } 
}
 
void mouseReleased()
{
  
  isDragging = false;
  selected=-1;
}

void toggle(boolean b) {
  f.rotation = !b;
  println(b);
  
}