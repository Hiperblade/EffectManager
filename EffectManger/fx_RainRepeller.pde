import java.util.Iterator;

public class RainRepeller implements IEffect {
  ISource source;
  ParticleSystem ps;

  public RainRepeller() {
    ps = new ParticleSystem(new PVector(width / 2, 50));
  }
  
  public void setSource(ISource _source) {
    source = _source;
  }
  
  public String getName() {
    return "RainRepeller";
  }
  
  public void activate() {
  }
  
  public void draw() {
    PVector pos;
    ps.applyG();
    pos = source.getPosition(HEAD);
    ps.applyRepeller(new Repeller(pos.x, pos.y));
    pos = source.getPosition(RIGHT_HAND);
    ps.applyRepeller(new Repeller(pos.x, pos.y));
    pos = source.getPosition(LEFT_HAND);
    ps.applyRepeller(new Repeller(pos.x, pos.y));
    
    background(0);
    for(int i = 0; i < 8; i++)
    {
      ps.addParticle();
    }
    ps.run();
  }
}

// classi di supporto
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  // We could vary mass for more interesting results.
  float mass = 1;

  Particle(PVector l) {
    // We now start with acceleration of 0.
    acceleration = new PVector(0,0);
    velocity = new PVector(0,random(5,8));
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  //[full] Newton’s second law & force accumulation
  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }
  //[end]

  //[full] Standard update
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifespan -= 1.5;
  }
  //[end]

  //[full] Our Particle is a circle.
  void display() {
    stroke(150,200,255,lifespan);
    strokeWeight(2);
    noFill();
    line(location.x,location.y,location.x + (velocity.x*2),location.y + (velocity.y*2));
  }
  //[end]

  //[full] Should the Particle be deleted?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  //[end]
}


class Repeller {
  // A Repeller doesn’t move, so you just need location.
  PVector location;
  float r = 30;

  Repeller(float x, float y)  {
    location = new PVector(x,y);
  }

  void display() {
    stroke(255);
    fill(255);
    ellipse(location.x,location.y,r,r);
  }
  
     // All the same steps we had to calculate an attractive force, only pointing in the opposite direction.
  PVector repel(Particle p) {
    //[full] 1) Get force direction.
    PVector dir =
      PVector.sub(location,p.location);
    //[end]
    //[full] 2) Get distance (constrain distance).
    float d = dir.mag();
    d = constrain(d,1,50);
    dir.x += random(-8,8);
    //[end]
    dir.normalize();
    // 3) Calculate magnitude.
    float uX = pow(p.velocity.x, 2);
    float uY = pow(p.velocity.y, 2);
    PVector forceV = new PVector(dir.x*uX/(uX+uY), dir.y*uY/(uX+uY));
    float force = -forceV.mag();
    //float force = -1 * 80 / (d * d);
    // 4) Make a vector out of direction and magnitude.
    dir.mult(force);
    if ( d == 50)
    {
      dir.mult(0);
    }
    return dir;
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(new PVector(int (random(0,width)),-5)));
    //particles.add(new Particle(new PVector(width/2-20,-5)));
  }

  void applyForce(PVector f) {
    //[full] Using an enhanced loop to apply the force to all particles
    for (Particle p: particles) {
      p.applyForce(f);
    }
    //[end]
  }

  void applyG() {
    PVector f;
    for (Particle p: particles) {
      f = p.velocity;
      float m = f.mag();
      f.normalize();
      
      if(f.y < 0 || abs(f.x) > 0.5)
      {
        if(f.x > 0)
        {
          f.rotate(PI/8);
        }
        else if(f.x < 0)
        {
          f.rotate(-PI/8);
        }
      }
      
      f.mult(m);
      p.velocity = f;
    }
  }

  void run() {
    //[full] Can’t use the enhanced loop because we want to check for particles to delete.
    Iterator<Particle> it = particles.iterator();
    while (it.hasNext()) {
      Particle p = (Particle) it.next();
      p.run();
      if (p.isDead()) {
        it.remove();
      }
    }
    //[end]
  }
  
  void applyRepeller(Repeller r) {
    for (Particle p: particles) {
      PVector force = r.repel(p);
      p.applyForce(force);
    }
  }
}
