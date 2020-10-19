class URLEncoder{
  static String encodeURLParameter(String url)=>Uri.encodeFull(url).replaceAll('/', '%2F');
}