import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/complaint_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/request_screen.dart';
import 'screens/timings_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  runApp(const EcoWasteApp());
}

class EcoWasteApp extends StatelessWidget {
  const EcoWasteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoWaste',
      home: const HomeScreen(), // Change to LoginScreen() if needed
    );
  }
}