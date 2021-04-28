import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ProcessingHexTiles extends PApplet {

 //<>//

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

public void setup() {
  
  grid.generateGrid();
}

public void draw() {
  background(200);
  drawTiles(size);
  highlightMouse(size);
}

public void drawTiles(int size) {
  pushMatrix();
  translate(width/2, height/2);

  for (Tile t : grid.tiles.values()) {
    drawTile(t, size);
  }

  popMatrix();
}

public void highlightMouse(int size) {
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

public void drawTile(Tile t, float size) {
  PVector temp = hexToPixel(t.pos, size);
  float x = temp.x;
  float y = temp.y;

  if (t.type == Type.WHEAT) {
    fill(0xfff5deb3);
  } else if (t.type == Type.SHEEP) {
    fill(0xffD8FFE9);
  } else if (t.type == Type.WOOD) {
    fill(0xff2D7A36);
  } else if (t.type == Type.BRICK) {
    fill(0xffFF8A6D);
  } else if (t.type == Type.ORE) {
    fill(0xff636363);
  } else if (t.type == Type.DESERT) {
    fill(0xffFFE100);
  }

  drawHex(x, y, size);

  if (t.highlighted) {
    fill(150, 100);
    drawHex(x, y, size*0.8f);
  }
}

public void drawHex(float x, float y, float size) {
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

public PVector hexToPixel(Hex hex, float size) {
  float x = size/grid.scale * (sqrt(3) * hex.q  +  sqrt(3)/2 * hex.r);
  float y = size/grid.scale * (3/2f * hex.r);
  return new PVector(x, y);
}

public Hex pixelToHex(float x, float y, int size) {
  int q = round(grid.scale*(x/sqrt(3) - y/3f)/size);  //grid.scale
  int r = round(2*grid.scale/3f * y/size);
  return new Hex(q, r);
}
class Corner {
  HashMap<String, Tile> tiles;
  Hex pos;
    
  Corner (Hex pos) {
    this.pos = pos;
  }
  
  public @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Corner)) return false;
    Corner c = (Corner) other;
    return pos.equals(c.pos);
  }
}
class Cube {
  public float x,y,z;
  
  Cube(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Cube)) return false;
    Cube c = (Cube) other;
    return x == c.x && y == c.y && z == c.z;
  }
}
class Edge {
  HashMap<String, Tile> tiles;
  Corner[] corners = new Corner[2];
  Hex pos;
  
  Edge (Hex pos, Corner corner1, Corner corner2) {
    this.pos = pos;
    corners[0] = corner1;
    corners[1] = corner2;
  }
  
  public @Override
  boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Corner)) return false;
    Corner c = (Corner) other;
    return pos.equals(c.pos);
  }
}
class Grid {
  HashMap<String, Tile> tiles = new HashMap();
  HashMap<String, Edge> edges = new HashMap();
  HashMap<String, Corner> corners = new HashMap();
  Hex[] axialDirections = new Hex[6];
  int ringCount;
  float scale = 3;
  List<Type> tileList = new ArrayList();

  Grid(int ringCount) {
    this.ringCount = ringCount;
    axialDirections[0] = new Hex(-scale, 0);
    axialDirections[1] = new Hex(0, -scale);
    axialDirections[2] = new Hex(scale, -scale);
    axialDirections[3] = new Hex(scale, 0);
    axialDirections[4] = new Hex(0, scale);
    axialDirections[5] = new Hex(-scale, +scale);

    createTileList();
  }

  public void createTileList() {
    for (int i = 0; i < 4; i++) {
      tileList.add(Type.WHEAT);
    }
    for (int i = 0; i < 4; i++) {
      tileList.add(Type.SHEEP);
    }
    for (int i = 0; i < 4; i++) {
      tileList.add(Type.WOOD);
    }
    for (int i = 0; i < 3; i++) {
      tileList.add(Type.BRICK);
    }
    for (int i = 0; i < 3; i++) {
      tileList.add(Type.ORE);
    }

    tileList.add(Type.DESERT);

    while (tileList.size() < getTileCount(ringCount)) {
      tileList.add(tileList.get((int)random(0, 18)));
    }
  }

  public void generateGrid() {
    println("Generating Grid");
    println("Generating Tiles");
    generateTiles();
    assignTiles();
    println("Finished Generating Tiles");
    println("Generating Corners");
    generateCorners();
    println("Finished Generating Corners");
    println("Generating Edges");
    generateEdges();
    println("Finished Generating Edges");
    println("Finished Generating Grid");
  }

  public void generateTiles() {
    generateTile(new Hex(0, 0));

    for (int ring = 1; ring < ringCount; ring++) {
      addLoop(ring);
    }
  }

  public void assignTiles() {
    for (Tile t : tiles.values()) {
      t.assignType();
    }
  }

  public void generateCorners() {
    for (Tile t : tiles.values()) {
      generateCornersFor(t);
    }
  }

