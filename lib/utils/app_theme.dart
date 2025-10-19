import 'package:flutter/material.dart';

class AppGradients {
  const AppGradients._();

  // Unified blue gradient used across the app (same as splash screen)
  static const LinearGradient blueBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D47A1), // deep blue
      Color(0xFF001F5C), // darker blue
      Color(0xFF000D2E), // deepest blue
    ],
    stops: [0.0, 0.7, 1.0],
  );

  // Button gradient: same colors, horizontal flow
  static const LinearGradient blueButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF001F5C),
      Color(0xFF000D2E),
    ],
    stops: [0.0, 0.7, 1.0],
  );
}


