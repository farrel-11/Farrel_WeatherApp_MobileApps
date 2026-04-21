import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'animated_cloud.dart'; 

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DynamicWeatherIcon(condition: weather.description), 
        
        const SizedBox(height: 20),
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          '${weather.temperature.round()}°C',
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ],
    );
  }
}