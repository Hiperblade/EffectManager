import java.util.*;

Manager manager;
private HashMap<String, Integer> keyMap;

void setup() {
  size(640, 480, P3D);
  manager = new Manager(this, "EffettiProcessing");
  keyMap = new HashMap<String, Integer>();
  
  // registrazione effetti
  addEffect('1', new PointGrid());
  addEffect('2', new LinesToHands());
  addEffect('3', new RainRepeller());
  addEffect('4', new Rectangle());
  addEffect('5', new Rotation3D());
  addEffect('6', new Flag());
  addEffect('7', new CherryTree());
}

private void addEffect(char key, IEffect effect) {
  if(keyMap.containsKey("" + key)) {
    println("ERROR: Tasto " + key + " già associato");
  } else {
    int index = manager.add(effect);
    keyMap.put("" + key, index);
  }
}

void draw() {
  manager.draw();
}

void keyPressed() {
  if(keyMap.containsKey("" + key)) {
    println("Effetto corrente: " + manager.setCurrent(keyMap.get("" + key)).getName());
  } else if (key == '\\') {
    // disable all
    manager.setCurrent(-1);
    println("Effetto corrente: NESSUNO");
  } else if(key == 'h' || key == 'H') {
    //lista comandi
    println("==== Comandi ====");
    println("h : Lista comandi");
    println("\\ : Nessun effetto");
    println("=================");
    println("");
    println("==== Effetti ====");
    List<String> keys = Arrays.asList(keyMap.keySet().toArray(new String[0]));
    Collections.sort(keys);
    for(String k : keys) {
      println(k + " : " + manager.getName(keyMap.get(k)));
    }
    println("=================");
  }
}
