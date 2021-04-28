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
    float q = (h1.q+h2.q) / 2;
    float r = (h1.r+h2.r) / 2;
    return new Hex(q, r);
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
    String temp = q+","+r;
    return temp;
  }

  float distanceTo(Hex other) {
    float dist = sqrt(sq(q-other.q) + sq(r-other.r));
    return dist;
  }
}
