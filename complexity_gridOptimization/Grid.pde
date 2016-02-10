class Grid{
   ArrayList[] grid;
   int cellWidth;
   int cellHeight;
   
   int rows,cols;
   
   public Grid(int _cols, int _rows){
      grid = new ArrayList[_rows*_cols];
      
      rows = _rows;
      cols = _cols;
      
      cellWidth = width/cols;
      cellHeight = height/rows;
   }
   
   void clear(){
      for (int i = 0; i<grid.length; i++){
        grid[i] = null;
      }
   }
   
   int getParticlePosition(Particle p){
     int xpos =  floor(p.location.x/cellWidth);
     int ypos =  floor(p.location.y/cellHeight);
     return (ypos*cols) + xpos;
     
   }
   
   void insert(Particle p){
     int index = getParticlePosition(p);
     
     if (grid[index] == null){
         grid[index] = new ArrayList<Particle>();
     }
     grid[index].add(p);
   }
   
   ArrayList getCell(Particle p){
     int index = getParticlePosition(p);   
     return  grid[index];
   }
   
   ArrayList getNear(Particle p){
     ArrayList objects = new ArrayList<Particle>();
     
      int xpos =  floor(p.location.x/cellWidth);
      int ypos =  floor(p.location.y/cellHeight);  
      
      int xstart = constrain(xpos-1,0,cols);
      int ystart = constrain(ypos-1,0,rows);
      int xend = constrain(xpos+2,0,cols);
      int yend = constrain(ypos+2,0,rows);
      
      for (int x = xstart; x<xend; x++){
        for (int y= ystart; y<yend; y++){
           int index = x + y*cols;
           if (grid[index] != null) objects.addAll(grid[index]);
        }
      }
      
      return objects;
   }
   
   ArrayList getInsideCircle(Particle p, float radius){
     ArrayList<Particle> objects = getNear(p);
     for (int i = objects.size()-1; i>=0; i--){
       Particle tempP = objects.get(i);
       PVector dist = PVector.sub(p.location,tempP.location);
       if (dist.magSq() > radius*radius){
         objects.remove(i);
       }
     }
     
     return objects;
   }
   
   void drawGrid(){
     for (int i = 0; i < cols; i++){
        line (cellWidth*i,0,cellWidth*i,height);
     }
     for (int i = 0; i < rows; i++){
       line (0,i*cellHeight,width,i*cellHeight);
        
     }
   }
  
}