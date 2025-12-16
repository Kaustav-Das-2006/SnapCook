import 'package:flutter/material.dart';
import 'home.dart'; // Import the new file we just made

void main() {
  runApp(const SnapCookApp());
}

class SnapCookApp extends StatelessWidget {
  const SnapCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapCook',
      debugShowCheckedModeBanner: false, // Removes the little "DEBUG" banner
      theme: ThemeData(
        useMaterial3: true,
        // The Warm Chef Theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
          surface: Colors.grey.shade50,
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // This is where we link to the other file
      home: const RecipeScreen(),
    );
  }
}
