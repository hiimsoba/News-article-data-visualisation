class TileCategory {

  // x, width, title of the category
  float x;
  float w;
  String title;

  // and the arraylist of tiles ( articles )
  ArrayList<Tile> tiles;

  // how many articles in each row ? 
  // hard coded for now, you can do something more creative with it, idk
  static final int tiles_per_row = 6;

  // length of a single tile's side
  float tile_side_length;

  // constructor
  TileCategory(String title_, float x_, float w_) {
    tiles = new ArrayList<Tile> ();
    title = title_;
    x = x_;
    w = w_;
    // and also initialize the size of a tile as being the width of the tile category divided by the number of tiles in each row
    tile_side_length = w / tiles_per_row;
  }

  void addTile(Tile t) {
    // add a tile to the tile arraylist
    tiles.add(t);
  }

  // update all the tiles
  void updateTiles() {
    for (Tile t : tiles) {
      t.update();
    }
  }

  // will set the position of each tile in the tile arraylist
  // the first tiles in the arraylist will be the oldest, and the last ones will be the newest
  // since that's how we requested the data from the api
  // so 
  void setPositionsToTiles() {
    // set x to be at the right side of the category
    // since this will be the x of the last ( newest ) article
    // if you want the newest articles at the top, just reverse the order of the arraylist, everything else will be the same
    float tile_x = x + (tiles_per_row - 1) * tile_side_length;
    // and y will be just above the line in the middle of the screen
    float tile_y = height * 0.5 - tile_side_length;

    // do this while there are still tiles
    int tiles_num = tiles.size() - 1;
    while (tiles_num >= 0) {
      // complete a single row and also keep track of whether or not there are still tiles left
      for (int i = 0; i < tiles_per_row && tiles_num >= 0; ++i, --tiles_num) {
        // set the position of the current tile to (tile_x, tile_y)
        tiles.get(tiles_num).pos = new PVector(tile_x, tile_y);
        // decrease x by the length of a tile's side
        tile_x -= tile_side_length;
      }
      // decrease the y to go up by the same amount
      tile_y -= tile_side_length;
      // and reset the x to be again to the right side
      tile_x = x + (tiles_per_row - 1) * tile_side_length;
    }
  }

  // show all the tiles
  void showTiles() {
    for (Tile t : tiles) {
      t.show();
    }
  }

  // and show each tile category
  // basically show the title and some dotted lines
  void show() {
    fill(255);
    textSize(12);
    textAlign(LEFT, TOP);
    text(title, x + w * 0.1, height * 0.5 + w * 0.05);

    stroke(255, 150);
    verticalDottedLine(x + w, height / 2, height, 7, 4);

    // and show the tiles finally
    showTiles();
  }
}

void verticalDottedLine(float x, float start_y, float end_y, float line_len, float space_len) {
  // draw a vertical dotted line from (x, start_y) to (x, end_y)
  // made out of lines of line_len size and spaces of space_len size
  for (float y = min(start_y, end_y); y <= max(start_y, end_y); ) {
    line(x, y, x, y + line_len);
    y += line_len + space_len;
  }
}