  public void generateEdges() {
    for (Tile t : tiles.values()) {
      generateEdgesFor(t);
    }
  }

  public void addLoop(int ring) {
    List<Hex> neighborPos = new ArrayList();

    for (Tile t : tiles.values()) {
      neighborPos.addAll(t.getNeighborPos());
    }

    for (int i = neighborPos.size()-1; i >= 0; i--) {
      Hex pos = neighborPos.get(i);

      if (pos.loopNumber() != ring*scale) {
        neighborPos.remove(i);
      } else {
        generateTile(pos);
      }
    }
  }

  public void generateCornersFor(Tile t) {
    for (int i = 0; i < 6; i++) {
      float theta = i*PI/3;
      float q = round(t.pos.q+(2*sin(theta+PI/6)));
      float r = round(t.pos.r+(2*cos(theta)));
      Hex temp = new Hex(q, r);

      Corner c = new Corner(temp);
      corners.put(temp.toString(), c);
      t.corners[i] = c;
    }
  }

  public void generateEdgesFor(Tile t) {
    for (int i = 0; i < 6; i++) {
      Corner c1 = t.corners[i];
      Corner c2 = t.corners[(i+1)%6];
      Hex temp = Hex.midpoint(c1.pos, c2.pos);

      Edge e = new Edge(temp, c1, c2);
      edges.put(temp.toString(), e);
      t.edges[i] = e;
    }
  }

  public Tile generateTile(Hex pos) {
    //pos = (Hex)getEqualKey(tiles, pos);
    //Tile tile = tiles.get(pos);

    //if (tile == null) {
    Tile tile = new Tile(pos);
    tile.setNeighborPos(findNeighborPos(pos));
    tiles.put(pos.toString(), tile);
    //}

    return tile;
  }

  public List<Hex> findNeighborPos(Hex pos) {
    List<Hex> temp = new ArrayList();
    temp.add(hexNeighbor(pos, 0));
    temp.add(hexNeighbor(pos, 1));
    temp.add(hexNeighbor(pos, 2));
    temp.add(hexNeighbor(pos, 3));
    temp.add(hexNeighbor(pos, 4));
    temp.add(hexNeighbor(pos, 5));
    return temp;
  }

  public Hex hexDirection(int direction) {
    return axialDirections[direction];
  }

  public Hex hexNeighbor(Hex hex, int direction) {
    Hex dir = hexDirection(direction);
    return new Hex(hex.q + dir.q, hex.r + dir.r);
  }


  public Hex cubeToAxial(Cube cube) {
    float q = cube.x;
    float r = cube.z;
    return new Hex(q, r);
  }

  public Cube axialToCube(Hex hex) {
    float x = hex.q;
    float z = hex.r;
    float y = -x-z;
    return new Cube(x, y, z);
  }

  public int getTileCount(int i) {
    return (int)(3*(sq(i)-i)+1);
  }
}

/*
amount of tiles where n is ringCount
 6*(n-1)+6*(n-2)+6*(n-3).... 6*(n-n)+1
 */
static class Hex {
  public float q, r;

  Hex(float q, float r) {
    this.q = q;
    this.r = r;
  }

  public void set(float q, float r) {
    this.q = q;
    this.r = r;
  }

  public int loopNumber() {
    return (int)(abs(q) + abs(q + r) + abs(r)) / 2;
  }

  public static Hex midpoint(Hex h1, Hex h2) {
    PVector v1 = new PVector(h1.q, h1.r);
    PVector v2 = new PVector(h2.q, h2.r);

    v1.lerp(v2, 0.5f);
    return new Hex(v1.x, v2.x);
  }

  public @Override
    boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Hex)) return false;
    Hex h = (Hex) other;
    return q == h.q && r == h.r;
  }

  public @Override
    String toString() {
    String temp = round(q)+","+round(r);
    return temp;
  }

  public float distanceTo(Hex other) {
    PVector  v1 = new PVector(q, r);
    PVector  v2 = new PVector(other.q, other.r); 
    return v1.dist(v2);
  }
}
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

  public void assignType() {
    Collections.shuffle(grid.tileList);
    type = grid.tileList.get(0);
    grid.tileList.remove(0);
  }

  public void setNeighborPos(List<Hex> value) {
    neighborHex = value;
  }

  public void setNeighbors(List<Tile> value) {
    neighbors = value;
  }

  public void setEdges(Edge[] value) {
    edges = value;
  }

  public void setCorners(Corner[] value) {
    corners = value;
  }

  public List getNeighborPos() {
    return neighborHex;
  }

  public List getNeighbors() {
    return neighbors;
  }

  public Edge[] getEdges() {
    return edges;
  }

  public Corner[] getCorners() {
    return corners;
  }

  public List<Hex> getSharedNeighborPosWith(Tile other) {
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

  public @Override
    boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof Tile)) return false;
    Tile t = (Tile) other;
    return pos.equals(t.pos);
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ProcessingHexTiles" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
