import java.util.*; //<>//

enum Type {
  WHEAT, // 4/18
    SHEEP, // 4/18
    WOOD, // 3/18
    BRICK, // 3/18
    ORE, // 3/18
    DESERT // always 1
}

int boardSize = 3;
int size = 4*height/boardSize;
Grid grid = new Grid(boardSize);

void setup() {
  fullScreen();
  grid.generateGrid();
}

void draw() {
  background(200);
  drawTiles(size);
  highlightMouse(size);
}

void drawTiles(int size) {
  pushMatrix();
  translate(width/2, height/2);

  for (Tile t : grid.tiles.values()) {
    drawTile(t, size);
  }

  popMatrix();
}

void highlightMouse(int size) {
  fill(150);
  circle(mouseX, mouseY, 10);
  Hex mousePos = pixelToHex(mouseX-width/2, mouseY-height/2, size);

  for (Tile t : grid.tiles.values()) {
    if (t.pos.distanceTo(mousePos) < grid.scale/2) {
      t.highlighted = true;
    } else {
      t.highlighted = false;
    }
  }
}

void drawTile(Tile t, float size) {
  PVector temp = hexToPixel(t.pos, size);
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

  drawHex(x, y, size);

  if (t.highlighted) {
    fill(150, 100);
    drawHex(x, y, size*0.8);
  }
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

PVector hexToPixel(Hex hex, float size) {
  float x = size/grid.scale * (sqrt(3) * hex.q  +  sqrt(3)/2 * hex.r);
  float y = size/grid.scale * (3/2f * hex.r);
  return new PVector(x, y);
}

Hex pixelToHex(float x, float y, int size) {
  int q = round(grid.scale*(x/sqrt(3) - y/3f)/size);  //grid.scale
  int r = round(2*grid.scale/3f * y/size);
  return new Hex(q, r);
}
