import "package:flutter/material.dart";
import "package:flutter_weather_app/theme/app_colors.dart";

class WeatherDataBlock extends StatelessWidget {
  final Icon myIcon;
  final String description;
  final String state;

  const WeatherDataBlock(
      {super.key,
      required this.myIcon,
      required this.description,
      required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.appComponentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          myIcon,
          Text(
            description,
            style: const TextStyle(
                fontSize: 13, color: AppColors.appTextAndIconColor),
          ),
          const SizedBox(width: 10),
          Text(
            state,
            style: const TextStyle(
                fontSize: 18, color: AppColors.appTextAndIconColor),
          ),
        ],
      ),
    );
  }
}
