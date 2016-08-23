public class LinesToHands implements IEffect {
  ISource source;
  boolean active = false;
  int n_line = 32;

  public LinesToHands() {
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "LineToHands";
  }
  
  public void activate() {
  }
  
  public void draw() {
    /*
    if( source.getSoundData().getBeat())
    {
      active = !active;
    }
    */
    
    background(0);
    stroke (255);
    if( active )
    {
      stroke(255,0,0);
    } 
    strokeWeight (1);
    
    float[] s = getStroke(n_line);
    PVector r = source.getPosition(RIGHT_HAND);
    PVector l = source.getPosition(LEFT_HAND);
    
    for(int i = 0; i < n_line; i++) {
      if( s[i] > 1) {
        stroke(255);
      } else {
        stroke(255, 0, 0);
      }
      
      strokeWeight(s[i]);
      line(-300 + width + (i * 20), 0, r.x, r.y);
      line(300 - (i * 20), 0, l.x, l.y);
    }
  }
  
  float[] getStroke(int n) {
    float[] val = source.getSoundData().getValues();
    
    float[] ret = new float[n];
    for(int j = 0; j < n; j++) {
      ret[j] = 1 + val[j]; //random(1, 5);
    } 
    return ret;
  }
}
 
