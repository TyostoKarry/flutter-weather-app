import "package:flutter/material.dart";
import 'package:flutter_weather_app/providers/forecast_view_model.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';

class ForecastDataWidget extends StatelessWidget {
  final String? cityName;
  final List<ForecastData> forecastList;
  final String temperatureUnit;
  final String windUnit;

  ForecastDataWidget({
    required this.cityName,
    required this.forecastList,
    required this.temperatureUnit,
    required this.windUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityName ?? "Unknown City",
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBackgroundColor,
      ),
      backgroundColor: AppColors.appBackgroundColor,
      body: ListView.builder(
        itemCount: forecastList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
              color: AppColors.appComponentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Container(
                width: 100, // Specify your desired width
                height: 100, // Specify your desired height
                child: Image.network(
                  'https://openweathermap.org/img/wn/${forecastList[index].icon}@4x.png',
                  fit: BoxFit.cover,
                ),
              ),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.schedule,
                            color: AppColors.appTextAndIconColor),
                        Text(
                          forecastList[index].timestamp.substring(11, 13),
                          style: const TextStyle(
                              color: AppColors.appTextAndIconColor),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.calendar_month,
                            color: AppColors.appTextAndIconColor),
                        Text(
                          "${forecastList[index].timestamp.substring(8, 10)}.${forecastList[index].timestamp.substring(5, 7)}.${forecastList[index].timestamp.substring(0, 4)}",
                          style: const TextStyle(
                              color: AppColors.appTextAndIconColor),
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
                    style:
                        const TextStyle(color: AppColors.appTextAndIconColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(Icons.thermostat,
                              color: AppColors.appTextAndIconColor),
                          Text(
                            "${forecastList[index].temperature} $temperatureUnit",
                            style: const TextStyle(
                                color: AppColors.appTextAndIconColor),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.air,
                              color: AppColors.appTextAndIconColor),
                          Text(
                            "${forecastList[index].windSpeed} $windUnit",
                            style: const TextStyle(
                                color: AppColors.appTextAndIconColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (forecastList[index].rainAmount != null &&
                      forecastList[index].snowAmount == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "${forecastList[index].rainProbability}%",
                          style: const TextStyle(
                              color: AppColors.appTextAndIconColor),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.water_drop_sharp,
                                color: AppColors.appTextAndIconColor),
                            Text(
                              "${forecastList[index].rainAmount} mm/3h",
                              style: const TextStyle(
                                  color: AppColors.appTextAndIconColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (forecastList[index].snowAmount != null &&
                      forecastList[index].rainAmount == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "${forecastList[index].rainProbability}%",
                          style: const TextStyle(
                              color: AppColors.appTextAndIconColor),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.ac_unit,
                                color: AppColors.appTextAndIconColor),
                            Text(
                              "${forecastList[index].snowAmount} mm/3h",
                              style: const TextStyle(
                                  color: AppColors.appTextAndIconColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (forecastList[index].snowAmount == null &&
                      forecastList[index].rainAmount == null)
                    SizedBox(
                      height: 24,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              "${forecastList[index].rainProbability}%",
                              style: const TextStyle(
                                  color: AppColors.appTextAndIconColor),
                            ),
                            Text(
                              "Rain probability",
                              style: const TextStyle(
                                  color: AppColors.appTextAndIconColor),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
