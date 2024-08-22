# Flutter Weather App

A minimal weather app built with Flutter, delivering current weather conditions and forecasts in a clean and simple interface.

## Overview

This weather app is designed to provide users with a simple and intuitive way to check the current weather conditions and forecasts for their location. The app uses the OpenWeatherMap API to retrieve weather data and provides a clean and minimalistic interface for users to view the information.

## Features

- Current weather conditions: temperature, humidity, wind speed, and more
- Forecast: 5-day forecast with temperature, and weather conditions
- Location search: search for weather by city name
- Automatic location detection: app can automatically detect user's location and display weather data
- Unit selection: switch between metric and imperial units
- OpenWeatherMap API key: set your own API key for unlimited requests

## Screens

### Weather Screen

The weather screen displays the current weather and allows the user to:

- Enter a city name to view the weather for a specific location
- Use their current location to view the weather (with location services enabled)
- View the current weather conditions, including:
  - Temperature
  - Wind speed
  - Cloudiness
  - Pressure
  - Humidity
  - Visibility
  - Rain or snow
- View additional information, such as:

  - Sunrise/sunset timer

<div style="display:flex; justify-content:center;">
  <img src="https://i.imgur.com/Cp7qiqJ.jpeg" style="width:25%;">
  &nbsp;
  <img src="https://i.imgur.com/wRIzUsI.jpeg" style="width:25%;">
</div>

### Forecast Screen

The forecast screen displays the weather forecast for the next 5 days in 3h time chuncks. The forecast includes:

- Temperature
- Weather conditions (e.g. sunny, cloudy, rainy)
- Wind speed
- Rain probability
- Rain ammount

<img src="https://i.imgur.com/Y0N2OyF.jpeg" style="width:25%; margin: 0 auto; display: block;">

### Settings Screen

The settings screen allows the user to:

- Switch between Metric and Imperial unit type
- Choose to automatically search for weather on startup by:
  - Specific city
  - Current location
- Set their OpenWeatherMap API key

<img src="https://i.imgur.com/dOcANih.jpeg" style="width:25%; margin: 0 auto; display: block;">

## Installation

1. Clone the repository:

```bash
git clone https://github.com/TyostoKarry/flutter-weather-app.git
```

2. Navigate to the project directory:

```bash
cd flutter-weather-app
```

3. Install the dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Build

### Full APK with all ABIs

To build a full APK with all ABIs, run the following command:

```bash
flutter build apk
```

This will create a single APK file that contains all the necessary architecture-specific code for ARM, ARM64, x86, and x86_64.

### Separate APKs for each ABI

To build separate APKs for each ABI, run the following command:

```bash
flutter build apk --split-per-abi
```

This will create separate APK files for each architecture:

- `app-armeabi-v7a-release.apk` (ARM)
- `app-arm64-v8a-release.apk` (ARM64)
- `app-x86_64-release.apk` (x86_64)

Note that building separate APKs for each ABI can result in smaller APK files, but it may also increase the complexity of your app's distribution and installation process.
