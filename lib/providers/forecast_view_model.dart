import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

// All the possible states of forecast_screen
enum ForecastViewState {
  error,
  apiKeyError,
  loading,
  noForecastData,
  forecastData,
}

class ForecastData {
  String timestamp = "";
  String description = "";
  double temperature = 0;
  double windSpeed = 0;
  String icon = "";
  int rainProbability = 0;
  double? rainAmount;
  double? snowAmount;

  ForecastData(
      {required this.timestamp,
      required this.description,
      required this.temperature,
      required this.windSpeed,
      required this.icon,
      required this.rainProbability,
      this.rainAmount,
      this.snowAmount});
}

class ForecastViewModel extends ChangeNotifier {
  String? apiKey;
  ForecastViewState _forecastViewState = ForecastViewState.loading;
  String? _forecastCity;
  List<ForecastData> _forecastList = [];

  ForecastViewModel() {
    _loadApiKey();
  }

  ForecastViewState get state => _forecastViewState;
  String? get forecastCity => _forecastCity;
  List<ForecastData> get forecastList => _forecastList;

  Future<void> _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('api_key') ?? "";
    notifyListeners();
  }

  void fetchForecastWithCoordinates(double? lat, double? lon) async {
    await _loadApiKey();
    if (apiKey == null || apiKey!.isEmpty) {
      _forecastViewState = ForecastViewState.apiKeyError;
      notifyListeners();
      return;
    }
    _forecastViewState = ForecastViewState.loading;
    try {
      Uri uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey");
      var response = await http.get(uri);
      if (response.statusCode == 401) {
        _forecastViewState = ForecastViewState.apiKeyError;
        notifyListeners();
        return;
      }
      notifyListeners();
      if ((lat == 0 && lon == 0) || (lat == null || lon == null)) {
        _forecastViewState = ForecastViewState.noForecastData;
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        var weatherData = json.decode(response.body);
        _forecastCity = weatherData["city"]["name"];
        _forecastList = (weatherData["list"] as List).map((item) {
          double? rainAmount;
          double? snowAmount;

          // Check and safely access "3h" for rain
          if (item.containsKey("rain") && item["rain"].containsKey("3h")) {
            rainAmount = item["rain"]["3h"].toDouble();
          }

          // Check and safely access "3h" for snow
          if (item.containsKey("snow") && item["snow"].containsKey("3h")) {
            snowAmount = item["snow"]["3h"].toDouble();
          }

          return ForecastData(
              timestamp: item["dt_txt"],
              description: item["weather"][0]["description"],
              temperature: item["main"]["temp"].toDouble(),
              windSpeed: item["wind"]["speed"].toDouble(),
              icon: item["weather"][0]["icon"],
              rainProbability: (item["pop"].toDouble() * 100).round(),
              rainAmount: rainAmount,
              snowAmount: snowAmount);
        }).toList();
        _forecastViewState = ForecastViewState.forecastData;
        notifyListeners();
      } else {
        _forecastViewState = ForecastViewState.noForecastData;
        notifyListeners();
      }
    } catch (error) {
      _forecastViewState = ForecastViewState.error;
      notifyListeners();
    }
  }
}
