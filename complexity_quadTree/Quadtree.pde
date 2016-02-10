class Quadtree {
  private int maxObjects = 10;
  private int maxLevels = 5;
  
  private int level;
  private ArrayList<Particle> objects;
  private Rectangle bounds;
  private Quadtree[] nodes;
  
  public Quadtree(int pLevel, Rectangle pBounds){
    level = pLevel;
    objects = new ArrayList<Particle>();
    bounds = pBounds;
    nodes = new Quadtree[4];
  }
  
  void clear() {
    if (objects.size() > 0){
       objects.clear();
    }
     for (int i = 0; i < nodes.length; i++) {
       if (nodes[i] != null) {
         nodes[i].clear();
         nodes[i] = null;
       }
     }
   }
   
   void split() {
     int subWidth = (int)(bounds.getWidth() / 2);
     int subHeight = (int)(bounds.getHeight() / 2);
     int x = (int)bounds.getX();
     int y = (int)bounds.getY();
 
     nodes[0] = new Quadtree(level+1, new Rectangle(x + subWidth, y, subWidth, subHeight));
     nodes[1] = new Quadtree(level+1, new Rectangle(x, y, subWidth, subHeight));
     nodes[2] = new Quadtree(level+1, new Rectangle(x, y + subHeight, subWidth, subHeight));
     nodes[3] = new Quadtree(level+1, new Rectangle(x + subWidth, y + subHeight, subWidth, subHeight));
   }
 
 
 
   private int getIndex(Particle pParticle) {
   int index = -1;
   double verticalMidpoint = bounds.getX() + (bounds.getWidth() / 2);
   double horizontalMidpoint = bounds.getY() + (bounds.getHeight() / 2);
 
   // Object can completely fit within the top quadrants
   boolean topQuadrant = (pParticle.location.y  < horizontalMidpoint);
   // Object can completely fit within the bottom quadrants
   boolean bottomQuadrant = (pParticle.location.y >= horizontalMidpoint);
 
   // Object can completely fit within the left quadrants
   if (pParticle.location.x < verticalMidpoint) {
      if (topQuadrant) {
        index = 1;
      }
      else if (bottomQuadrant) {
        index = 2;
      }
    }
    // Object can completely fit within the right quadrants
    else if (pParticle.location.x >= verticalMidpoint) {
     if (topQuadrant) {
       index = 0;
     }
     else if (bottomQuadrant) {
       index = 3;
     }
   }
 
   return index;
 }
 
  /*
 * Insert the object into the quadtree. If the node
 * exceeds the capacity, it will split and add all
 * objects to their corresponding nodes.
 */
 void insert(Particle pParticle) {
   if (nodes[0] != null) {
     int index = getIndex(pParticle);
 
     if (index != -1) {
       nodes[index].insert(pParticle);
 
       return;
     }
   }
 
   objects.add(pParticle);
 
   if (objects.size() > maxObjects && level < maxLevels) {
      if (nodes[0] == null) { 
         split(); 
      }
 
     int i = 0;
     while (i < objects.size()) {
       int index = getIndex((Particle)objects.get(i));
       if (index != -1) {
         nodes[index].insert((Particle)objects.remove(i));
       }
       else {
         i++;
       }
     }
   }
 }
 
 
  public List retrieve(List returnObjects, Particle p) {
   int index = getIndex(p);
   if (index != -1 && nodes[0] != null) {
     nodes[index].retrieve(returnObjects, p);
   }
 
   returnObjects.addAll(objects);
 
   return returnObjects;
 }
}