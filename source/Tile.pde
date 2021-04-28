class Tile {
  private List<Hex> neighborHex;
  private List<Tile> neighbors;
  private Edge[] edges = new Edge[6];
  private Corner[] corners = new Corner[6];
  private Hex pos = new Hex(0, 0);
  private Type type;
  boolean highlighted = false;

  Tile(Hex pos) {
    this.pos = pos;
  }

  void assignType() {
    Collections.shuffle(grid.tileList);
    type = grid.tileList.get(0);
    grid.tileList.remove(0);
  }

  void setNeighborPos(List<Hex> value) {
    neighborHex = value;
  }

  void setNeighbors(List<Tile> value) {
    neighbors = value;
  }

  void setEdges(Edge[] value) {
    edges = value;
  }

  void setCorners(Corner[] value) {
    corners = value;
  }

  List getNeighborPos() {
    return neighborHex;
  }

  List getNeighbors() {
    return neighbors;
  }

  Edge[] getEdges() {
    return edges;
  }

  Corner[] getCorners() {
    return corners;
  }

  List<Hex> getSharedNeighborPosWith(Tile other) {
    List<Hex> shared = new ArrayList();
    Tile t = this;

    if (t.equals(other)) 
      return neighborHex;

    for (Hex h : neighborHex) {
      for (Hex o : other.neighborHex) {
        if (h.equals(o))
          shared.add(h);
      }
    }

    return shared;
  }

  @Override
    boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Tile)) return false;
    Tile t = (Tile) other;
    return pos.equals(t.pos);
  }
}
