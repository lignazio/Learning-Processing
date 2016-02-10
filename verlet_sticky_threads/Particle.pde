class Particle extends VerletParticle{
  boolean connected=false;
  public Particle(Vec3D loc){
     super(loc); 
  }
  
   public Particle(float _x, float _y, float _z){
     super(_x,_y,_z); 
  }
  
  void display(){
     fill(255);
     noStroke();
     pushMatrix();
     translate(x,y,z);
     sphere(2);
     popMatrix();
  }
  
}