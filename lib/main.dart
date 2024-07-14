import 'package:flutter/material.dart';
import 'Screans/Splash Screen.dart';

void main() {
  runApp(const MyApp());
}

class AppColors{

  //Custom theme colors for the application
  static const Color primaryColor = Colors.lightBlueAccent;
  static const Color backgroundColor = Colors.white;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor:AppColors.primaryColor,
            background: AppColors.backgroundColor
        ),
        useMaterial3: true,
      ),
      home: const splash_screen(),
    );
  }
}
