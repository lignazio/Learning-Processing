import toxi.physics.*;
import toxi.physics.behaviors.*;
import toxi.physics.constraints.*;
import toxi.geom.*;
import peasy.*;

PeasyCam cam;

VerletPhysics world;

int numStrings = 60;
int resolution = 40;
int stickyDist = 0;
StickyString[] strings;
ArrayList<Spring> springs;
boolean[][] connections;

void setup(){
  size(1280,720,P3D); 
  pixelDensity(2);
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(1000);
  cam.setMaximumDistance(2000);
  cam.pan(width/2,height/2);
  
  world = new VerletPhysics();
  world.addBehavior(new GravityBehavior(new Vec3D(0,0.1,0)));
  
  strings = new StickyString[numStrings];
  springs = new ArrayList<Spring>();
  connections = new boolean[numStrings*resolution][numStrings*resolution];
  
  for (int i = 0; i < numStrings; i++){
    Vec3D a = new Vec3D(0,sin(random(TWO_PI))*200,cos(random(TWO_PI))*200);
    Vec3D b = new Vec3D(1280,sin(random(TWO_PI))*200,cos(random(TWO_PI))*200);
    float len = a.distanceTo(b);
    StickyString s = new StickyString(len, resolution, 0.5);
    s.setFirst(a);
    s.setLast(b);
    strings[i] = s;   
     
  }
  
   blendMode(ADD);
   
}

void draw(){
  world.update();
  
  background (0,0,50);
  
  for (int i = 0; i < numStrings; i++){
     strings[i].display(); 
  }
  
  
  
  for (Spring sp : springs){
    sp.display();
  }
  
  cam.beginHUD();
  fill(255);
  text ("sticky length: "+stickyDist,50,650);
  text ("n. of connections: "+springs.size(),50,670);
  cam.endHUD();
}


void checkSticky(){
   for (int i = 0; i < numStrings; i++){
      int pa = 0;
      for (Particle p : strings[i].particles){
        
        
         for (int j = 0; j < numStrings; j++){
           int pb = 0;
           if (j != i){
              for (Particle b : strings[j].particles){
                
               
                if (p.distanceTo(b) < stickyDist && !connections[i*resolution+pa][j*resolution+pb] && (!p.connected || !b.connected) ){
                   connections[i*resolution+pa][j*resolution+pb] = true;
                   p.connected = b.connected = true;
                   Spring sp = new Spring(p,b,stickyDist/5,.5);
                   sp.setColor(color(255,150));
                   springs.add(sp); 
                   world.addSpring(sp);
                }
                pb+=1;
              }//particelle interno
           }//if
           
         }//stringhe interno
         pa+=1;
      }//particelle1
   } //stringhe
}//funzione

void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP) {
      ++stickyDist;
      
    } else if (keyCode == DOWN) {
      if (stickyDist > 0) --stickyDist;
    } 
  }
  checkSticky();
  println("sticky distance:",stickyDist);
  println("springs:",springs.size());
}