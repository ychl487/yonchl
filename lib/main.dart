import 'package:flutter/material.dart';
import 'home_view.dart';

void main() {
  runApp(ChanBrowserApp());
}

class ChanBrowserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4chan Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,  // Dark theme
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      home: HomeView(),  // Start at the home view
    );
  }
}
