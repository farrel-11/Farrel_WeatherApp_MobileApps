import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApi {
  static const String apiKey = "c4ce4808c8cc013e0b0b78b9f3d2e0a0";

  static Future<Weather?> fetchWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'); // units=metric agar suhu dalam Celcius

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        return null; 
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }
}