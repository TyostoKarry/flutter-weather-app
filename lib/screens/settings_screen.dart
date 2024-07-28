import 'package:flutter/material.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String apiKey = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBackgroundColor,
      ),
      backgroundColor: AppColors.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60),
            TextField(
              cursorColor: AppColors.appComponentColor,
              decoration: const InputDecoration(
                labelText: "OpenWeatherApi apiKey",
                labelStyle: TextStyle(color: AppColors.appTextFieldColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appTextFieldColor),
                ),
              ),
              style: const TextStyle(color: AppColors.appTextFieldColor),
              onChanged: (value) {
                apiKey = value;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appClicableButtonColor),
                onPressed: () {},
                child: const Text(
                  "Apply apiKey",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColors.appClickableButtonTextAndIconColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
