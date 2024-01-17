import 'package:flutter/material.dart';
import 'package:flutter_weather_app/screens/forecast_screen.dart';
import 'package:flutter_weather_app/screens/weather_screen.dart';

void main() {
  runApp(const MainApp());
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
        indicatorColor: Colors.lightBlue,
        backgroundColor: Color.fromARGB(255, 200, 200, 200),
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


/*
class WeatherUI extends StatelessWidget {
  const WeatherUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        const Text("Tampere", style: TextStyle(fontSize: 30)),
        const SizedBox(height: 20),
        Image.network(
          'https://openweathermap.org/img/wn/02d@4x.png',
          height: 200,
          width: 200,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text("12 °C", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: EdgeInsets.only(right: 40),
              child: Text("6 m/s", style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(labelText: "City"),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          backgroundColor: Colors.lightBlue),
                      onPressed: () {},
                      child: const Text("Fetch Weather")),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
*/