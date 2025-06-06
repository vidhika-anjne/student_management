import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiHelper {
  static String getEndpoint(String endpoint) {
    final baseUrl = dotenv.env['BASE_URL']!;
    return "$baseUrl/$endpoint";
  }
}
