import "package:flutter/material.dart";
import 'package:flutter_weather_app/components/states/info_panel_widget.dart';
import 'package:flutter_weather_app/components/states/loading_widget.dart';
import 'package:flutter_weather_app/components/states/weather_data_widget.dart';
import 'package:flutter_weather_app/providers/weather_view_model.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityInput = "";

  // Height of the displayed data container. Is changed accordingly if keyboard is opened and closed
  double keyboardSize = 0;
  // Speed of the container size change. Avoid widget collision.
  int animationSpeed = 0;

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
            animationSpeed = 100;
            keyboardSize = 0;
          });
        });
      }
      if (visible) {
        // Keyboard opened, instant animation to not overlap with keyboard opening
        setState(() {
          animationSpeed = 25;
          keyboardSize = 200;
        });
      }
    });

    // Initial fetch after initial build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherViewModel>(context, listen: false)
          .fetchWeatherDataWithLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: animationSpeed),
            height: MediaQuery.of(context).size.height - 250 - keyboardSize,
            child: SingleChildScrollView(
              child: _buildBodyBasedOnState(weatherViewModel),
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
                      cursorColor: AppColors.appTextFieldColor,
                      decoration: const InputDecoration(
                        labelText: "Enter City",
                        labelStyle:
                            TextStyle(color: AppColors.appTextFieldColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.appTextFieldColor),
                        ),
                      ),
                      style:
                          const TextStyle(color: AppColors.appTextFieldColor),
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
                                  AppColors.appClicableButtonColor),
                          onPressed: () {
                            Provider.of<WeatherViewModel>(context,
                                    listen: false)
                                .fetchWeatherData(cityInput);
                          },
                          child: const Text(
                            "Fetch Weather",
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColors
                                    .appClickableButtonTextAndIconColor),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(80, 60),
                                backgroundColor:
                                    AppColors.appClicableButtonColor),
                            onPressed: () {
                              Provider.of<WeatherViewModel>(context,
                                      listen: false)
                                  .fetchWeatherDataWithLocation();
                            },
                            child: const Icon(
                              Icons.location_on,
                              color:
                                  AppColors.appClickableButtonTextAndIconColor,
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

  Widget _buildBodyBasedOnState(WeatherViewModel weatherViewModel) {
    switch (weatherViewModel.state) {
      case WeatherViewState.loading:
        return LoadingWidget(
          line2Text: "weather data.",
        );
      case WeatherViewState.noWeatherData:
        return InfoPanelWidget(
          icon: Icons.cloud_outlined,
          line1Text: "Enter a city to",
          line2Text: "see weather data.",
        );
      case WeatherViewState.invalidCity:
        return InfoPanelWidget(
          icon: Icons.location_city,
          line1Text: "Entered city does not exist.",
          line2Text: "Please enter valid city input.",
        );
      case WeatherViewState.error:
        return InfoPanelWidget(
          icon: Icons.error_outline,
          line1Text: "Error while loading",
          line2Text: "weather data!",
        );
      case WeatherViewState.apiKeyError:
        return InfoPanelWidget(
          icon: Icons.key_off_outlined,
          line1Text: "Invalid API key!",
          line2Text: "Provide valid API key in settings",
        );
      case WeatherViewState.weatherData:
        return weatherViewModel.weatherData != null
            ? WeatherDataWidget(weatherData: weatherViewModel.weatherData!)
            : InfoPanelWidget(
                icon: Icons.cloud_outlined,
                line1Text: "Enter a city to",
                line2Text: "see weather data.",
              );
      default:
        return InfoPanelWidget(
          icon: Icons.cloud_outlined,
          line1Text: "Enter a city to",
          line2Text: "see weather data.",
        );
    }
  }
}
