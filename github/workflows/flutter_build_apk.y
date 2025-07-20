name: Build Flutter APK

on:
  push:
    branches:
      - main  # أو غيّرها للفرع اللي تشتغل عليه

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.13.0'  # غيّرها حسب نسختك

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --debug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: app-debug.apk
          path: build/app/outputs/flutter-apk/app-debug.apk
