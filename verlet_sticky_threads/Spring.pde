class Spring extends VerletSpring{
  color c;
  public Spring(Particle pa, Particle pb,float lng, float str){
     super (pa,pb,lng,str);
     c = color(255);
  }
 
 void setColor( color col){
    c = col; 
 }
 
  void display(){
    noFill();
    stroke(c,180);
    line(a.x,a.y,a.z,b.x,b.y,b.z);
  }
  
}