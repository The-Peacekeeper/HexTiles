class Edge extends Node {
  List<Tile> tiles = new ArrayList();
  Corner[] corners = new Corner[2];
  
  Edge (Hex pos, Corner corner1, Corner corner2) {
    super(pos);
    corners[0] = corner1;
    corners[1] = corner2;
  }
}
