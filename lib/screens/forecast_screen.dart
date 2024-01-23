import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_app/components/coordinate_provider.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import "dart:convert";

class ForecastData {
  final String timestamp;
  final String description;
  final double temperature;
  final double windSpeed;
  final String icon;

  ForecastData(this.timestamp, this.description, this.temperature,
      this.windSpeed, this.icon);
}

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  String? apiKey = dotenv.env['API_KEY'] ?? "";
  late List<ForecastData> weatherForecast;
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

    setState(() {
      weatherForecast = [];
    });
    if (lat == 0 && lon == 0) return;
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        cityName = weatherData["city"]["name"];
        weatherForecast = (weatherData["list"] as List).map((item) {
          return ForecastData(
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
        title: Text(
          cityName,
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 27, 30, 35),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 30, 35),
      body: ListView.builder(
        itemCount: weatherForecast.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 74, 120, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Image.network(
                  'https://openweathermap.org/img/wn/${weatherForecast[index].icon}@4x.png'),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.calendar_month, color: Colors.black),
                        Text(
                          "${weatherForecast[index].timestamp.substring(8, 10)}.${weatherForecast[index].timestamp.substring(5, 7)}.${weatherForecast[index].timestamp.substring(0, 4)}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.schedule, color: Colors.black),
                        Text(
                          weatherForecast[index].timestamp.substring(11, 13),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                children: <Widget>[
                  Text(
                    weatherForecast[index].description,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.thermostat, color: Colors.black),
                          Text(
                            "${weatherForecast[index].temperature} °C",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.air, color: Colors.black),
                          Text(
                            "${weatherForecast[index].windSpeed} m/s",
                            style: const TextStyle(color: Colors.black),
                          ),
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
