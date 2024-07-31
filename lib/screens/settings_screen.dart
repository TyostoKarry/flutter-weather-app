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
  bool _autoSearchLocationOnLaunch = false;
  bool _autoSearchCityOnLaunch = false;
  TextEditingController _autoSearchCityController = TextEditingController();
  bool _useMetricUnits = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiKey = prefs.getString('api_key') ?? "";
    bool autoSearchLocationOnLaunch =
        prefs.getBool('auto_search_location_on_launch') ?? false;
    bool autoSearchCityOnLaunch =
        prefs.getBool('auto_search_city_on_launch') ?? false;
    String autoSearchCity = prefs.getString('auto_search_city') ?? "";
    bool useMetricUnits = prefs.getBool('use_metric_units') ?? true;
    setState(() {
      _apiKeyController.text = apiKey;
      _autoSearchLocationOnLaunch = autoSearchLocationOnLaunch;
      _autoSearchCityOnLaunch = autoSearchCityOnLaunch;
      _autoSearchCityController.text = autoSearchCity;
      _useMetricUnits = useMetricUnits;
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

  _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _toggleAutoSearchLocationOnLaunch(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setBool('auto_search_city_on_launch', false);
      setState(() {
        _autoSearchCityOnLaunch = false;
      });
    }
    prefs.setBool('auto_search_location_on_launch', value);
    setState(() {
      _autoSearchLocationOnLaunch = value;
    });
  }

  _toggleAutoSearchCityOnLaunch(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setBool('auto_search_location_on_launch', false);
      setState(() {
        _autoSearchLocationOnLaunch = false;
      });
    }
    prefs.setBool('auto_search_city_on_launch', value);
    setState(() {
      _autoSearchCityOnLaunch = value;
    });
  }

  _saveAutoSearchCity(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auto_search_city', value);
  }

  _toggleUnits(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('use_metric_units', value);
    setState(() {
      _useMetricUnits = value;
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              SwitchListTile(
                title: Text(
                  _useMetricUnits ? "Metric" : "Imperial",
                  style: TextStyle(
                      fontSize: 15, color: AppColors.settingsTextColor),
                ),
                value: _useMetricUnits,
                onChanged: _toggleUnits,
                activeColor: AppColors.appComponentColor,
                secondary: Text(
                  "Unit Type:",
                  style: TextStyle(
                      fontSize: 15, color: AppColors.settingsTextColor),
                ),
              ),
              SwitchListTile(
                title: Text(
                  "Auto-search location on startup",
                  style: TextStyle(
                      fontSize: 15, color: AppColors.settingsTextColor),
                ),
                value: _autoSearchLocationOnLaunch,
                onChanged: _toggleAutoSearchLocationOnLaunch,
                activeColor: AppColors.appComponentColor,
              ),
              SwitchListTile(
                title: Text(
                  "Auto-search city on startup",
                  style: TextStyle(
                      fontSize: 15, color: AppColors.settingsTextColor),
                ),
                value: _autoSearchCityOnLaunch,
                onChanged: _toggleAutoSearchCityOnLaunch,
                activeColor: AppColors.appComponentColor,
              ),
              TextField(
                controller: _autoSearchCityController,
                cursorColor: _autoSearchCityOnLaunch
                    ? AppColors.appTextFieldColor
                    : AppColors.settingsTextColorDisabled,
                decoration: InputDecoration(
                  labelText: "Auto-search city",
                  labelStyle: TextStyle(
                    color: _autoSearchCityOnLaunch
                        ? AppColors.appTextFieldColor
                        : AppColors.settingsTextColorDisabled,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _autoSearchCityOnLaunch
                          ? AppColors.appTextFieldColor
                          : AppColors.settingsTextColorDisabled,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _autoSearchCityOnLaunch
                          ? AppColors.appTextFieldColor
                          : AppColors.settingsTextColorDisabled,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: _autoSearchCityOnLaunch
                      ? AppColors.appTextFieldColor
                      : AppColors.settingsTextColorDisabled,
                ),
                enabled: _autoSearchCityOnLaunch,
                onChanged: _saveAutoSearchCity,
              ),
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
                    ),
                  ),
                ),
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
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
