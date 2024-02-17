import "package:flutter/material.dart";
import 'package:auto_size_text_plus/auto_size_text.dart';

class LoadingWidget extends StatelessWidget {
  final String line2Text;

  LoadingWidget({required this.line2Text});

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Transform.scale(
                    scale: 3.0,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 100),
                  AutoSizeText(
                    "Loading",
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
                  SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
