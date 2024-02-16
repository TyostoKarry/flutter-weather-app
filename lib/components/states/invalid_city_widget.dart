import "package:flutter/material.dart";
import 'package:auto_size_text_plus/auto_size_text.dart';

class InvalidCityWidget extends StatelessWidget {
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_city,
                    size: 200,
                  ),
                  AutoSizeText(
                    "Entered city does not exist.",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                  AutoSizeText(
                    "Please enter valid city input.",
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
