import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:flutter_weather_app/components/weather_data_block.dart";
import 'package:flutter_weather_app/components/coordinate_provider.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? apiKey = dotenv.env['API_KEY'] ?? "";

  // Height of the displayed data container. Is changed accordingly if keyboard is opened and closed
  double keyboardSize = 0;

  // Data gained from the openweathermap API
  String cityInput = "";
  String cityName = "";
  String weatherIcon = "";
  double temperature = 0;
  double feelsLike = 0;
  double windSpeed = 0;
  int humidity = 0;
  int pressure = 0;
  int cloudyness = 0;
  int visibility = 0;
  double lat = 0;
  double lon = 0;

  @override
  void initState() {
    super.initState();

    // Observe keyboard visibility changes
    KeyboardVisibilityController().onChange.listen((bool visible) {
      // Update keyboardSize based on visibility
      if (!visible) {
        // Keyboard closed, delay the animation to not overlap with closing keyboard
        Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            keyboardSize = 0;
          });
        });
      }
      if (visible) {
        // Keyboard opened, instant animation to not overlap with keyboard opening
        setState(() {
          keyboardSize = 200;
        });
      }
    });
  }

  void fetchWeatherData() async {
    setState(() {
      cityName = "";
      weatherIcon = "";
      temperature = 0;
      feelsLike = 0;
      windSpeed = 0;
      humidity = 0;
      pressure = 0;
      cloudyness = 0;
      visibility = 0;
      lat = 0;
      lon = 0;
    });
    if (cityInput == "") return;
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityInput&units=metric&appid=$apiKey");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        cityName = cityInput[0].toUpperCase() + cityInput.substring(1);
        weatherIcon = weatherData["weather"][0]["icon"].toString();
        temperature = weatherData["main"]["temp"].toDouble();
        feelsLike = weatherData["main"]["feels_like"].toDouble();
        windSpeed = weatherData["wind"]["speed"].toDouble();
        humidity = weatherData["main"]["humidity"].toInt();
        pressure = weatherData["main"]["pressure"].toInt();
        cloudyness = weatherData["clouds"]["all"].toInt();
        visibility = weatherData["visibility"].toInt();
        lat = weatherData["coord"]["lat"].toDouble();
        lon = weatherData["coord"]["lon"].toDouble();
      });
    }
    coordinateUpdater(lat, lon);
  }

  void coordinateUpdater(double lat, double lon) {
    Provider.of<CoordinateProvider>(context, listen: false)
        .updateCoordinates(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 30, 35),
      body: Column(
        children: <Widget>[
          if (weatherIcon.isNotEmpty &&
              cityName.isNotEmpty &&
              temperature != 0 &&
              windSpeed != 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: MediaQuery.of(context).size.height - 250 - keyboardSize,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: const Color.fromARGB(255, 74, 120, 255),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.network(
                                'https://openweathermap.org/img/wn/$weatherIcon@4x.png',
                                height: 150,
                                width: 150,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(cityName,
                                      style: const TextStyle(fontSize: 35)),
                                  Row(
                                    children: [
                                      const Icon(Icons.thermostat),
                                      const SizedBox(width: 10),
                                      Text("$temperature °C",
                                          style: const TextStyle(fontSize: 30)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        WeatherDataBlock(
                            myIcon: const Icon(
                              Icons.thermostat,
                              color: Colors.black,
                            ),
                            description: "Feels like",
                            state: "$feelsLike °C"),
                        WeatherDataBlock(
                            myIcon: const Icon(
                              Icons.air,
                              color: Colors.black,
                            ),
                            description: "Wind speed",
                            state: "$windSpeed m/s"),
                        WeatherDataBlock(
                            myIcon: const Icon(
                              Icons.cloud_outlined,
                              color: Colors.black,
                            ),
                            description: "Cloudiness",
                            state: "$cloudyness %"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        WeatherDataBlock(
                            myIcon: const Icon(
                              Icons.compress,
                              color: Colors.black,
                            ),
                            description: "Pressure",
                            state: "$pressure hPa"),
                        WeatherDataBlock(
                            myIcon: const Icon(
                              Icons.water_drop_outlined,
                              color: Colors.black,
                            ),
                            description: "Humidity",
                            state: "$humidity %"),
                        WeatherDataBlock(
                            myIcon: const Icon(
                              Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                            description: "Visibility",
                            state: "$visibility m"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Enter City",
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        cityInput = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          backgroundColor:
                              const Color.fromARGB(255, 74, 120, 255)),
                      onPressed: () {
                        fetchWeatherData();
                      },
                      child: const Text(
                        "Fetch Weather",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
