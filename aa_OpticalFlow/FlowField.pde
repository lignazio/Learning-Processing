class FlowField{
   
  PVector[][] field;
  
  int cols,rows;
  int resolution;
  
  float step = 0.1;
  float dt = 0;
  
  public FlowField(int _r){
     resolution = _r;
     
     cols = width/resolution;
     rows = height/resolution;
     
     field = new PVector[cols][rows];
     
     initField();
  }
  
  void initField(){
     float xoff = 0;
     for (int x = 0; x < cols; x++){
        float yoff = 0;
        for (int y = 0; y < rows; y++){
          
            float angle = map(noise(xoff,yoff,dt),0,1,0,TWO_PI);
            field[x][y] = new PVector(cos(angle),sin(angle));
            
            yoff += step;
          
        }
        xoff += step;
     }
     dt+=step/10;
  }
  
  void update(){
     initField(); 
  }
  
  void display(){
     stroke(100);
     
     for (int x = 0; x < cols; x++){
        for (int y = 0; y < rows; y++){
          drawVector(field[x][y],x*resolution,y*resolution,resolution-2);
        }   
     }
     
  }
  
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    //float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    //stroke(0,100);
    // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }
  
  PVector lookup(PVector lookup){
     int column = int(constrain(lookup.x/resolution,0,cols-1));
     int row = int(constrain(lookup.y/resolution,0,rows-1));
     return field[column][row].copy();
  }
  
}