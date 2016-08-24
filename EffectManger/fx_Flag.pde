public class Flag implements IEffect {
  ISource source;
  float step = 0.01;
  float shift = 0;
  float dim = 100;
  float scale = 8;
  float gain = 1;

  public Flag() {
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "Flag";
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
    translate(width/2, height/2, 0);
    rotateX(10.8);
    scale(0.5);
    
    background(0);
    strokeWeight(2);
    noFill();

    // DEBUG
    //rect(-200,-200,width, height);
  
    for(int x = 0; x < dim; x++)
    {
      for(int y = 0; y < dim; y++)
      {
        stroke(255, 255, 255);
        point((x - (dim / 2)) * scale, (y - (dim / 2)) * scale, - map(noise(shift + x * step, shift + y * step), 0, 1, -1, 1) * dim * gain);
      }
    }
    shift += 0.01;
    
    PVector r = source.getPosition(RIGHT_HAND);
    PVector l = source.getPosition(LEFT_HAND);
    gain = map(r.dist(l), 0, width, 1, 5); 
  }
}
 
