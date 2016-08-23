public interface IEffect {
  void setSource(ISource _source);
  String getName();
  void activate();
  void draw();
}

public class Manager {
  int current = -1;
  ArrayList<IEffect> effects = new ArrayList<IEffect>();

  ISource source;
  Syphon syphon;
  
  public Manager(PApplet parent, String syphonId) {
    source = new Source(parent);
    syphon = new Syphon(parent, syphonId);
  }
  
  public ISource getSource() {
    return source;
  }
  
  public int add(IEffect effect) {
    effect.setSource(source);
    effects.add(effect);
    return effects.size() - 1;
  }

  public IEffect setCurrent(int index) {
    if(index == -1) {
      current = index;
    } else if(index >= 0 && effects.size() > index) {
      current = index;
      return effects.get(current);
    }
    return null;
  }
  
  public String getName(int index) {
    if(index >= 0 && index < effects.size()) {
      return effects.get(index).getName();
    }
    return null;
  }
  
  public void draw() {
    source.update();
    
    if(current > -1) {
      effects.get(current).draw();
    } else {
      background(0);
    }
    
    syphon.send();
  }
}
