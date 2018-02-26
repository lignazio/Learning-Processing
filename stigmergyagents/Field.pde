class FlowField{
  PVector[][] field;
  int cols, rows;

  int resolution;
  PImage img;
  float angle = 0;
  float t;

  public FlowField(int r){
    resolution = r;
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];

    //INIT
    t = 0;
    init();
  }
  void init(){
    t+=0.01;
    float offx = 0;
    for (int i = 0; i < cols; ++i) {
      float offy = 0;
      for (int j = 0; j < rows; ++j) {
        float angle = noise(offx/noiseScale,offy/noiseScale)*noiseStrength;
        //float angle = map(noise(offx,offy,t),0,1,0,TWO_PI);
        //float angle = map(img.get(int(i*w/cols),int(j*h/rows)),0,255,0,TWO_PI);
        //field[i][j] = new PVector(cos(angle),sin(angle));
        field[i][j] = PVector.random2D();
        offy +=0.1;
      }
      offx +=0.1;
    }
    
  }
  
 
  void depositPher(PVector loc, PVector pheromone){
    int column = int(constrain(loc.x/resolution, 0, cols-1));
    int row = int(constrain(loc.y/resolution, 0, rows-1));
    field[column][row] = pheromone.copy().normalize();
  }
  
  void update(){
    
  }
  void display(){
    


   
    //tint(255, 100);
    //image(img, 0, 0, width, height);
    
    stroke(255, 50);


    for (int i = 0; i < cols; ++i) {
      //line(i*resolution,0,i*resolution,height);
      for (int j = 0; j < rows; ++j) {
        //line(i*resolution,j*resolution,(i+1)*resolution,j*resolution);
        drawVector(field[i][j],i*resolution,j*resolution,resolution-2);
      }
    }
  }

  void drawVector(PVector v,float x, float y, float scayl){
    pushMatrix();
    translate(x, y);
    rotate(v.heading2D());
    float len = v.mag()*scayl;

    line(0,0,len,0);
    popMatrix();
  }

  PVector lookup(PVector lookup){
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }

}