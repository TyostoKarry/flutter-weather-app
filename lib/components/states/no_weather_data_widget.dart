import "package:flutter/material.dart";
import 'package:auto_size_text_plus/auto_size_text.dart';

class NoWeatherDataWidget extends StatelessWidget {
  final String line1Text;
  final String line2Text;

  NoWeatherDataWidget({required this.line1Text, required this.line2Text});

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.cloud_outlined,
                    size: 200,
                  ),
                  AutoSizeText(
                    line1Text,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                  AutoSizeText(
                    line2Text,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
