import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueWay',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
