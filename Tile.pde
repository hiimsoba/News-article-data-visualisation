// small "tile" class
class Tile {
  // position
  PVector pos;

  // side length of the tile ( which will be a square )
  int len;
  // the image associated with the tile
  PImage img;

  // the article displayed when the mouse is hovered over the article
  TileArticle article;

  // time since the mouse has been inside
  int time_since_inside;
  // and also keep track of whether the mouse was inside in the previous frame
  boolean was_inside = false;

  // constructor!
  Tile(PImage img_, int len_, String pub_date_, String headline_, String snippet_, ArrayList<String> keywords_) {
    // side len for the small tile
    len = len_;
    // image for the small tile
    img = img_.copy();
    // resize it to the length of the small tile
    img.resize(len, len);
    // and the "bigger" display of the article
    article = new TileArticle(img_, pub_date_, headline_, snippet_, keywords_);
  }

  void update() {
    // if the mouse is inside the tile
    if (mouseX > pos.x && mouseX < pos.x + len && mouseY > pos.y && mouseY < pos.y + len) {
      // if it was not previously inside, start the timer
      // and set the mouse as being inside
      if (!was_inside) {
        time_since_inside = millis();
        was_inside = true;
      } else {
        // if the mouse was previously inside
        if (millis() - time_since_inside >= 150) {
          // and if 150ms passed 
          // ( arbitrarily, a bit of delay, so we don't show each article automatically, it has a nice effect, but remove it if it bothers you )
          // show the article at the position of the mouse
          article.show(mouseX, mouseY);
        }
      }
    } else {
      // if the mouse is not inside the tile, set the article's alpha to 0 ( it has a fade-in effect, that's why we use the alpha )
      // and set the mouse as being outside the tile
      was_inside = false;
      article.alpha = 0;
    }
  }

  // show the tile
  void show() {
    // 0 transparency, so we show it completely
    tint(255, 255);
    image(img, pos.x, pos.y);
  }
}
