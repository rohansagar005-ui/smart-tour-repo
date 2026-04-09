import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobiletask/model/wheather_model.dart';

void main (){
  final repo = WeatherRepository("10a318d7a7c243ae845103849260904");
  repo.fetchMultipleCities(["Delhi", "Mumbai", "Jaipur", "Bangalore", "Chennai",
    "Kolkata", "Hyderabad", "Pune", "Goa", "Chandigarh",
    "Ahmedabad", "Surat", "Lucknow", "Kanpur", "Nagpur",
    "Indore", "Bhopal", "Patna", "Ranchi", "Raipur",
    "Varanasi", "Amritsar", "Agra", "Shimla", "Manali",
    "Dehradun", "Udaipur", "Jodhpur", "Mysore", "Coimbatore",
    "Trivandrum", "Visakhapatnam"]);

  print(repo);
}

class WeatherRepository {
  final String apiKey;
  final String baseUrl = 'http://api.weatherapi.com/v1';

  WeatherRepository(this.apiKey);

  Future<Weather> fetchSingleCity(String city) async {
    final url = Uri.parse(
      '$baseUrl/current.json?key=$apiKey&q=$city&aqi=no',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Weather.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to fetch $city: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future<List<Weather>> fetchMultipleCities(List<String> cities) async {
    List<Weather> results = [];

    print("[MULTI FETCH] Starting for cities: $cities");

    for (String city in cities) {
      try {
        print("Fetching: $city");

        final weather = await fetchSingleCity(city);
        results.add(weather);
      } catch (e) {
        print("$city due to error: $e");
      }
    }

    print(": ${results.length}/${cities.length}");

    return results;
  }
}