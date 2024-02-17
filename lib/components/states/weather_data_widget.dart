import "package:flutter/material.dart";
import "package:flutter_weather_app/components/weather_data_block.dart";
import 'package:flutter_weather_app/components/sunrise_sunset_line.dart';
import "package:flutter_weather_app/providers/weather_view_model.dart";
import 'package:auto_size_text_plus/auto_size_text.dart';
import "package:flutter_weather_app/theme/app_colors.dart";

class WeatherDataWidget extends StatelessWidget {
  final WeatherData weatherData;
  final DateTime currentTime = DateTime.now();

  WeatherDataWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: AppColors.appComponentColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.network(
                    'https://openweathermap.org/img/wn/${weatherData.weatherIcon}@4x.png',
                    height: 150,
                    width: 150,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AutoSizeText(weatherData.cityName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 35)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.thermostat),
                            const SizedBox(width: 10),
                            Text("${weatherData.temperature} °C",
                                style: const TextStyle(fontSize: 30)),
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
                    color: AppColors.appTextAndIconColor,
                  ),
                  description: "Feels like",
                  state: "${weatherData.feelsLike} °C"),
              WeatherDataBlock(
                  myIcon: const Icon(
                    Icons.air,
                    color: AppColors.appTextAndIconColor,
                  ),
                  description: "Wind speed",
                  state: "${weatherData.windSpeed} m/s"),
              WeatherDataBlock(
                  myIcon: const Icon(
                    Icons.cloud_outlined,
                    color: AppColors.appTextAndIconColor,
                  ),
                  description: "Cloudiness",
                  state: "${weatherData.cloudyness} %"),
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
                    color: AppColors.appTextAndIconColor,
                  ),
                  description: "Pressure",
                  state: "${weatherData.pressure} hPa"),
              WeatherDataBlock(
                  myIcon: const Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.appTextAndIconColor,
                  ),
                  description: "Humidity",
                  state: "${weatherData.humidity} %"),
              WeatherDataBlock(
                  myIcon: const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.appTextAndIconColor,
                  ),
                  description: "Visibility",
                  state: "${weatherData.visibility} m"),
            ],
          ),
        ),
        if (weatherData.rainAmount != null || weatherData.snowAmount != null)
          const SizedBox(height: 30),
        if (weatherData.rainAmount != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: AppColors.appComponentColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Amount of rain",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      const Text(
                        "During last hour",
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          const Icon(
                            Icons.water_drop_sharp,
                            size: 60,
                          ),
                          Text(
                            "${weatherData.rainAmount.toString()} mm",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (weatherData.rainAmount != null && weatherData.snowAmount != null)
          const SizedBox(height: 30),
        if (weatherData.snowAmount != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: AppColors.appComponentColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Amount of snow",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      const Text(
                        "During last hour",
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          const Icon(
                            Icons.ac_unit,
                            size: 60,
                          ),
                          Text(
                            "${weatherData.snowAmount.toString()} mm",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: AppColors.appComponentColor,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(Icons.wb_twighlight),
                            // Arrow down or up based on if it is night or day
                            Icon(weatherData.sunriseTime
                                            .millisecondsSinceEpoch >
                                        currentTime.millisecondsSinceEpoch ||
                                    weatherData
                                            .sunsetTime.millisecondsSinceEpoch <
                                        currentTime.millisecondsSinceEpoch
                                ? Icons.arrow_downward
                                : Icons.arrow_upward),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.wb_twighlight),
                            // Arrow up or down based on if it is night or day
                            Icon(weatherData.sunriseTime
                                            .millisecondsSinceEpoch >
                                        currentTime.millisecondsSinceEpoch ||
                                    weatherData
                                            .sunsetTime.millisecondsSinceEpoch <
                                        currentTime.millisecondsSinceEpoch
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // "Sunset" or "Sunrise" based on if it is night or day
                        Text(weatherData.sunriseTime.millisecondsSinceEpoch >
                                    currentTime.millisecondsSinceEpoch ||
                                weatherData.sunsetTime.millisecondsSinceEpoch <
                                    currentTime.millisecondsSinceEpoch
                            ? "Sunset"
                            : "Sunrise"),
                        // "Sunrise" or "Sunset" based on if it is night or day
                        Text(weatherData.sunriseTime.millisecondsSinceEpoch >
                                    currentTime.millisecondsSinceEpoch ||
                                weatherData.sunsetTime.millisecondsSinceEpoch <
                                    currentTime.millisecondsSinceEpoch
                            ? "Sunrise"
                            : "Sunset"),
                      ],
                    ),
                  ),
                  SunriseSunsetLine(
                    sunriseTime: weatherData.sunriseTime,
                    sunsetTime: weatherData.sunsetTime,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // SunsetTime or SunriseTime based on if it is night or day
                        Text(
                          weatherData.sunriseTime.millisecondsSinceEpoch >
                                      currentTime.millisecondsSinceEpoch ||
                                  weatherData
                                          .sunsetTime.millisecondsSinceEpoch <
                                      currentTime.millisecondsSinceEpoch
                              ? weatherData.sunsetTime.minute >= 10
                                  ? "${weatherData.sunsetTime.hour}.${weatherData.sunsetTime.minute}"
                                  : "${weatherData.sunsetTime.hour}.0${weatherData.sunsetTime.minute}"
                              : weatherData.sunriseTime.minute >= 10
                                  ? "${weatherData.sunriseTime.hour}.${weatherData.sunriseTime.minute}"
                                  : "${weatherData.sunriseTime.hour}.0${weatherData.sunriseTime.minute}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // SunriseTime or SunsetTime based on if it is night or day
                        Text(
                          weatherData.sunriseTime.millisecondsSinceEpoch >
                                      currentTime.millisecondsSinceEpoch ||
                                  weatherData
                                          .sunsetTime.millisecondsSinceEpoch <
                                      currentTime.millisecondsSinceEpoch
                              ? weatherData.sunriseTime.minute >= 10
                                  ? "${weatherData.sunriseTime.hour}.${weatherData.sunriseTime.minute}"
                                  : "${weatherData.sunriseTime.hour}.0${weatherData.sunriseTime.minute}"
                              : weatherData.sunsetTime.minute >= 10
                                  ? "${weatherData.sunsetTime.hour}.${weatherData.sunsetTime.minute}"
                                  : "${weatherData.sunsetTime.hour}.0${weatherData.sunsetTime.minute}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }
}
