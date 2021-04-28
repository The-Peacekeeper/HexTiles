class Edge {
  HashMap<String, Tile> tiles;
  Corner[] corners = new Corner[2];
  Hex pos;
  
  Edge (Hex pos, Corner corner1, Corner corner2) {
    this.pos = pos;
    corners[0] = corner1;
    corners[1] = corner2;
  }
  
  @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Corner)) return false;
    Corner c = (Corner) other;
    return pos.equals(c.pos);
  }
}
