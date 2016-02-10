class Field{
  PVector[][] field;
  ArrayList<Attractor> attractors;
  int cols, rows;
  int resolution;
  boolean noised,rotation = false;
  
  float distance = 50.0;
  float angle = 0;
  float t = 0;
  
  public Field (int r){
     resolution = r;
     cols = width/resolution;
     rows = height/resolution;
     field = new PVector[cols][rows];
     
     initField();
  }
  
  void initField(){
    for (int x = 0; x < cols; ++x){
       for (int y = 0; y < rows; ++y){
         PVector v = new PVector(0,0);
         field[x][y] = v;
       }
    }
  }
  
  void update(){
    float weight = 0;
    t += 0.01;
    float offx = 0;
    float offy = 0;
    initField();
    
    if (attractors.size() > 0){
    for (Attractor a : attractors){
      PVector pos = a.position;
      for (int x = 0; x < cols; ++x){
        offy = 0;
       for (int y = 0; y < rows; ++y){
         PVector force = PVector.sub(pos,new PVector(x*resolution,y*resolution));
         float d = force.mag(); 
         d = constrain(d,1.0,distance);
         float str = (a.strength*50) / (d * d * PI * 4 ); 
         angle = force.heading();
         if (rotation) angle += HALF_PI;
         if (noised)angle += map(noise(offx,offy,t),0,1,-PI/4,PI/4);
         //if (a.strength<0) angle+=PI;
         PVector v = new PVector(cos(angle),sin(angle));
         v.normalize();
         v.mult(str);
         field[x][y].add(v);
         offy+=0.05;
       }
       offx+=0.05;
      }
    }
    }
 
    
    
  }
  
  void display(){
    //background(0);
    stroke(255,0,0,100);
    for (int x = 0; x < cols; ++x){
      for (int y = 0; y < rows; ++y){
        drawVector(field[x][y], x*resolution, y*resolution, resolution -2);
      }
    }
    noStroke();
  }
  
  
  void drawVector(PVector v, float x, float y, float scale){
    PVector vec =v.copy();
    vec.normalize();
    float len = vec.mag()*scale;
    
    pushMatrix();
    translate(x,y);
    rotate(v.heading()); 
    line(0, 0, len, 0);
    popMatrix();
  }
  
  PVector lookup(PVector lookup){
    
     int column = int(constrain(lookup.x/resolution+1,0,cols-1));
     int row = int(constrain(lookup.y/resolution+1,0,rows-1));
     
     int left =constrain(column-1,0,cols);
     int down = constrain(row-1,0,rows);
     
     PVector v = field[column][row].copy();
     v.add(field[left][row].copy());
     v.add(field[column][down].copy());
     v.add(field[left][row].copy());
     v.div(4);
     return v;
  }
 
}