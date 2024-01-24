import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_app/components/sunrise_sunset_line.dart';
import "package:flutter_weather_app/components/weather_data_block.dart";
import 'package:flutter_weather_app/components/coordinate_provider.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:auto_size_text_plus/auto_size_text.dart';

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
  DateTime sunriseTime = DateTime(0);
  DateTime sunsetTime = DateTime(0);
  double? lat = 0;
  double? lon = 0;

  DateTime currentTime = DateTime.now();

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

    // Gets weatherData of current location and displays it on screen on startup
    fetchWeatherDataWithLocation();
  }

  void fetchWeatherData() async {
    clearWeatherData();
    if (cityInput == "") return;
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityInput&units=metric&appid=$apiKey");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        cityName = weatherData["name"];
        weatherIcon = weatherData["weather"][0]["icon"].toString();
        temperature = weatherData["main"]["temp"].toDouble();
        feelsLike = weatherData["main"]["feels_like"].toDouble();
        windSpeed = weatherData["wind"]["speed"].toDouble();
        humidity = weatherData["main"]["humidity"].toInt();
        pressure = weatherData["main"]["pressure"].toInt();
        cloudyness = weatherData["clouds"]["all"].toInt();
        visibility = weatherData["visibility"].toInt();
        sunriseTime = DateTime.fromMillisecondsSinceEpoch(
            weatherData["sys"]["sunrise"] * 1000);
        sunsetTime = DateTime.fromMillisecondsSinceEpoch(
            weatherData["sys"]["sunset"] * 1000);
        lat = weatherData["coord"]["lat"].toDouble();
        lon = weatherData["coord"]["lon"].toDouble();
      });
    }
    coordinateUpdater(lat, lon);
    currentTime = DateTime.now();
  }

  void fetchWeatherDataWithLocation() async {
    double? latitude;
    double? longitude;
    // Ask for location permission and if granted save location data
    if (await Permission.location.request().isGranted) {
      LocationData locationData = await Location().getLocation();
      setState(() {
        latitude = _formatDouble(locationData.latitude);
        longitude = _formatDouble(locationData.longitude);
      });
      clearWeatherData();
      if (latitude == null || longitude == null) return;
      Uri uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var weatherData = json.decode(response.body);
        setState(() {
          cityName = weatherData["name"];
          weatherIcon = weatherData["weather"][0]["icon"].toString();
          temperature = weatherData["main"]["temp"].toDouble();
          feelsLike = weatherData["main"]["feels_like"].toDouble();
          windSpeed = weatherData["wind"]["speed"].toDouble();
          humidity = weatherData["main"]["humidity"].toInt();
          pressure = weatherData["main"]["pressure"].toInt();
          cloudyness = weatherData["clouds"]["all"].toInt();
          visibility = weatherData["visibility"].toInt();
          sunriseTime = DateTime.fromMillisecondsSinceEpoch(
              weatherData["sys"]["sunrise"] * 1000);
          sunsetTime = DateTime.fromMillisecondsSinceEpoch(
              weatherData["sys"]["sunset"] * 1000);
          lat = weatherData["coord"]["lat"].toDouble();
          lon = weatherData["coord"]["lon"].toDouble();
        });
      }
      coordinateUpdater(lat, lon);
      currentTime = DateTime.now();
    }
  }

  void clearWeatherData() {
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
      sunriseTime = DateTime(0);
      sunsetTime = DateTime(0);
      lat = 0;
      lon = 0;
    });
  }

  // Formats double? value to 2 decimals
  double? _formatDouble(double? value) {
    if (value != null) {
      return double.parse(value.toStringAsFixed(2));
    }
    return null;
  }

  // Updates global provider with given cordinate data.
  void coordinateUpdater(double? lat, double? lon) {
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
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: AutoSizeText(cityName,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 35)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(Icons.thermostat),
                                        const SizedBox(width: 10),
                                        Text("$temperature °C",
                                            style:
                                                const TextStyle(fontSize: 30)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: const Color.fromARGB(255, 74, 120, 255),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Icon(Icons.wb_twighlight),
                                        // Arrow down or up based on if it is night or day
                                        Icon(sunriseTime.millisecondsSinceEpoch >
                                                    currentTime
                                                        .millisecondsSinceEpoch ||
                                                sunsetTime
                                                        .millisecondsSinceEpoch <
                                                    currentTime
                                                        .millisecondsSinceEpoch
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Icon(Icons.wb_twighlight),
                                        // Arrow up or down based on if it is night or day
                                        Icon(sunriseTime.millisecondsSinceEpoch >
                                                    currentTime
                                                        .millisecondsSinceEpoch ||
                                                sunsetTime
                                                        .millisecondsSinceEpoch <
                                                    currentTime
                                                        .millisecondsSinceEpoch
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // "Sunset" or "Sunrise" based on if it is night or day
                                    Text(sunriseTime.millisecondsSinceEpoch >
                                                currentTime
                                                    .millisecondsSinceEpoch ||
                                            sunsetTime.millisecondsSinceEpoch <
                                                currentTime
                                                    .millisecondsSinceEpoch
                                        ? "Sunset"
                                        : "Sunrise"),
                                    // "Sunrise" or "Sunset" based on if it is night or day
                                    Text(sunriseTime.millisecondsSinceEpoch >
                                                currentTime
                                                    .millisecondsSinceEpoch ||
                                            sunsetTime.millisecondsSinceEpoch <
                                                currentTime
                                                    .millisecondsSinceEpoch
                                        ? "Sunrise"
                                        : "Sunset"),
                                  ],
                                ),
                              ),
                              SunriseSunsetLine(
                                sunriseTime: sunriseTime,
                                sunsetTime: sunsetTime,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // SunsetTime or SunriseTime based on if it is night or day
                                    Text(
                                      sunriseTime.millisecondsSinceEpoch >
                                                  currentTime
                                                      .millisecondsSinceEpoch ||
                                              sunsetTime
                                                      .millisecondsSinceEpoch <
                                                  currentTime
                                                      .millisecondsSinceEpoch
                                          ? sunsetTime.minute >= 10
                                              ? "${sunsetTime.hour}.${sunsetTime.minute}"
                                              : "${sunsetTime.hour}.0${sunsetTime.minute}"
                                          : sunriseTime.minute >= 10
                                              ? "${sunriseTime.hour}.${sunriseTime.minute}"
                                              : "${sunriseTime.hour}.0${sunriseTime.minute}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // SunriseTime or SunsetTime based on if it is night or day
                                    Text(
                                      sunriseTime.millisecondsSinceEpoch >
                                                  currentTime
                                                      .millisecondsSinceEpoch ||
                                              sunsetTime
                                                      .millisecondsSinceEpoch <
                                                  currentTime
                                                      .millisecondsSinceEpoch
                                          ? sunriseTime.minute >= 10
                                              ? "${sunriseTime.hour}.${sunriseTime.minute}"
                                              : "${sunriseTime.hour}.0${sunriseTime.minute}"
                                          : sunsetTime.minute >= 10
                                              ? "${sunsetTime.hour}.${sunsetTime.minute}"
                                              : "${sunsetTime.hour}.0${sunsetTime.minute}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
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
                      cursorColor: const Color.fromARGB(255, 74, 120, 255),
                      decoration: const InputDecoration(
                        labelText: "Enter City",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
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
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width - 130, 60),
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
                        const SizedBox(width: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(80, 60),
                                backgroundColor:
                                    const Color.fromARGB(255, 74, 120, 255)),
                            onPressed: () {
                              fetchWeatherDataWithLocation();
                            },
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.black,
                            )),
                      ],
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
