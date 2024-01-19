import "package:flutter/material.dart";

class WeatherDataBlock extends StatelessWidget {
  final Icon myIcon;
  final String description;
  final String state;

  const WeatherDataBlock(
      {Key? key,
      required this.myIcon,
      required this.description,
      required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          myIcon,
          Text(description, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 10),
          Text(state, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}