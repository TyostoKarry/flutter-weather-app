import 'package:flutter/material.dart';

class SunriseSunsetLine extends StatelessWidget {
  final DateTime sunriseTime;
  final DateTime sunsetTime;

  SunriseSunsetLine(
      {super.key, required this.sunriseTime, required this.sunsetTime});

  final DateTime currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CustomPaint(
            size: const Size(300, 34),
            painter: SunriseSunsetLineDraw(),
          ),
          // Calculates position and uses moon or sun icon based if it is night or day
          sunriseTime.millisecondsSinceEpoch >
                      currentTime.millisecondsSinceEpoch ||
                  sunsetTime.millisecondsSinceEpoch <
                      currentTime.millisecondsSinceEpoch
              ? Positioned(
                  left: calculateIconPosition(
                      sunsetTime,
                      sunriseTime.add(const Duration(days: 1)),
                      currentTime,
                      300),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 74, 120,
                          255), // Set your desired background color
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2), // Adjust padding as needed
                      child: Icon(
                        Icons.dark_mode,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  left: calculateIconPosition(
                      sunriseTime, sunsetTime, currentTime, 300),
                  top: 0.6,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 74, 120,
                          255), // Set your desired background color
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2), // Adjust padding as needed
                      child: Icon(
                        Icons.wb_sunny,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// Draw the line for sunset sunrise
class SunriseSunsetLineDraw extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Calculate the position of the icon based on the current time
double calculateIconPosition(
    DateTime startTime, DateTime endTime, DateTime currentTime, double width) {
  // Location adjusted from width by icon size:s half (-15)
  if (currentTime.millisecondsSinceEpoch <= startTime.millisecondsSinceEpoch) {
    return -15;
  } else if (currentTime.millisecondsSinceEpoch >=
      endTime.millisecondsSinceEpoch) {
    return width - 15;
  } else {
    return ((currentTime.difference(startTime).inMinutes /
                endTime.difference(startTime).inMinutes) *
            width) -
        15;
  }
}
