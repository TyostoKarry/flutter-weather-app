import "package:flutter/material.dart";
import 'package:auto_size_text_plus/auto_size_text.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';

class WeatherErrorWidget extends StatelessWidget {
  final String line2Text;

  WeatherErrorWidget({required this.line2Text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 100),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            color: AppColors.appComponentColor,
            width: MediaQuery.of(context).size.width - 40,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  size: 200,
                ),
                AutoSizeText(
                  "Error while loading",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.appTextAndIconColor, fontSize: 30),
                ),
                AutoSizeText(
                  line2Text,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.appTextAndIconColor, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
