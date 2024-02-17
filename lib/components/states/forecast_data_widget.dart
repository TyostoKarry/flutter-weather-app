import "package:flutter/material.dart";
import 'package:flutter_weather_app/providers/forecast_view_model.dart';

class ForecastDataWidget extends StatelessWidget {
  final String? cityName;
  final List<ForecastData> forecastList;

  ForecastDataWidget({required this.cityName, required this.forecastList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityName ?? "Unknown City",
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 27, 30, 35),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 30, 35),
      body: ListView.builder(
        itemCount: forecastList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 74, 120, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Image.network(
                  'https://openweathermap.org/img/wn/${forecastList[index].icon}@4x.png'),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.calendar_month, color: Colors.black),
                        Text(
                          "${forecastList[index].timestamp.substring(8, 10)}.${forecastList[index].timestamp.substring(5, 7)}.${forecastList[index].timestamp.substring(0, 4)}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.schedule, color: Colors.black),
                        Text(
                          forecastList[index].timestamp.substring(11, 13),
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
                    forecastList[index].description,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.thermostat, color: Colors.black),
                          Text(
                            "${forecastList[index].temperature} °C",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.air, color: Colors.black),
                          Text(
                            "${forecastList[index].windSpeed} m/s",
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
