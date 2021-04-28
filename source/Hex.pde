static class Hex {
  public float q, r;

  Hex(float q, float r) {
    this.q = q;
    this.r = r;
  }

  void set(float q, float r) {
    this.q = q;
    this.r = r;
  }

  int loopNumber() {
    return (int)(abs(q) + abs(q + r) + abs(r)) / 2;
  }

  static Hex midpoint(Hex h1, Hex h2) {
    PVector v1 = new PVector(h1.q, h1.r);
    PVector v2 = new PVector(h2.q, h2.r);

    v1.lerp(v2, 0.5);
    return new Hex(v1.x, v2.x);
  }

  @Override
    boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Hex)) return false;
    Hex h = (Hex) other;
    return q == h.q && r == h.r;
  }

  @Override
    String toString() {
    String temp = round(q)+","+round(r);
    return temp;
  }

  float distanceTo(Hex other) {
    PVector  v1 = new PVector(q, r);
    PVector  v2 = new PVector(other.q, other.r); 
    return v1.dist(v2);
  }
}
