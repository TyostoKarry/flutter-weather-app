import 'package:flutter/material.dart';
import 'package:flutter_weather_app/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _apiKeyController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiKey = prefs.getString('api_key') ?? "";
    setState(() {
      _apiKeyController.text = apiKey;
    });
  }

  _saveApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('api_key', _apiKeyController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("API key Saved"),
      ),
    );
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
              controller: _apiKeyController,
              obscureText: _obscureText,
              cursorColor: AppColors.appTextFieldColor,
              decoration: InputDecoration(
                  labelText: "OpenWeatherMap apiKey",
                  labelStyle: TextStyle(color: AppColors.appTextFieldColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appTextFieldColor),
                  ),
                  suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.appTextFieldColor,
                      ))),
              style: const TextStyle(color: AppColors.appTextFieldColor),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appClicableButtonColor),
                onPressed: _saveApiKey,
                child: const Text(
                  "Apply API Key",
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
