import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_app/components/coordinate_provider.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'dart:developer';

class forecastData {
  final String timestamp;
  final String description;
  final double temperature;
  final double windSpeed;
  final String icon;

  forecastData(this.timestamp, this.description, this.temperature,
      this.windSpeed, this.icon);
}

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  String? apiKey = dotenv.env['API_KEY'] ?? "";
  late List<forecastData> weatherForecast;
  String cityName = "";

  @override
  void initState() {
    super.initState();
    fetchWithCoords();

    // Runs fetchWithCoords when coordinate data changes on weather_screen
    final coordinateProvider = context.read<CoordinateProvider>();
    coordinateProvider.addListener(fetchWithCoords);
  }

  void fetchWithCoords() async {
    final coordinateProvider = context.read<CoordinateProvider>();

    double lat = coordinateProvider.lat;
    double lon = coordinateProvider.lon;

    log("lat: $lat, lon: $lon");

    setState(() {
      weatherForecast = [];
    });
    if (lat == 0 && lon == 0) return;
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey");
    var response = await http.get(uri);
    log("${response.statusCode}");
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      log("$weatherData");
      setState(() {
        cityName = weatherData["city"]["name"];
        weatherForecast = (weatherData["list"] as List).map((item) {
          return forecastData(
            item["dt_txt"],
            item["weather"][0]["description"],
            item["main"]["temp"].toDouble(),
            item["wind"]["speed"].toDouble(),
            item["weather"][0]["icon"],
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName, style: const TextStyle(fontSize: 40)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: weatherForecast.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              leading: Image.network(
                  'https://openweathermap.org/img/wn/${weatherForecast[index].icon}@4x.png'),
              title: Center(
                child: Text(weatherForecast[index].timestamp),
              ),
              subtitle: Column(
                children: [
                  Text(weatherForecast[index].description),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thermostat),
                          Text("${weatherForecast[index].temperature} °C"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.air),
                          Text("${weatherForecast[index].windSpeed} m/s"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}