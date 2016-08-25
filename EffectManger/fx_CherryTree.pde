public class CherryTree implements IEffect {
  ISource source;
  float cherryDim = 4;
  float baseDim = 150;
  float minDim = 5;
  float scaleDim = 0.6;
  float angleMin = 0.25;
  float angleMax = 1;
  float angleScale = 0.7;

  float angle = 0.25;
  
  public CherryTree() {
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "CherryTree";
  }
  
  public void activate() {
  }
  
  public void draw() {
    PVector r = source.getPosition(RIGHT_HAND);
    PVector l = source.getPosition(LEFT_HAND);
    
    angle = min(map(r.dist(l), 0, width * angleScale, angleMin, angleMax), angleMax);
   
    background(0);
    stroke(255);
    strokeWeight(1);
    translate(width/2, height);
    make(baseDim, 0, 0);
   
    translate(-width/4, 0);
    make(baseDim / 3, 0, 1);
   
    translate(width/2, 0);
    make(baseDim / 3, 0, 1);
  }

  void make(float dim, float a, int iter) {
    pushMatrix();
    rotate(a);
   
    strokeWeight(map(dim, 0, baseDim, 1, 10));
   
    float r = 0;//map(iter, 0, log(baseDim/scaleDim), 100, 0);
    float g = map(iter, 0, log(baseDim/scaleDim), 55, 255);
    float b = 0;
   
    stroke(r, g, b);
    line(0, 0, 0, -dim);
  
    translate(0, -dim);
    if(dim > minDim) {
      make(dim * scaleDim, angle, iter + 1);
      make(dim * scaleDim, -angle, iter + 1);
    } else {
      float cherry = map(angle, angleMin, angleMax, -1, 1);
      if(cherry > 0) {
        noStroke();
        fill(cherry * 255, 0, 0);
        ellipse(0, 0, cherry * cherryDim, cherry * cherryDim);
      }
    }
    
    popMatrix();
  }
}
