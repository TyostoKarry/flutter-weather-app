import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_app/screens/forecast_screen.dart';
import 'package:flutter_weather_app/screens/weather_screen.dart';
import 'package:flutter_weather_app/components/coordinate_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  // Load the environment variables from the .env file
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoordinateProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(
            () {
              currentPageIndex = index;
            },
          );
        },
        indicatorColor: const Color.fromARGB(255, 74, 120, 255),
        backgroundColor: const Color.fromARGB(255, 27, 30, 35),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.sunny),
            label: 'Weather',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Forecast',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const [
          WeatherScreen(),
          ForecastScreen(),
        ],
      ),
    );
  }
}
