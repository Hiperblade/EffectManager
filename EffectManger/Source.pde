import SimpleOpenNI.*;

void onNewUser(SimpleOpenNI curContext, int userId) {
  manager.getSource().onNewUser(userId);
}

public final Integer RIGHT_HAND = 1;
public final Integer LEFT_HAND = 2;
public final Integer HEAD = 3;
  
public interface ISource {
  void update();

  PImage getRGB();
  
  int getWidth();
  int getHeight();
  PVector[] getRawDepth();
  int[] getUserMask();

  int[] getUsers();
  PVector getPosition(int key);

  SoundAnalizerData getSoundData();
  
  void onNewUser(int userId);
}

public class SoundAnalizerData {
  private float[] values;
  private boolean beat;
  
  public SoundAnalizerData(float[] values, boolean beat) {
    this.values = values;
    this.beat = beat;
  }
  
  public float[] getValues() {
    return values;
  }
  
  public boolean getBeat() {
    return beat;
  }
}

public class Source implements ISource {
  Kinect kinect;
  SoundAnalizer sound;
  
  public Source(PApplet parent) {
    kinect = new Kinect(parent);
    sound = new SoundAnalizer(parent);
  }
  
  public void update() {
    kinect.update();
    sound.next();
  }
   
  public PImage getRGB() {
    return kinect.getRGB();
  }
  
  public int getWidth() {
    return kinect.getWidth();
  }
  
  public int getHeight() {
    return kinect.getHeight();
  }
  
  public PVector[] getRawDepth() {
    return kinect.getRawDepth();
  }
  
  public int[] getUserMask() { 
    return kinect.getUserMask();
  }
  
  public int[] getUsers() {
    return kinect.getUsers();
  }
  
  public PVector getPosition(int key) {
    return kinect.get(key);
  }
  
  public SoundAnalizerData getSoundData() {
    return sound.getData();
  }
  
  public void onNewUser(int userId){
    kinect.onNewUser(userId);
  }
}

public class Kinect {
  SimpleOpenNI kinect;
  HashMap<Integer, PVector> skeleton = new HashMap<Integer, PVector>();

  public Kinect(PApplet parent) {
    kinect = new SimpleOpenNI(parent);
    kinect.enableDepth();
    kinect.enableRGB();
    kinect.enableUser();
    
    skeleton.put(RIGHT_HAND, new PVector());
    skeleton.put(LEFT_HAND, new PVector());
    skeleton.put(HEAD, new PVector());
  }
  
  public void onNewUser(int userId){
    kinect.startTrackingSkeleton(userId);
  }
    
  public PImage getRGB() {
    return kinect.rgbImage();
  }
  
  public int getWidth() {
    return kinect.depthWidth();
  }
  
  public int getHeight() {
    return kinect.depthHeight();
  }
  /*
  public int[] getRawDepth() { 
    return kinect.depthMap();
  }
 */
  public PVector[] getRawDepth() { 
    return kinect.depthMapRealWorld();
  }
 
  public int[] getUserMask() { 
    return kinect.userMap();
  }
  
  public int[] getUsers() {
    return kinect.getUsers();
  }
 
  private PVector getSpot(int uid, int skel) {
    PVector real = new PVector();      
    kinect.getJointPositionSkeleton(uid, skel, real);
    PVector proj = new PVector();
    kinect.convertRealWorldToProjective(real, proj);
    return proj;
  }

  public void update() {
    kinect.update();
    
    int[] users = kinect.getUsers();
    for(int i = 0; i < users.length; i++) {
      int userId = users[i];
      //check if user has a skeleton
      if(kinect.isTrackingSkeleton(userId)) {
        PVector pos;
        pos = getSpot(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
        skeleton.get(RIGHT_HAND).set(pos.x, pos.y);
        pos = getSpot(userId, SimpleOpenNI.SKEL_LEFT_HAND);
        skeleton.get(LEFT_HAND).set(pos.x, pos.y);
        pos = getSpot(userId, SimpleOpenNI.SKEL_HEAD);
        skeleton.get(HEAD).set(pos.x, pos.y);
      }
    }
  }
  
  public PVector get(int key) {
    return skeleton.get(key);
  }
}

import ddf.minim.analysis.*;
import ddf.minim.*;

public class SoundAnalizer {
  private final float LOW_THRESHOLD = 0.4; // soglia minima anti rumore di fondo
  private final int DEADLINE = 5000; // 5 secondi
  
  private Minim minim;
  private AudioInput in;
  private FFT fft;
  private BeatDetect beat;

  private SoundAnalizerData data;
  
  public SoundAnalizer(PApplet fileSystemHandler) {
    minim = new Minim(fileSystemHandler);
    in = minim.getLineIn(Minim.STEREO, 512, 44100, 16);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    
    fft.logAverages(150, 4); // 4 per 8 ottave = 32 valori
    
    beat = new BeatDetect();
  }

  public void next() {
    float[] ret = new float[fft.avgSize()];
    fft.forward(in.mix);
   
    for(int i = 0; i < fft.avgSize(); i++) {
      float tmp = fft.getAvg(i);
      if(tmp < LOW_THRESHOLD) {
        tmp = 0;
      }
      
      ret[i] = tmp;
    }
    
    beat.detect(in.mix);
    boolean beatVal = false;
    //beatVal = beat.isKick();
    //beatVal = beat.isSnare();
    //beatVal = beat.isHat();
    //beatVal = beat.isRange();
    beatVal = beat.isOnset();
    
    data = new SoundAnalizerData(ret, beatVal);
  }

  public SoundAnalizerData getData() {
    return data;
  }
  
  public void stop() {
    in.close();
    minim.stop();
  }
}
