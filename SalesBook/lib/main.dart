import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Create_Template.dart';
import 'package:flutter_application_1/Pages/Home_Page.dart';
import 'package:flutter_application_1/Pages/Save_Template.dart';
import 'package:flutter_application_1/Provider/DataSource_Provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAqMT2g-8PP7V6wZxqEfevGi07e4PffVZw",
          appId: "1:1090160258116:web:db9d41154720a1afce2011",
          messagingSenderId: "1090160258116",
          projectId: "propertycrudapp"));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatasourceProvider()),
      ],
      child: MyApp(),
    ),
  );
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
        '/saved_template': (context) => SaveTemplate()
      },
    );
  }
}
