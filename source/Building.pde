class Building {
  Node node;
  List<Type> requirements = new ArrayList();
  
  Building(Hex pos) {
    node = grid.allNodes.get(pos.toString());
  }
  
  Building(Node node) {
    this.node = node;
  }
}
