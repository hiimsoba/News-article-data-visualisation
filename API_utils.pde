String url = "https://api.nytimes.com/svc/search/v2/articlesearch.json?";
// please change this to your own api key if you have one
String api_key = "f9612f4afd6044c4a20bfed8c6f75e6c";
String q = "\"iranian+women\"";
String sort = "oldest";

// urls will be loaded from this url + each individual's image "source"
String img_url = "https://static01.nyt.com/";

ArrayList<JSONObject> loadDataFromYearAPI(int year, int max_articles) {
  // arraylist containing the results from the search
  ArrayList<JSONObject> result = new ArrayList<JSONObject> ();

  // 1st of january from the year
  String begin_date = year + "0101";
  // and 31st of december
  String end_date = year + "1231";

  // complete url for the api call
  String api_url_call = url + "api_key=" + api_key + "&q=" + q + "&begin_date=" + begin_date + "&end_date=" + end_date + "&sort=" + sort;

  // how many articles we got so far
  int articles = 0;

  // seems like the API can get at most 200 pages ( which is about 2000 articles, yikes! ), so we limit ourselves to that
  // trying to get more than 200 pages of results will cause some http error and will crash the program... so leave this as is
  int page = 0;
  while (page <= 200 && articles <= max_articles) {
    // print this so we know where we reached
    println("Requested page " + page);

    boolean got_page = false;
    JSONObject current_page = loadJSONObject(api_url_call + "&page=" + page);

    // keep asking for the page till we god damn get it
    do {
      // if the status is okay, we got it!
      if (current_page.getString("status").equals("OK")) {
        got_page = true;
      } else {
        // wait 2.5 secs before asking for the next page ( to avoid 429 http request, for too many requests )        
        delay(2500);
        current_page = loadJSONObject(api_url_call + "&page=" + page);
      }
    } while (!got_page);

    // add the page to the result
    result.add(current_page);

    // wait 2.5 secs before making the next API call ( to avoid 429 http request, for too many requests )
    delay(2500);

    JSONObject response = (JSONObject) current_page.get("response");

    // add the number of articles on the current page to our article total count
    articles += response.getJSONArray("docs").size();

    // we got data, now check if there are less than 10 articles; if there are, it means we reached the last page
    // so break out of the loop
    if (response.getJSONArray("docs").size() < 10) {
      break;
    }

    // increase the number of the page we're trying to get if there's more articles
    page++;
  }

  // and return our search result
  return result;
}
