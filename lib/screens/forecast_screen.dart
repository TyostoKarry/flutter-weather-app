import "package:flutter/material.dart";
import 'package:flutter_weather_app/components/states/info_panel_widget.dart';
import 'package:flutter_weather_app/components/states/loading_widget.dart';
import 'package:flutter_weather_app/components/states/forecast_data_widget.dart';
import 'package:flutter_weather_app/providers/weather_view_model.dart';
import 'package:flutter_weather_app/providers/forecast_view_model.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    fetchForecastFromViewModel();

    // Runs fetchForecastFromViewModel when coordinate data changes from weather_screen
    final weatherViewModel = context.read<WeatherViewModel>();
    weatherViewModel.addListener(fetchForecastFromViewModel);
  }

  void fetchForecastFromViewModel() async {
    final weatherViewModel = context.read<WeatherViewModel>();

    double? lat = weatherViewModel.lat;
    double? lon = weatherViewModel.lon;

    // Initial fetch after initial build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ForecastViewModel>(context, listen: false)
          .fetchForecastWithCoordinates(lat, lon);
    });
  }

  @override
  Widget build(BuildContext context) {
    final forecastViewModel = Provider.of<ForecastViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: Center(
        child: _buildBodyBasedOnState(forecastViewModel, weatherViewModel),
      ),
    );
  }

  Widget _buildBodyBasedOnState(
      ForecastViewModel forecastViewModel, WeatherViewModel weatherViewModel) {
    if (forecastViewModel.state == ForecastViewState.loading ||
        weatherViewModel.state == WeatherViewState.loading) {
      return LoadingWidget(
        line2Text: "forecast data.",
      );
    }
    if (forecastViewModel.state == ForecastViewState.error ||
        weatherViewModel.state == WeatherViewState.error) {
      return InfoPanelWidget(
        icon: Icons.error_outline,
        line1Text: "Error while loading",
        line2Text: "forecast data!",
      );
    }

    switch (forecastViewModel.state) {
      case ForecastViewState.loading:
        return LoadingWidget(
          line2Text: "forecast data.",
        );
      case ForecastViewState.noForecastData:
        return InfoPanelWidget(
          icon: Icons.cloud_outlined,
          line1Text: "Enter a city in Weather screen",
          line2Text: "to see forecast data.",
        );
      case ForecastViewState.error:
        return InfoPanelWidget(
          icon: Icons.error_outline,
          line1Text: "Error while loading",
          line2Text: "forecast data!",
        );
      case ForecastViewState.apiKeyError:
        return InfoPanelWidget(
          icon: Icons.key_off_outlined,
          line1Text: "Invalid API key!",
          line2Text: "Provide valid API key in settings",
        );
      case ForecastViewState.forecastData:
        return forecastViewModel.forecastList.length != 0
            ? ForecastDataWidget(
                cityName: forecastViewModel.forecastCity,
                forecastList: forecastViewModel.forecastList,
                temperatureUnit: forecastViewModel.temperatureUnit,
                windUnit: forecastViewModel.windUnit,
              )
            : InfoPanelWidget(
                icon: Icons.cloud_outlined,
                line1Text: "Enter a city in Weather screen",
                line2Text: "to see forecast data.",
              );
      default:
        return InfoPanelWidget(
          icon: Icons.cloud_outlined,
          line1Text: "Enter a city in Weather screen",
          line2Text: "to see forecast data.",
        );
    }
  }
}
