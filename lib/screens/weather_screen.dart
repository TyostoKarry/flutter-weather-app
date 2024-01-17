import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityInput = "";
  String cityName = "";
  String weatherIcon = "";
  double temperature = 0;
  double windSpeed = 0;

  void fetchWeatherData() async {
    setState(() {
      cityName = "";
      weatherIcon = "";
      temperature = 0;
      windSpeed = 0;
    });
    if (cityInput == "") return;
    Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${cityInput}&units=metric&appid=2f5fbf5c80f0727b778de804be6d4fa8");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var weatherData = json.decode(response.body);
      setState(() {
        cityName = cityInput[0].toUpperCase() + cityInput.substring(1);
        weatherIcon = weatherData["weather"][0]["icon"];
        temperature = weatherData["main"]["temp"];
        windSpeed = weatherData["wind"]["speed"];
      });
    }
    if (response.statusCode == 404) {
      setState(() {
        cityName = "Invalid City!";
        weatherIcon = "";
        temperature = 0;
        windSpeed = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        if (cityName.isNotEmpty)
          Text(cityName, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 20),
        if (weatherIcon.isNotEmpty)
          Image.network(
            'https://openweathermap.org/img/wn/${weatherIcon}@4x.png',
            height: 200,
            width: 200,
          ),
        if (temperature != 0 && windSpeed != 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text("$temperature C",
                    style: const TextStyle(fontSize: 30)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text("$windSpeed m/s",
                    style: const TextStyle(fontSize: 30)),
              ),
            ],
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
                    decoration: const InputDecoration(labelText: "City"),
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
                        backgroundColor: Colors.lightBlue),
                    onPressed: () {
                      fetchWeatherData();
                    },
                    child: const Text("Fetch Weather"),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
