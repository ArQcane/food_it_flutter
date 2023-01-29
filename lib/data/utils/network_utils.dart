class NetworkUtils {
  static const String baseUrl = "http://10.0.2.2:8080";
  final String path;

  NetworkUtils({required this.path});

  Uri createUrl({String endpoint = ""}) {
    return Uri.https(baseUrl, "$path$endpoint");
  }

  Map<String, String> createAuthorizationHeader(String token) {
    return {
      "token": "Bearer $token",
    };
  }
}