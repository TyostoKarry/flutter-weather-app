import "package:flutter/material.dart";
import 'package:auto_size_text_plus/auto_size_text.dart';

class NoWeatherDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 100),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            color: const Color.fromARGB(255, 74, 120, 255),
            width: MediaQuery.of(context).size.width - 40,
            height: 300,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cloud_outlined,
                  size: 200,
                ),
                AutoSizeText(
                  "Enter city to",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30),
                ),
                AutoSizeText(
                  "see weather data.",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
