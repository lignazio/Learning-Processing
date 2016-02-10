class Grid{
   ArrayList[] grid;
   int cellWidth;
   int cellHeight;
   
   int rows,cols;
   
   public Grid(int _rows, int _cols){
      grid = new ArrayList[rows*cols];
      
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
     
      int index = getParticlePosition(p);   
      objects.addAll(grid[index]);
      
      if (grid[index-1] != null) objects.addAll(grid[index-1]);
      if (grid[index+1] != null) objects.addAll(grid[index+1]);
      
      if (grid[index-rows] != null) objects.addAll(grid[index-rows]);
      if (grid[index-rows-1] != null) objects.addAll(grid[index-rows-1]);
      if (grid[index-rows+1] != null) objects.addAll(grid[index-rows+1]);
      
      if (grid[index+rows] != null) objects.addAll(grid[index+rows]);
      if (grid[index+rows-1] != null) objects.addAll(grid[index+rows-1]);
      if (grid[index+rows+1] != null) objects.addAll(grid[index+rows+1]);
      
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
  
}