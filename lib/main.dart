import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';
import 'package:flutter_weather_app/providers/weather_view_model.dart';
import 'package:flutter_weather_app/providers/forecast_view_model.dart';
import 'package:flutter_weather_app/screens/forecast_screen.dart';
import 'package:flutter_weather_app/screens/weather_screen.dart';
import 'package:provider/provider.dart';

Future main() async {
  // Load the environment variables from the .env file
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => ForecastViewModel()),
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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            // Check if the destination is selected
            if (states.contains(MaterialState.selected)) {
              return TextStyle(
                  color: AppColors
                      .appNavBarTextAndIconColorSelected); // Color for selected state
            }
            return TextStyle(
                color: AppColors
                    .appNavBarTextAndIconColorUnselected); // Color for unselected state
          }),
          iconTheme:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(
                  color: AppColors
                      .appNavBarTextAndIconColorSelected); // Icon color for selected state
            }
            return IconThemeData(
                color: AppColors
                    .appNavBarTextAndIconColorUnselected); // Icon color for unselected state
          }),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: AppColors.appNavBarSelectedIndicatorColor,
          backgroundColor: AppColors.appBottomNavBarColor,
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
