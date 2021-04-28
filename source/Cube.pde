class Cube {
  public float x,y,z;
  
  Cube(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Cube)) return false;
    Cube c = (Cube) other;
    return x == c.x && y == c.y && z == c.z;
  }
}
