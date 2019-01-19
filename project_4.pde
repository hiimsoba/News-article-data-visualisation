ArrayList<TileCategory> year_tiles;
float tile_category_width;

int start_year = 2014;
int end_year = 2018;

void setup() {
  // create the window
  size(1280, 720);
  //fullScreen();

  // array list that will hold all JSON objects recieved from the API
  // pages_in_year[0] will hold all the pages recieved from the first year in the query, for example
  // and then pages[0][0] will hold all the articles from the first page from the first year in the query
  ArrayList<ArrayList<JSONObject>> pages_in_year = new ArrayList<ArrayList<JSONObject>> ();

  // load the data from the API, from the first year to the last one, with a maximum number of articles ( if you want to )
  // if you want to get all the articles, just set a very big number for the second argument
  // the API will only send as many articles as there are, tho
  for (int i = start_year; i <= end_year; i++) {
    println("Fetching articles from year " + i);
    pages_in_year.add(loadDataFromYearAPI(i, 50));
  }

  // these are the "areas" for each year
  year_tiles = new ArrayList<TileCategory> ();

  // and the width of a category will be the width of the window divided by the number of years there are in the query
  tile_category_width = (float) width / pages_in_year.size();

  // create the categories, one for each year
  for (int i = 0; i < pages_in_year.size(); i++) {
    // give it a title ( i.e. the year it holds data for ), an x position and a width 
    year_tiles.add(new TileCategory("" + (start_year + i), i * tile_category_width, tile_category_width));
  }

  // add "tiles" in each category
  // so for each year
  for (int i = 0; i < pages_in_year.size(); i++) {
    // get the category of that year
    TileCategory curr_category = year_tiles.get(i);
    // and the array list of pages that contain all the pages with articles
    ArrayList<JSONObject> curr_year_pages = pages_in_year.get(i);
    // and for each page in that year's pages
    for (int j = 0; j < curr_year_pages.size(); j++) {
      // get the response of the page
      JSONObject data = (JSONObject) curr_year_pages.get(j).get("response");
      // and get the articles from that page
      JSONArray docs = data.getJSONArray("docs");
      // for each article
      for (int k = 0; k < docs.size(); k++) {
        // get its content
        JSONObject current = (JSONObject) docs.get(k);

        // get the first image's url ( all images are basically the same, but are resized for different devices )
        // so we get the first one
        JSONArray article_multimedia = current.getJSONArray("multimedia");

        // get the publication date ( was useful for debugging, to see if articles are in order )
        String pub_date = current.getString("pub_date");

        // first 10 characters are the format YYYY-DD-MM or something like this, so i only needed this info
        pub_date = pub_date.substring(0, 10);

        // get the snippet
        String snippet = current.getString("snippet");
        // and the main headline
        String headline = ((JSONObject) current.get("headline")).getString("main");

        // also, the keywords
        ArrayList<String> keywords = new ArrayList<String> ();
        JSONArray keywords_json = current.getJSONArray("keywords");

        // and for each keyword, get only the keywords tagged as "subject", if there are any
        for (int s = 0; s < keywords_json.size(); s++) {
          JSONObject curr_keyword = (JSONObject) keywords_json.get(s);
          if (curr_keyword.getString("name").equals("subject")) {
            keywords.add(curr_keyword.getString("value"));
          }
        }

        // if there's at least one image in the article's content, then we shall get it
        if (article_multimedia.size() > 0) {
          String curr_img_url = ((JSONObject) article_multimedia.get(0)).getString("url");          
          // and add a tile to the current year's array of tiles ( articles )
          curr_category.addTile(new Tile(loadImage(img_url + curr_img_url), int(curr_category.tile_side_length), pub_date, headline, snippet, keywords));
        }
      }
    }

    // and we need this to set an x and y position for each tile in its parent year category
    curr_category.setPositionsToTiles();
  }
}

void draw() {
  // a nice color for the background
  background(color(60, 40, 110));

  // draw the line on the middle of the screen
  stroke(255, 150);
  strokeWeight(0.5);
  line(0, height * 0.5, width, height * 0.5);

  // show each tile category
  for (TileCategory year_tile : year_tiles) {
    year_tile.show();
  }

  // update each tile category
  // don't flip the order - the displaying might look weird if you do so
  // showing each tile category will display the category and the small tiles
  // and "updating" each of the tiles will display the bigger version of the article, if the conditions are met
  for (TileCategory year_tile : year_tiles) {
    year_tile.updateTiles();
  }
}
