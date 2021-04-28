class Grid {
  HashMap<String, Tile> tiles = new HashMap();
  HashMap<String, Edge> edges = new HashMap();
  HashMap<String, Corner> corners = new HashMap();
  HashMap<String, Node> allNodes = new HashMap();
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

  void createTileList() {
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
      tileList.add(tileList.get((int)random(0, 19)));
    }
  }

  void generateGrid() {
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

  void generateTiles() {
    generateTile(new Hex(0, 0));

    for (int ring = 1; ring < ringCount; ring++) {
      addLoop(ring);
    }
  }

  void assignTiles() {
    for (Tile t : tiles.values()) {
      t.assignType();
    }
  }

  void generateCorners() {
    for (Tile t : tiles.values()) {
      generateCornersFor(t);
    }
  }

  void generateEdges() {
    for (Tile t : tiles.values()) {
      generateEdgesFor(t);
    }
  }

  void addLoop(int ring) {
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

  void generateCornersFor(Tile t) {
    for (int i = 0; i < 6; i++) {
      float theta = i*PI/3;
      float q = round(t.pos.q+(2*sin(theta-PI/6)));
      float r = round(t.pos.r+(2*cos(theta)));
      Hex temp = new Hex(q, r);

      Corner c = new Corner(temp);
      Corner cTemp = corners.putIfAbsent(temp.toString(), c);
      allNodes.putIfAbsent(temp.toString(), c);

      if (cTemp == null) {
        c.tiles.add(t);
        t.corners[i] = c;
      } else {
        cTemp.tiles.add(t);
        t.corners[i] = cTemp;
      }
    }
  }

  void generateEdgesFor(Tile t) {
    for (int i = 0; i < 6; i++) {
      Corner c1 = t.corners[i];
      Corner c2 = t.corners[(i+1)%6];
      Hex temp = Hex.midpoint(c1.pos, c2.pos);

      Edge e = new Edge(temp, c1, c2);
      Edge eTemp = edges.putIfAbsent(temp.toString(), e);
      allNodes.putIfAbsent(temp.toString(), e);

      if (eTemp == null) {
        e.tiles.add(t);
        t.edges[i] = e;
      } else {
        eTemp.tiles.add(t);
        t.edges[i] = e;
      }
    }
  }

  Tile generateTile(Hex pos) {
    Tile tile = new Tile(pos);
    tile.setNeighborPos(findNeighborPos(pos));
    tiles.put(pos.toString(), tile);
    allNodes.putIfAbsent(pos.toString(), tile);
    return tile;
  }

  List<Hex> findNeighborPos(Hex pos) {
    List<Hex> temp = new ArrayList();
    temp.add(hexNeighbor(pos, 0));
    temp.add(hexNeighbor(pos, 1));
    temp.add(hexNeighbor(pos, 2));
    temp.add(hexNeighbor(pos, 3));
    temp.add(hexNeighbor(pos, 4));
    temp.add(hexNeighbor(pos, 5));
    return temp;
  }

  Hex hexDirection(int direction) {
    return axialDirections[direction];
  }

  Hex hexNeighbor(Hex hex, int direction) {
    Hex dir = hexDirection(direction);
    return new Hex(hex.q + dir.q, hex.r + dir.r);
  }


  Hex cubeToAxial(Cube cube) {
    float q = cube.x;
    float r = cube.z;
    return new Hex(q, r);
  }

  Cube axialToCube(Hex hex) {
    float x = hex.q;
    float z = hex.r;
    float y = -x-z;
    return new Cube(x, y, z);
  }

  int getTileCount(int i) {
    return (int)(3*(sq(i)-i)+1);
  }
}

/*
amount of tiles where n is ringCount
 6*(n-1)+6*(n-2)+6*(n-3).... 6*(n-n)+1
 */
