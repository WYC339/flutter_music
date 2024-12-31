class Constants {
  Constants._();

  static const String _baseUrl = "https://itunes.apple.com/";

  static String baseUrl = getBaseUrl();
}

String getBaseUrl() {
  return Constants._baseUrl;
}
