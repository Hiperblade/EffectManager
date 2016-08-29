public class Flag implements IEffect {
  ISource source;
  float step = 0.01;
  float shift = 0;
  float dim = 100;
  float scale = 8;
  float gain = 2;

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
    background(0);
    strokeWeight(2);
    noFill();
    scale(0.5);
    stroke(255, 255, 255);
    
    translate(0, 0, -400);
            
    translate(width, height, 0);
    rotateY(PI / 4);
    // DEBUG
    //rect(-dim * scale, -dim / 2 * scale, dim * scale, dim * scale);

    drawFlag(gain);

    rotateY(-PI / 2 + PI);
    // DEBUG
    //rect(-dim * scale, -dim / 2 * scale, dim * scale, dim * scale);

    drawFlag(-gain);
    
    PVector r = source.getPosition(RIGHT_HAND);
    PVector l = source.getPosition(LEFT_HAND);
    gain = map(r.dist(l), 0, width, 1, 5);
    
    shift += 0.01;
  }
  
  private void drawFlag(float gain){
    for(int x = 0; x < dim; x++)
    {
      for(int y = 0; y < dim; y++)
      {
        point((x - dim) * scale, (y - (dim / 2)) * scale, - map(noise(shift + x * step, shift + y * step), 0, 1, -1, 1) * dim * gain);
      }
    }
  }
}
