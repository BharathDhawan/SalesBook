import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Create_Template.dart';
import 'package:flutter_application_1/Pages/Home_Page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'salesbook  App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        '/homepage': (context) => HomePage(),
        '/create_template': (context) => CreateTemplateScreen(),
      },
    );
  }
}
