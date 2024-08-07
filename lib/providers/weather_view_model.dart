import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import "package:shared_preferences/shared_preferences.dart";

// All the possible states of weather_screen
enum WeatherViewState {
  error,
  apiKeyError,
  invalidCity,
  loading,
  noWeatherData,
  weatherData,
}

class WeatherData {
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
  DateTime currentTime = DateTime.now();
  double? rainAmount;
  double? snowAmount;

  WeatherData(
      {required this.cityName,
      required this.weatherIcon,
      required this.temperature,
      required this.feelsLike,
      required this.windSpeed,
      required this.cloudyness,
      required this.pressure,
      required this.humidity,
      required this.visibility,
      this.rainAmount,
      this.snowAmount,
      required this.sunriseTime,
      required this.sunsetTime,
      required this.currentTime});
}

class WeatherViewModel extends ChangeNotifier {
  String? apiKey;
  bool useMetricUnits = true;
  String? unitType;
  WeatherViewState _weatherViewState = WeatherViewState.loading;
  WeatherData? _weatherData;
  double? _lat = 0;
  double? _lon = 0;
  bool autoSearchLocationOnLaunch = false;
  bool autoSearchCityOnLaunch = false;
  String autoSearchCity = "";

  WeatherViewModel() {
    _loadApiKeyAndUnitType();
    _loadPreferences();
  }

  WeatherViewState get state => _weatherViewState;
  WeatherData? get weatherData => _weatherData;
  double? get lat => _lat;
  double? get lon => _lon;

  Future<void> _loadApiKeyAndUnitType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('api_key') ?? "";
    useMetricUnits = prefs.getBool('use_metric_units') ?? true;
    if (useMetricUnits) {
      unitType = "metric";
    } else {
      unitType = "imperial";
    }
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoSearchLocationOnLaunch =
        prefs.getBool('auto_search_location_on_launch') ?? false;
    autoSearchCityOnLaunch =
        prefs.getBool('auto_search_city_on_launch') ?? false;
    autoSearchCity = prefs.getString('auto_search_city') ?? "";

    if (autoSearchLocationOnLaunch) {
      fetchWeatherDataWithLocation();
    } else if (autoSearchCityOnLaunch) {
      fetchWeatherData(autoSearchCity);
    } else {
      _weatherViewState = WeatherViewState.noWeatherData;
      notifyListeners();
    }
  }

  String get temperatureUnit => useMetricUnits ? "°C" : "°F";
  String get windUnit => useMetricUnits ? "m/s" : "mph";
  String get visibilityUnit => useMetricUnits ? "m" : "mi";

  // Weather data fetch with city name input
  void fetchWeatherData(cityInput) async {
    await _loadApiKeyAndUnitType();
    if (apiKey == null || apiKey!.isEmpty) {
      _weatherViewState = WeatherViewState.apiKeyError;
      notifyListeners();
      return;
    }
    _weatherViewState = WeatherViewState.loading;
    _lat = null;
    _lon = null;
    notifyListeners();
    try {
      Uri uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityInput&units=$unitType&appid=$apiKey");
      var response = await http.get(uri);
      if (response.statusCode == 401) {
        _weatherViewState = WeatherViewState.apiKeyError;
        notifyListeners();
        return;
      }
      if (cityInput == "") {
        _weatherViewState = WeatherViewState.noWeatherData;
        _lat = null;
        _lon = null;
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _weatherData = WeatherData(
          cityName: data["name"],
          weatherIcon: data["weather"][0]["icon"].toString(),
          temperature: data["main"]["temp"].toDouble(),
          feelsLike: data["main"]["feels_like"].toDouble(),
          windSpeed: data["wind"]["speed"].toDouble(),
          humidity: data["main"]["humidity"].toInt(),
          pressure: data["main"]["pressure"].toInt(),
          cloudyness: data["clouds"]["all"].toInt(),
          visibility: data["visibility"].toInt(),
          sunriseTime: DateTime.fromMillisecondsSinceEpoch(
              data["sys"]["sunrise"] * 1000),
          sunsetTime:
              DateTime.fromMillisecondsSinceEpoch(data["sys"]["sunset"] * 1000),
          currentTime: DateTime.now(),
        );
        if (data["rain"] != null && data["rain"].containsKey("1h")) {
          _weatherData?.rainAmount = _formatDouble(data["rain"]["1h"]);
        }
        if (data["snow"] != null && data["snow"].containsKey("1h")) {
          _weatherData?.snowAmount = _formatDouble(data["snow"]["1h"]);
        }
        _lat = data["coord"]["lat"].toDouble();
        _lon = data["coord"]["lon"].toDouble();
        _weatherViewState = WeatherViewState.weatherData;
        notifyListeners();
      } else {
        _weatherViewState = WeatherViewState.invalidCity;
        _lat = null;
        _lon = null;
        notifyListeners();
      }
    } catch (error) {
      _weatherViewState = WeatherViewState.error;
      _lat = null;
      _lon = null;
      notifyListeners();
    }
  }

