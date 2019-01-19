class TileArticle {
  // side length of the image ( square, also )
  int image_len;
  PImage img;

  // data of the article
  String pub_date;
  String headline;
  String snippet;

  // and keywords
  ArrayList<String> keywords;


  // we'll make a keywords string from the keywords arraylist
  String keywords_str = "";

  // show the article at a bit of a distance from the mouse ( it's nicer, visually )
  float mouse_offset = width * 0.02;

  // width of the article is half the number of years times the width of each year's category width
  // minus the mouse offset, so the article will always be between the bounds of the window
  // quick maths
  int _width = int(year_tiles.size() * 0.5 * tile_category_width - mouse_offset);
  // and height of the article will be half of the width, so we have a nice 2:1 ratio
  int _height = int(0.5 * _width);

  // offset from edges is like 5% of the height
  int offset_from_edges = int(0.05 * _height);

  // alpha stuff for the fade-in effect
  int alpha = 0;
  int max_alpha = 210;
  int alpha_increment = 7;

  // constructor
  TileArticle(PImage img_, String pub_date_, String headline_, String snippet_, ArrayList<String> keywords_) {
    keywords = keywords_;
    img = img_.copy();

    pub_date = pub_date_;
    headline = headline_;
    snippet = snippet_;

    // create the keywords string
    if (keywords.size() > 0) {
      // we'll create it only if there's at least one keyword
      // if there is, first line will be like a kinda title, "Keywords"
      keywords_str = "Keywords\n";

      // and then we add the keywords
      for (String s : keywords_) {
        keywords_str += (s + ", ");
      }
      // and remove the last two characters, which will be a comma and a space
      keywords_str = keywords_str.substring(0, keywords_str.length() - 2);
    }

    // length of the image will be half of the width minus two times the offset from the edges
    image_len = int(_width * 0.5 - 2 * offset_from_edges);
    // and resize the image
    img.resize(image_len, image_len);
  }

  // display the article at a given (x, y)
  void show(float x, float y) {
    // coordinates of the top left corner
    float rect_x, rect_y;

    // first, check if the article as-is will go above the width of the window
    // if so, we'll swap its direction ( instead of drawing it to the right, we'll draw it to the left )
    // so that it will always be between the bounds of the window
    if (x + _width + mouse_offset >= width) {
      // maths
      rect_x = x - _width - mouse_offset;
      rect_y = y + mouse_offset;
    } else {
      // again, maths
      rect_x = x + mouse_offset;
      rect_y = y + mouse_offset;
    }

    // draw the rectangle ( background of the article ) first
    fill(255, constrain(alpha, 0, max_alpha));
    rect(rect_x, rect_y, _width, _height);

    // then draw the image
    tint(255, map(alpha, 0, max_alpha, 0, 200));
    image(img, rect_x + offset_from_edges, rect_y + offset_from_edges);

    // put the headline, pub date, snippet
    textAlign(CENTER, CENTER);
    textSize(13);
    fill(0, map(alpha, 0, max_alpha, 0, 220));

    // (x, y) are the 2nd and 3rd argument, 4th and 5th argument is the width and height of the bounding box of the text
    // so that it automagically wraps around the edges
    text(headline, rect_x + 3 * offset_from_edges + image_len, rect_y + offset_from_edges, image_len, image_len / 4);

    // not gonna explain how i got there, it's just maths
    textSize(12);
    text(snippet, rect_x + 3 * offset_from_edges + image_len, rect_y + offset_from_edges + image_len / 4, image_len, image_len / 2);

    textSize(12);
    text(keywords_str, rect_x + 3 * offset_from_edges + image_len, rect_y + offset_from_edges + 3 * image_len / 4, image_len, image_len / 4);

    // draw the bounding boxes of the text if debug mode is on
    // ( this was really necessary )
    if (debug) {
      fill(0, 150);
      rect(rect_x + 3 * offset_from_edges + image_len, rect_y + offset_from_edges, image_len, image_len / 4);
      rect(rect_x + 3 * offset_from_edges + image_len, rect_y + offset_from_edges + image_len / 4, image_len, image_len / 2);
      rect(rect_x + 3 * offset_from_edges + image_len, rect_y + offset_from_edges + 3 * image_len / 4, image_len, image_len / 4);
    }

    // and finally, increment the alpha
    alpha += alpha_increment;
  }
}

boolean debug = false;

// whenever you press space, debug mode switches its state, so you can see the bounding boxes of the text
void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}
