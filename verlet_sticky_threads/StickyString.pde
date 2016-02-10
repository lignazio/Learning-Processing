class StickyString {
  
  float totalLength;
  int numPoints;
  float strength;
  color c = color (100+random(150),250,250,150);
  
  ArrayList<Particle> particles;
  
  Particle first,last;
  
  public StickyString(float l, int n, float s){
    particles = new ArrayList<Particle>();
    
    totalLength = l;
    numPoints = n;
    strength = s;
    
    float len = totalLength / numPoints;
    
    for (int i=0; i < numPoints; i++){
       
       Particle particle = new Particle(width/2,i*len,0);
       
       world.addParticle(particle);
       particles.add(particle);
       
       if (i != 0){
          Particle previous = particles.get(i-1);
          VerletSpring spring = new VerletSpring(particle,previous,len,strength);
          world.addSpring(spring);
       }
    }
    
    first = particles.get(0);
    first.lock();
    
    last = particles.get(numPoints-1);
  }
  
  void setFirst(Vec3D loc){
    first.lock();
    first.set(loc);
  }
  
  void setLast(Vec3D loc){
    last.lock();
    last.set(loc);
  }
  
  
  void display(){
    stroke(c);
    noFill();
  
     beginShape();
     for (Particle p : particles){
        vertex (p.x,p.y,p.z); 
     }
     endShape();
     
     first.display();
     last.display();
  }
  
}