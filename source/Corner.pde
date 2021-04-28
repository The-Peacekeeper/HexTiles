class Corner {
  HashMap<String, Tile> tiles;
  Hex pos;
    
  Corner (Hex pos) {
    this.pos = pos;
  }
  
  @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Corner)) return false;
    Corner c = (Corner) other;
    return pos.equals(c.pos);
  }
}
