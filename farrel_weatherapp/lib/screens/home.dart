import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_api.dart';
import '../widgets/weather_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? weatherData;
  bool isLoading = false;
  String currentCity = "Jakarta";
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredCities = []; 

  static const List<String> daftarKota = [
    'Jakarta', 'Tokyo', 'London', 'Paris', 'Washington D.C.', 'Seoul',
    'Beijing', 'Bangkok', 'Kuala Lumpur', 'Singapore', 'Berlin', 'Rome',
    'Madrid', 'Amsterdam', 'Brasilia', 'Buenos Aires', 'Cairo', 'Pretoria',
    'New Delhi', 'Hanoi', 'Manila', 'Riyadh', 'Moscow', 'Ottawa', 'Mexico City',
    'Sydney', 'Melbourne', 'Bandung', 'Surabaya', 'Medan', 'Makassar'
  ];

  @override
  void initState() {
    super.initState();
    getWeather(currentCity);
  }

  Future<void> getWeather(String city) async {
    setState(() {
      isLoading = true;
      _filteredCities = []; 
    });
    
    Weather? data = await WeatherApi.fetchWeather(city);
    
    setState(() {
      isLoading = false;
    });

    if (data != null) {
      setState(() {
        weatherData = data;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kota "$city" tidak ditemukan!'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() => _filteredCities = []);
      return;
    }
    setState(() {
      _filteredCities = daftarKota
          .where((kota) => kota.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
  }

  BoxDecoration _getBackgroundDecoration(Weather? weather) {
    if (weather == null) return const BoxDecoration(color: Color(0xFF121212));

    String desc = weather.description.toLowerCase();
    double temp = weather.temperature;

    if (desc.contains('thunderstorm') || desc.contains('storm')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1E2C), Color(0xFF111118)], 
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      );
    } 
    else if (desc.contains('rain') || desc.contains('drizzle')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B5563), Color(0xFF1F2937)], 
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
      );
    } 
    else {
      if (temp <= 15) {
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        );
      } else if (temp > 15 && temp < 28) {
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightGreen.shade400],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        );
      } else {
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.redAccent],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('OpenWeather', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _getBackgroundDecoration(weatherData), 
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _focusNode.unfocus();
                    setState(() => _filteredCities = []);
                  },
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : weatherData != null
                            ? WeatherDisplay(weather: weatherData!)
                            : const Text("Data kosong", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
              
              if (_filteredCities.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF303134), 
                    borderRadius: BorderRadius.circular(16), 
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  constraints: const BoxConstraints(maxHeight: 220), 
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.search, color: Colors.grey, size: 20),
                        title: Text(
                          _filteredCities[index],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onTap: () {
                          String selectedCity = _filteredCities[index];
                          _searchController.text = selectedCity;
                          _focusNode.unfocus();
                          getWeather(selectedCity);
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 8),
              
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: _onSearchChanged, 
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Telusuri kota...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70), 
                    filled: true,
                    fillColor: const Color(0xFF303134), 
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), 
                      borderSide: BorderSide.none, 
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      getWeather(value);
                      _focusNode.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}