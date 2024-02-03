import 'package:flutter/material.dart';

class SunriseSunsetLine extends StatefulWidget {
  final DateTime sunriseTime;
  final DateTime sunsetTime;

  const SunriseSunsetLine({
    super.key,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  @override
  State<SunriseSunsetLine> createState() => _SunriseSunsetLineState();
}

class _SunriseSunsetLineState extends State<SunriseSunsetLine> {
  late DateTime sunriseTime;
  late DateTime sunsetTime;
  bool day = true;
  final DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Initialize sunrise and sunset times
    sunriseTime = widget.sunriseTime;
    sunsetTime = widget.sunsetTime;

    // Makes sure the current time fits between sunrise and sunset times
    if (currentTime.millisecondsSinceEpoch <=
        sunriseTime.millisecondsSinceEpoch) {
      sunsetTime = sunsetTime.subtract(const Duration(days: 1));
      day = false;
    } else if (currentTime.millisecondsSinceEpoch >=
        sunsetTime.millisecondsSinceEpoch) {
      sunriseTime = sunriseTime.add(const Duration(days: 1));
      day = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width - 100, 34),
            painter: SunriseSunsetLineDraw(),
          ),
          // Calculates position and uses moon or sun icon based if it is day or night
          day
              // Day
              ? Positioned(
                  left: calculateIconPosition(sunriseTime, sunsetTime,
                      currentTime, MediaQuery.of(context).size.width - 100),
                  top: 0.6,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 74, 120, 255),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.wb_sunny,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              // Night
              : Positioned(
                  left: calculateIconPosition(sunsetTime, sunriseTime,
                      currentTime, MediaQuery.of(context).size.width - 100),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 74, 120, 255),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.dark_mode,
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
