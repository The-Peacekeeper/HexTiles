abstract class Node {
  Hex pos;
  boolean highlighted = false;
  
  Node(Hex pos) {
    this.pos = pos;
  }
  
  @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (other.getClass() != this.getClass()) return false;
    Node o = (Node) other;
    return pos.equals(o.pos);
  }
}
