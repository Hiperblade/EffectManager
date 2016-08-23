public class Rotation3D implements IEffect {
  ISource source;
  float SOGLIA = 2500;
  float SCALE = 0.5;

  // Angle for rotation
  float a = 0;
  // We'll use a lookup table so that we don't have to repeat the math over and over
  float[] depthLookUp = new float[2048];

  public Rotation3D() {
    // Lookup table for all possible depth values (0 - 2047)
    for (int i = 0; i < depthLookUp.length; i++) {
      depthLookUp[i] = rawDepthToMeters(i);
    }
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "Rotation3D";
  }
  
  public void activate() {
  }
  
  public void draw() {
    PVector[] depth = source.getRawDepth();

    // Translate and rotate
    translate(width / 2, height / 2, -50);
    rotateY(a);

    background(0);

    //DEBUG
    //noFill(); rect(-width / 2, -height / 2, width, height);
    
    //strokeWeight(1 + getStroke());
    strokeWeight(1);
    
    float coloreR = 255;
    float coloreG = 200 - 200 * getStroke();
    float coloreB = 200 - 200 * getStroke();
    
    int skip = 4;
    for (int x = 0; x < source.getWidth(); x += skip) {
      for (int y = 0; y < source.getHeight(); y += skip) {
        int offset = x + y * source.getWidth();
        PVector v = depth[offset];
  
        stroke(0);
        if(v.z > 0 && v.z < SOGLIA )
        {
          stroke(coloreR, coloreG, coloreB);
        }
        
        pushMatrix();
        float factor = SOGLIA / 2 * SCALE;
        v.mult(SCALE);
        point(-v.x, -v.y, factor - v.z);
        popMatrix();
      }
    }
  
    // Rotate
    a += 0.012f;
  }
  
  // These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
  float rawDepthToMeters(int depthValue) {
    if (depthValue < depthLookUp.length - 1) {
      return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
    }
    return 0.0f;
  }
  
  // Only needed to make sense of the ouput depth values from the kinect
  PVector depthToWorld(int x, int y, int depthValue) {
    final double fx_d = 1.0 / 5.9421434211923247e+02;
    final double fy_d = 1.0 / 5.9104053696870778e+02;
    final double cx_d = 3.3930780975300314e+02;
    final double cy_d = 2.4273913761751615e+02;
  
    // Drawing the result vector to give each point its three-dimensional space
    PVector result = new PVector();
    double depth = 0.0f;
    //if (depthValue < depthLookUp.length) {
      depth = depthLookUp[depthValue]; //rawDepthToMeters(depthValue);
    //}
    result.x = (float)((x - cx_d) * depth * fx_d);
    result.y = (float)((y - cy_d) * depth * fy_d);
    result.z = (float)(depth);
    return result;
  }
  
  float getStroke()
  {
    float[] f = source.getSoundData().getValues();
    float max = 0;
    for ( int i = 0; i < 8; i++)
    {
      if( max < f[i] )
      {
        max = f[i];
      }
    }
    
    //println(max);
    return map(max, 0, 0.1, 0, 1);
  }
}
