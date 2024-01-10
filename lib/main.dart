import 'package:flutter/material.dart';
import 'package:pagination/products_screen.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

void main() {
  runApp(EasyDynamicThemeWidget(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light
    );

    final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.indigo,
      brightness: Brightness.dark,

    );
    return MaterialApp(
      title: 'ProductsList',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: EasyDynamicTheme.of(context).themeMode!,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
