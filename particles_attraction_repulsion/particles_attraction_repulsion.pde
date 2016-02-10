ArrayList<Particle> particles;

void setup(){
   size(1280,720);
   particles = new ArrayList<Particle>();
}

void draw(){
  background(20,10,50);
   for (Particle p : particles){
       p.applyBehaviors(particles);
       p.update();
       p.display();
   }
}

void mousePressed(){
   particles.add(new Particle(mouseX,mouseY)); 
}