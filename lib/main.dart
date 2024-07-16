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
        iconTheme:const IconThemeData(
          size: 15,
          color: Colors.grey
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            splashFactory: NoSplash.splashFactory
          )
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.black38,
          selectedItemColor: Colors.lightBlueAccent
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            )
          )
        ),
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
