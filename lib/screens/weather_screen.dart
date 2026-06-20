import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weather;
  bool loading = true;

  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [
    "Kathmandu",
    "Pokhara",
    "Okhaldhunga",
    "Solukhumbu",
  ];
  String currentCity = "Kathmandu";

  // Modern Color Palette (White and Deep Blue mix)
  static const Color primaryBlue = Color(0xFF0A192F); // Deep Navy background
  static const Color accentBlue = Color(0xFF172A45); // Card overlay blue
  static const Color cleanWhite = Colors.white;
  static const Color mutedWhite = Colors.white70;

  @override
  void initState() {
    super.initState();
    fetchWeather(currentCity);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      loading = true;
    });

    final apiKey = "1550fe214b57092dcab8f2a81f224a11";
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=${Uri.encodeComponent(city)}&appid=$apiKey&units=metric';

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        setState(() {
          weather = jsonDecode(res.body);
          currentCity = weather!['name'];

          if (!_searchHistory.contains(currentCity)) {
            _searchHistory.insert(0, currentCity);
          }
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("City '$city' not found.")));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. Modern Header Title
              const Text(
                "Weather Studio",
                style: TextStyle(
                  color: cleanWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Modern Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(color: cleanWhite),
                decoration: InputDecoration(
                  hintText: "Search city...",
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: mutedWhite,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: accentBlue.withOpacity(0.7),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: cleanWhite.withOpacity(0.08)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: cleanWhite.withOpacity(0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: cleanWhite, width: 1.5),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    fetchWeather(value.trim());
                    _searchController.clear();
                  }
                },
              ),
              const SizedBox(height: 15),

              // 3. Horizontal History Pill Tags
              if (_searchHistory.isNotEmpty)
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _searchHistory.length,
                    itemBuilder: (context, index) {
                      final city = _searchHistory[index];
                      final isSelected =
                          city.toLowerCase() == currentCity.toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => fetchWeather(city),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? cleanWhite : accentBlue,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? cleanWhite
                                    : cleanWhite.withOpacity(0.05),
                              ),
                            ),
                            child: Text(
                              city,
                              style: TextStyle(
                                color: isSelected ? primaryBlue : mutedWhite,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const Spacer(flex: 1),

              // 4. Main Glassmorphic Panel Layout
              Center(
                child: loading
                    ? const CircularProgressIndicator(
                        color: cleanWhite,
                        strokeWidth: 3,
                      )
                    : weather == null
                    ? const Text(
                        "Failed to retrieve data",
                        style: TextStyle(color: mutedWhite, fontSize: 16),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: cleanWhite.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: cleanWhite.withOpacity(0.12),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentCity.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: mutedWhite,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${weather!['main']['temp'].toStringAsFixed(1)}°",
                                  style: const TextStyle(
                                    fontSize: 76,
                                    fontWeight: FontWeight.w200,
                                    color: cleanWhite,
                                    letterSpacing: -2,
                                  ),
                                ),
                                Text(
                                  weather!['weather'][0]['main']
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: cleanWhite,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Divider(
                                    color: Colors.white10,
                                    height: 1,
                                  ),
                                ),

                                // Split Layout for Metrics
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildMetricColumn(
                                      Icons.water_drop_outlined,
                                      "${weather!['main']['humidity']}%",
                                      "HUMIDITY",
                                    ),
                                    _buildMetricColumn(
                                      Icons.air_rounded,
                                      "${weather!['wind']['speed']} m/s",
                                      "WIND",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: mutedWhite, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: cleanWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
