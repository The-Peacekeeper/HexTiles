import java.util.*; //<>// //<>// //<>//

enum Type {
  WHEAT, // 4/18
    SHEEP, // 4/18
    WOOD, // 4/18
    BRICK, // 3/18
    ORE, // 3/18
    DESERT // always 1
}

int boardSize = 3;
int tileSize = 4*height/boardSize;
Grid grid = new Grid(boardSize);
String typeToSelect = null;

void setup() {
  fullScreen();
  grid.generateGrid();
}

void draw() {
  background(200);
  drawTiles();
  highlightMouse();
}

void drawTiles() {
  pushMatrix();
  translate(width/2, height/2);

  for (Tile t : grid.tiles.values()) {
    drawTile(t);
  }

  /*for (Node n : grid.allNodes.values()) {
    fill(0);
    textAlign(CENTER, CENTER);
    PVector temp = hexToPixel(n.pos);
    float x = temp.x;
    float y = temp.y;
    text(n.pos.toString(), x, y);
  } */

  popMatrix();
}

void highlightMouse() {
  fill(150);
  circle(mouseX, mouseY, 10);
  Hex mousePos = pixelToHex(mouseX-width/2, mouseY-height/2);  

  if (typeToSelect != null) {
    Node selectedNode = getNearestNode(mousePos, typeToSelect);
    PVector pos = hexToPixel(selectedNode.pos);
    circle(pos.x+width/2, pos.y+height/2, 10);
  }
}

Node getNearestNode(Hex pos, String type) {
  float lowestDistance = 10;
  Node closestNode = null;
  type = "class ProcessingHexTiles$" + type;

  for (Node n : grid.allNodes.values()) {
    float temp = n.pos.distanceTo(pos);
    String name = n.getClass().toString();

    if (temp < lowestDistance && name.equals(type)) {
      lowestDistance = temp;
      closestNode = n;
    }
  }

  return closestNode;
}

void drawTile(Tile t) {
  PVector temp = hexToPixel(t.pos);
  float x = temp.x;
  float y = temp.y;

  if (t.type == Type.WHEAT) {
    fill(#f5deb3);
  } else if (t.type == Type.SHEEP) {
    fill(#D8FFE9);
  } else if (t.type == Type.WOOD) {
    fill(#2D7A36);
  } else if (t.type == Type.BRICK) {
    fill(#FF8A6D);
  } else if (t.type == Type.ORE) {
    fill(#636363);
  } else if (t.type == Type.DESERT) {
    fill(#FFE100);
  }

  drawHex(x, y, tileSize);
}

void drawHex(float x, float y, float size) {
  float w = sqrt(3) * size;
  float h = 2*size;

  beginShape();
  vertex(x, y+h/2);
  vertex(x+w/2, y+h/4);
  vertex(x+w/2, y-h/4);
  vertex(x, y-h/2);
  vertex(x-w/2, y-h/4);
  vertex(x-w/2, y+h/4);
  endShape(CLOSE);
}

PVector hexToPixel(Hex hex) {
  float x = tileSize/grid.scale * (sqrt(3) * hex.q  +  sqrt(3)/2 * hex.r);
  float y = tileSize/grid.scale * (3/2f * hex.r);
  return new PVector(x, y);
}

Hex pixelToHex(float x, float y) {
  float q = (grid.scale*(x/sqrt(3) - y/3f)/tileSize);  //grid.scale
  float r = (2*grid.scale/3f * y/tileSize);
  return new Hex(q, r);
}

void keyPressed() {
  switch (key) {
  case 'S':
  case 's':
    typeToSelect = "Corner";
    break;
  case 'R':
  case 'r':
    typeToSelect = "Edge";
    break;
  }
}
