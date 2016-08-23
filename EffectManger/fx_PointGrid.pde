public class PointGrid implements IEffect {

  public class Punto {
    PVector position;
    int diametro = 3;
    
    Punto(float x, float y) {
      position = new PVector(x, y);
    }
  
    public void draw(PVector origin1, PVector origin2) {
      float positionx, positiony, diam;
      positionx = position.x;
      positiony = position.y;
      diam = diametro;
      float distanza1 = ((pow(origin1.x - position.x, 2) + pow(origin1.y - position.y, 2)) / pow(diametro * 40, 2));
      float distanza2 = ((pow(origin2.x - position.x, 2) + pow(origin2.y - position.y, 2)) / pow(diametro * 40, 2));
      float distanza = (distanza1 < distanza2)?(distanza1):(distanza2);
      if (distanza < 1) {
        positionx += random(-0.5, 0.5);
        positiony += random(-0.5, 0.5);
        diam += 3.8 * ( 1 - distanza );
        
        fill(255, (255 * distanza), 255 * distanza);
      } else {
        fill(255);
      }
      ellipse(positionx, positiony, diam, diam); 
    }
  }

  int verticali;
  int orizzontali;
  Punto[][] griglia;
  ISource source;

  public PointGrid() {
    orizzontali = (int)(width / 10);
    verticali = (int)(height / 10);
    griglia = new Punto[orizzontali][verticali];
    
    float stepx = width / orizzontali;
    float stepy = height / verticali;

    for (int x = 0; x < orizzontali; x++)
    {
      for (int y = 0; y < verticali; y++)
      {
        griglia[x][y] = new Punto(x * stepx + stepx / 2, y * stepy + stepy / 2);
      }
    }
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "PointGrid";
  }
  
  public void activate() {
  }
  
  public void draw() {
    background(0);
    noStroke();
    fill(250);
    
    PVector origin1 = source.getPosition(RIGHT_HAND);
    PVector origin2 = source.getPosition(LEFT_HAND);
    
    for (int x = 0; x < orizzontali; x++)
    {
      for (int y = 0; y < verticali; y++)
      {
        griglia[x][y].draw(origin1, origin2);
      }
    }
  }
}
