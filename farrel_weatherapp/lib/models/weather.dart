class Weather {
  final String cityName;
  final double temperature;
  final String iconCode;
  final String description;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.iconCode,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
    );
  }
}