// Weather data fetch with users current location
  void fetchWeatherDataWithLocation() async {
    await _loadApiKeyAndUnitType();
    if (apiKey == null || apiKey!.isEmpty) {
      _weatherViewState = WeatherViewState.apiKeyError;
      notifyListeners();
      return;
    }
    _weatherViewState = WeatherViewState.loading;
    _lat = null;
    _lon = null;
    notifyListeners();
    double? latitude;
    double? longitude;
    // Ask for location permission and if granted save location data
    if (await Permission.location.request().isGranted) {
      try {
        LocationData locationData = await Location().getLocation();
        latitude = _formatDouble(locationData.latitude);
        longitude = _formatDouble(locationData.longitude);
        if (latitude == null || longitude == null) {
          _weatherViewState = WeatherViewState.noWeatherData;
          _lat = null;
          _lon = null;
          notifyListeners();
          return;
        }
        Uri uri = Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$unitType&appid=$apiKey");
        var response = await http.get(uri);
        if (response.statusCode == 401) {
          _weatherViewState = WeatherViewState.apiKeyError;
          notifyListeners();
          return;
        }
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          _weatherData = WeatherData(
            cityName: data["name"],
            weatherIcon: data["weather"][0]["icon"].toString(),
            temperature: data["main"]["temp"].toDouble(),
            feelsLike: data["main"]["feels_like"].toDouble(),
            windSpeed: data["wind"]["speed"].toDouble(),
            humidity: data["main"]["humidity"].toInt(),
            pressure: data["main"]["pressure"].toInt(),
            cloudyness: data["clouds"]["all"].toInt(),
            visibility: data["visibility"].toInt(),
            sunriseTime: DateTime.fromMillisecondsSinceEpoch(
                data["sys"]["sunrise"] * 1000),
            sunsetTime: DateTime.fromMillisecondsSinceEpoch(
                data["sys"]["sunset"] * 1000),
            currentTime: DateTime.now(),
          );
          if (data["rain"] != null && data["rain"].containsKey("1h")) {
            _weatherData?.rainAmount = _formatDouble(data["rain"]["1h"]);
          }
          if (data["snow"] != null && data["snow"].containsKey("1h")) {
            _weatherData?.snowAmount = _formatDouble(data["snow"]["1h"]);
          }
          _lat = data["coord"]["lat"].toDouble();
          _lon = data["coord"]["lon"].toDouble();
          _weatherViewState = WeatherViewState.weatherData;
          notifyListeners();
        } else {
          _weatherViewState = WeatherViewState.error;
          _lat = null;
          _lon = null;
          notifyListeners();
        }
      } catch (error) {
        _weatherViewState = WeatherViewState.error;
        _lat = null;
        _lon = null;
        notifyListeners();
      }
    }
  }

  // Formats double? value to 2 decimals
  double? _formatDouble(double? value) {
    if (value != null) {
      return double.parse(value.toStringAsFixed(2));
    }
    return null;
  }
}
