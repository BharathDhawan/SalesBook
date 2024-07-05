import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (kIsWeb)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_template');
              },
              child: Text('Property Page'),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/saved_template');
            },
            child: Text('Saved Templates'),
          ),
        ])));
  }
}
