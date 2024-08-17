import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  final String baseurl =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin";
  final String baseurl2 =
      "https://prereg.ex.api.ampiy.com/prices?param1=value1&param2=value2";

  Future getCrypt() async {
    try {
      final response = await http.get(Uri.parse(baseurl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found: ${response.request?.url}");
      } else {
        throw Exception("Failed to load chart data: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
