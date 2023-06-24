import 'package:flutter/material.dart';
import 'my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor : Colors.black,
      ),
      home: const MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,

    );
  }
}