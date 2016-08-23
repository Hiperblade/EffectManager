public class Rectangle implements IEffect {
  ISource source;
  float MARGIN = 10;
  float SOGLIA = MARGIN / 2;
  PVector previousEdge1 = null;
  PVector previousEdge2 = null;

  public Rectangle() {
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "Rectangle";
  }
  
  public void activate() {
  }
  
  private float stabilize(float v2, float v1, float v0) {
    float gap0 = v1 - v0;
    float gap2 = v1 - v2;

    if((abs(gap0) > SOGLIA) ||
      (((gap0 != 0 && gap2 != 0) && (gap0 / abs(gap0) == gap2 / abs(gap2))))) {
      return v0;
    }
    
    return v1;
  }
  
  public void draw() {
    PVector edge = findEdge();
    if(previousEdge1 == null){
      previousEdge1 = new PVector(edge.x, edge.y, edge.z);
      previousEdge2 = new PVector(edge.x, edge.y, edge.z);
    } else {
      edge.x = stabilize(previousEdge2.x, previousEdge1.x, edge.x);
      edge.y = stabilize(previousEdge2.y, previousEdge1.y, edge.y);
      edge.z = stabilize(previousEdge2.z, previousEdge1.z, edge.z); 
      
      if(edge.dist(previousEdge1) > 0) {
        previousEdge2 = previousEdge1;
        previousEdge1 = edge;
      }
    }
    
    background(0);
    strokeWeight(20);
    stroke(255);
    fill(255);
    rectMode(CORNERS);
    if(source.getUsers().length > 0) {
      rect(edge.x - MARGIN, edge.y - MARGIN, edge.z + MARGIN, height + MARGIN);
      //DEBUG
      //printDebugImage();
    }
  }
  
  private void printDebugImage() {
    color maskColor = color(200, 200, 200);
    color maskBackColor = color(0, 0, 0, 0);
    
    PImage tmp = createImage(source.getWidth(), source.getHeight(), ARGB);
    tmp.loadPixels();
    int[] mask = source.getUserMask();
    for(int x = 0; x < source.getWidth(); x++) {
      for(int y = 0; y < source.getHeight(); y++) {
        int offset = x + y * source.getWidth();
        if(mask[offset] > 0){
          tmp.pixels[offset] = maskColor;
        } else {
          tmp.pixels[offset] = maskBackColor;
        }
      }
    }
    tmp.updatePixels();
    image(tmp, 0, 0);
  }

  private PVector findEdge() {
    float minY = 10000;
    float maxX = 0;
    float minX = 10000;
    
    int[] mask = source.getUserMask();
    for(int x = 0; x < source.getWidth(); x++) {
      for(int y = 0; y < source.getHeight(); y++) {
        int offset = x + y * source.getWidth();
        if(mask[offset] > 0) {
          if(x < minX) {
            minX = x;
          }
          if(x > maxX) {
            maxX = x;
          }
          if(y < minY) {
            minY = y;
          }
        }
      }
    }
    
    return new PVector(minX, minY, maxX);
  }
}
