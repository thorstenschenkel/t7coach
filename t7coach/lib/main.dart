import 'package:flutter/material.dart';
import 'package:t7coach/screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T7 Coach',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,

//          .dark-primary-color { background: #FFA000; }
//          .default-primary-color { background: #FFC107; }
//          .light-primary-color { background: #FFECB3; }
//          .text-primary-color { color: #212121; }
//          .accent-color { background: #FF5722; }
//          .primary-text-color { color: #212121; }
//          .secondary-text-color { color: #757575; }
//          .divider-color { border-color: #BDBDBD; }
      ),
      home: Wrapper(),
    );
  }
}
